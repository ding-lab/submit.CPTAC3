read -r -d '' USAGE <<'EOF'
stage data by copying source data to target.  Staging directories created
Usage: 
 stage_data.sh [options] analysis_description analysis pipeline_version

analysis_description: File containing details about all output files, as described here: 
    https://docs.google.com/document/d/1Ho5cygpxd8sB_45nJ90d15DcdaGCiDqF0_jzIcc-9B4/edit
analysis: canonical analysis name, e.g., WGS_SV
pipeline_version: a text identifier of this pipeline, used for destination path creation

Output directory is defined as:
  OUTD = $STAGE_ROOT/$DIS/CPTAC3_${DIS}_${ANALYSIS}_${PIPELINE_VER}_${BATCH}_${DATESTAMP}

BATCH
DATESTAMP

Options:
-h: help
-z: compress the file while staging
-f: force overwrite of target even if it exists
-d: dry run.  Only pretend to copy.  Will create manifest
-1: Stop after one case
-D: Prepend case name to data file name
-w: Warn if data file does not exist rather than quitting
-S STAGE_ROOT: staging root directory.  Default: /data
-B BATCH: batch name.  Default "NoBatch"
-s DATESTAMP: Datestamp, of format YYYYMMDD.  Default: "YYYYMMDD"
-P PROCESSING_TXT: Processing description file to be copied to each result directory

Loop across all data files in analysis description file and copy data to staging directory
 * file may have case name prepended
 * file may be compressed
 * Files will be placed in directories according to disease
Create a manifest file at this time, one line generated for every in processing description
 * Requires obtaining file size, md5sum
 * One manifest per disease.  One header per disease.  Will append to any existing data
 * Involves essentially appending to an analysis directory data as described below
Also copy processing description file, if provided, to every directory

Analysis Description File - input format (note output file format)
* 1.Case name 2.Disease 3.Output File Path 4.Output File Format 5.Tumor sample name 6.Tumor BAM UUID 7.Normal sample name 8 Normal BAM UUID

Manifest file - output format
    1. Case name
    2. Disease 
    3.+Data file name
    4.+Filesize
    5.+File format
    6.+md5sum
    7. Tumor sample name
    8. Tumor BAM UUID
    9. Normal sample name
    10.Normal BAM UUID
New fields have + ; Data file name is filename associated Output File Path, with .gz added if compressed
File format is obtained from Analysis Description File

Manifest file is written to every directory, i.e., one will be written per disease

EOF

function test_exit_status {
    # Evaluate return value for chain of pipes; see https://stackoverflow.com/questions/90418/exit-shell-script-based-on-process-exit-code
    rcs=${PIPESTATUS[*]};
    for rc in ${rcs}; do
        if [[ $rc != 0 ]]; then
            NOW=$(date)
            >&2 echo [ $NOW ] $SCRIPT Fatal ERROR.  Exiting.
            exit $rc;
        fi;
    done
}

function confirm {
    FN=$1
    WARN=$2
    NOW=$(date)
    if [ ! -s $FN ]; then
        if [ -z $WARN ]; then
            >&2 echo [ $NOW ] ERROR: $FN does not exist or is empty
            exit 1
        else
            >&2 echo [ $NOW ] WARNING: $FN does not exist or is empty.  Continuing
        fi
    fi
}

function run_cmd {
    CMD=$1

    NOW=$(date)
    if [ "$DRYRUN" == "d" ]; then
        >&2 echo [ $NOW ] Dryrun: $CMD
    else
        >&2 echo [ $NOW ] Running: $CMD
        eval $CMD
        test_exit_status
    fi
}


# CPTAC3 directory, relative to $STAGE_ROOT/$DIS
function get_dest_dir {
    DIS=$1
    ANALYSIS=$2
    PIPELINE_VER=$3
    BATCH=$4
    DATESTAMP=$5
    
    # OUTD = $STAGE_ROOT/$DIS/CPTAC3_${DIS}_${ANALYSIS}_${BATCH}_${DATESTAMP}
    echo CPTAC3_${DIS}_${ANALYSIS}_${PIPELINE_VER}_${BATCH}_${DATESTAMP}
}

# Defaults
STAGE_ROOT="/data"  
BATCH="NoBatch"  
DATESTAMP="YYYYMMDD"  

# http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts ":hzfd1DwS:B:s:P:" opt; do
  case $opt in
    h) # Dry run 
      echo "$USAGE" 
      exit 0
      ;;
    d) # Dry run 
      >&2 echo "Dry run" 
      DRYRUN="d"
      ;;
    z) # compress while copying 
      >&2 echo "Compressing" 
      COMPRESS=1
      ;;
    f)  
      >&2 echo "Force Overwrite" 
      FORCE_OVERWRITE=1
      ;;
    1)  
      STOPATONE=1
      ;;
    D)  
      PREPEND_CASE=1
      ;;
    w) 
      WARN_MISSING=1
      ;;
    S) 
      STAGE_ROOT=$OPTARG
      ;;
    B) 
      BATCH=$OPTARG
      ;;
    s) 
      DATESTAMP=$OPTARG
      ;;
    P) 
      PROCESSING_TXT=$OPTARG
      confirm $PROCESSING_TXT
      ;;
    \?)
      >&2 echo "Invalid option: -$OPTARG" 
      >&2 echo "$USAGE" 
      exit 1
      ;;
    :)
      >&2 echo "Option -$OPTARG requires an argument." 
      >&2 echo "$USAGE" 
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

function process_result {
# for each entry in analysis direcotry file,
# * copy data to staging area, as defined by OUTD
# * write one line of manifest to stdout
    OUTD=$1
    AR="$2"
    
# 1.Case name 2.Disease 3.Output File Path 4.Output File Format 5-. other fields to pass along as-is
    CASE=$( echo "$AD" | cut -f 1  )
    DIS=$( echo "$AD" | cut -f 2  )
    OUT_FN=$( echo "$AD" | cut -f 3  )
    OUT_FF=$( echo "$AD" | cut -f 4  )
    AR_TAIL=$( echo "$AD" | cut -f 5-  )

    if [ ! -e $OUT_FN ]; then  # Might be good to have option here to either warn or quit 
        if [ $WARN_MISSING ]; then
            >&2 echo WARNING: $OUT_FN does not exist.  Continuing
            return
        else
            >&2 echo $OUT_FN does not exist.  Quitting
            exit 1
        fi
    fi
    FN=$( basename $OUT_FN )

    if [ $COMPRESS ]; then
        FN="${FN}.gz"
    fi
    if [ $PREPEND_CASE ]; then
        FN="${CASE}.${FN}"
    fi

    # We are copying OUT_FN to DEST_FN
    DEST_FN="$OUTD/$FN"
    

    if [ -e $DEST_FN ] && [ -s $DEST_FN ];  then  # file exists and is not zero size
        if [  $FORCE_OVERWRITE ]; then
            >&2 echo Destination file $DEST_FN exists.  Overwriting
        else
            >&2 echo Destination file $DEST_FN exists.  Skipping
            return
        fi
    fi

    if [ $COMPRESS ]; then
        >&2 echo Compressing $OUT_FN to $DEST_FN
        CMD="gzip -v - <$OUT_FN > $DEST_FN"
        run_cmd "$CMD"
    else
        >&2 echo Copying $OUT_FN to $DEST_FN
        CMD="cp $OUT_FN $DEST_FN"
        run_cmd "$CMD"
    fi

    # Now evaluate values needed for manifest file
    SIZE=$(stat --printf="%s" $DEST_FN)
    test_exit_status
    MD5=$(md5sum $DEST_FN | cut -f 1 -d ' ')
    test_exit_status

    MANIFEST_LINE=$( printf "$CASE\t$DIS\t$FN\t$SIZE\t$OUT_FF\t$MD5\t$AR_TAIL\n" )
    echo "$MANIFEST_LINE"
}

# stage_data.sh [options] analysis_description analysis pipeline_version

if [ "$#" -ne 3 ]; then
    >&2 echo Error: Require 3 arguments: analysis_description analysis pipeline_version
    >&2 echo Got: $# : $@ 
    >&2 echo "$USAGE"
    exit 1  # exit code 1 indicates error
fi

ANALYSIS_DESCRIPTION=$1  # e.g. WGS-Somatic
ANALYSIS=$2
PIPELINE_VER=$3

# get manifest header.  It is built up of info from analysis description and info from here
# 1.Case name 2.Disease 3.Output File Path 4.Output File Format 5.Tumor sample name 6.Tumor BAM UUID 7.Normal sample name 8 Normal BAM UUID
AR_HEADER=$( head -n 1 $ANALYSIS_DESCRIPTION )
AR_HEADER_TAIL=$( echo "$AR_HEADER" | cut -f 5- )
MAN_HEADER=$( printf "case\tdisease\tfilename\tfilesize\tfile_format\tmd5sum\t$AR_HEADER_TAIL\n" )

echo Writing data to $STAGE_ROOT
mkdir -p $STAGE_ROOT
test_exit_status

# Output directory is $STAGE_ROOT/$DIS/$DESTD
# where DESTD is generated by $( get_dest_dir )
while read AD; do

    [[ $AD = \#* ]] && continue  # Skip commented out entries

    DIS=$( echo "$AD" | cut -f 2  )
    DESTD=$(get_dest_dir $DIS $ANALYSIS $PIPELINE_VER $BATCH $DATESTAMP)
    OUTD=$STAGE_ROOT/$DIS/$DESTD
    MAN="$OUTD/manifest.txt"

    # Test if OUTD exists.  If it does not, create it, and create a manifest.txt header.
    # Also copy processing description file to Output directory, if needed
    if [ ! -d $OUTD ]; then
        >&2 echo OUTD does not exist.  Creating $OUTD
        mkdir -p $OUTD
        test_exit_status

        # Create header for manifest.txt.  Any old one will be silently deleted
        >&2 echo Initializing manifest $MAN
        echo "$MAN_HEADER" > $MAN
        test_exit_status

        # Copy processing description file
        if [ ! -z $PROCESSING_TXT ]; then
            >&2 echo Copying $PROCESSING_TXT to $OUTD
            cp $PROCESSING_TXT $OUTD
            test_exit_status
        fi
    fi

    process_result $OUTD "$AD" >> $MAN

    if [ $STOPATONE ]; then
        >&2 echo Stopping after one
        exit 0  # 0 indicates no error 
    fi

done < $ANALYSIS_DESCRIPTION
