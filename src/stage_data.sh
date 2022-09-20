read -r -d '' USAGE <<'EOF'
stage data by copying source data to target.  Staging directories created
Usage: 
 stage_data.sh [options] analysis_summary analysis pipeline_version

analysis_summary: File containing details about all output files, as described here: 
    https://docs.google.com/document/d/1Ho5cygpxd8sB_45nJ90d15DcdaGCiDqF0_jzIcc-9B4/edit
    Note that using updated format which starts with run_name (though run_name not currently used)
analysis: canonical analysis name, e.g., WGS_SV
pipeline_version: a text identifier of this pipeline, used for destination path creation

Output directory is defined as:
  OUTD = $STAGE_ROOT/$DCC_PREFIX/$DIS/CPTAC3_${DIS}_${ANALYSIS}_${PIPELINE_VER}_${BATCH}_${DATESTAMP}

Options:
-h: help
-z: compress the file while staging
-f: force overwrite of target even if it exists
-d: dry run.  Only pretend to copy.  Will create manifest
-1: Stop after one case
-D: Prepend run name to data file name
-w: Warn if data file does not exist rather than quitting
-S STAGE_ROOT: staging root directory.  Default: /data
-R DCC_PREFIX: Root directory on DCC.  Optional
-B BATCH: batch name.  Default "NoBatch"
-Y C3Y: indicates "CPTAC3 Year" and takes values `Y1`, `Y2`, etc.  Default: Y0
-s DATESTAMP: Datestamp, of format YYYYMMDD.  Default: "YYYYMMDD"
-P PROCESSING_TXT: Processing description file to be copied to each result directory
-C DCC_SUMMARY: If defined, write DCC Analysis Summary file to given filename
-M: NO_COPY  Do not copy data or processing description, but create manifest and, if requested, DCC summary files.
    This is a special mode for generating manifest without touching data.  Note that manifest file will be appended to if it exists
-N: Don't write manifest (though DCC_SUMMARY will be written as requested)
-m MANIFEST_FILENAME: manifest filename.  Default: "manifest.txt"
-x XF: prepend value of column XF from AR file to output filename

Loop across all data files in analysis summary file and copy data (result file) to staging directory
 * optionally prepend case name to results file
   * optionally prepend value of XF AR field to name of results file
   * This allows output filenames to be unique even if multiple outputs per case
 * optionally compress results file 
 * result files will be copied to per-disease output directories 
Create a manifest file, one line for every entry (result file) in analysis summary
 * obtains file size and calculates md5sum
 * One manifest per disease.  One header per manifest  Appends to an existing manifest file
Copy processing description file, if provided, to every directory
Optionally write DCC_SUMMARY file which provides details about result files on DCC.
  If this file exists, append to it

Example per-analysis-directory = CPTAC3_GBM_WGS_CNV_Somatic_v2.0_Y2.b1_20190405

Analysis Description File - input format (note output file format)
* 1.Case name 2.Disease 3.Output File Path 4.Output File Format 
* Remaining fields are variable, for example: 5.Tumor sample name 6.Tumor BAM UUID 7.Normal sample name 8 Normal BAM UUID

Manifest file - output format
    1. Case name
    2. Disease 
    3. Data file name
    4. Filesize
    5. File format
    6. md5sum
    7. Tumor sample name    (variable)
    8. Tumor BAM UUID       (variable)
    9. Normal sample name   (variable)
    10.Normal BAM UUID      (variable)
Fields 7+ are pipeline-specific and obtained from analysis summary file
Data file name is filename associated Output File Path, with .gz added if compressed
File format is obtained from Analysis Description File

Manifest file is written to every directory, i.e., one will be written per disease

DCC Analysis Summary file has the following fields:
 1. case
 2. disease
 3. pipeline_name
 4. pipeline_version
 5. timestamp
 6. C3Y
 7. DCC_path
 8. filesize
 9. file_format
10. md5sum

Additional (variable) fields are as in manifest file

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
MANIFEST_FILENAME="manifest.txt"  
C3Y="Y0"  

# http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts ":hzfd1DwS:B:s:P:C:NMm:R:Y:x:" opt; do
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
      PREPEND_RUNNAME=1
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
    C) 
      DCC_SUMMARY=$OPTARG
      ;;
    N)  # Idea is to allow DCC summary to be written without modifying exising data
      NO_MANIFEST=1
      ;;
    M) 
      NO_COPY=1
      ;;
    m) 
      MANIFEST_FILENAME=$OPTARG
      ;;
    R) 
      DCC_PREFIX=$OPTARG
      ;;
    Y) 
      C3Y=$OPTARG
      ;;
    x) 
      XF=$OPTARG
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
# * return information needed to construct one line in manifest and DCC_summary files
    OUTD=$1
    DCC_OUTD=$2
    AR="$3"

# 1. run name 2.Case name 3.Disease 4.Output File Path 5.Output File Format 6-. other fields to pass along as-is
    RUN_NAME=$( echo "$AR" | cut -f 1  )
    CASE=$( echo "$AR" | cut -f 2  )
    DIS=$( echo "$AR" | cut -f 3  )
    OUT_FN=$( echo "$AR" | cut -f 4  )
    OUT_FF=$( echo "$AR" | cut -f 5  )
    AR_TAIL=$( echo "$AR" | cut -f 6-  )

    if [ ! -e $OUT_FN ]; then  # Have option here to either warn or quit 
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
    if [ ! -z $XF ]; then
        OUT_XF=$( echo "$AR" | cut -f $XF  )
        FN="${OUT_XF}.${FN}"
    fi
    if [ $PREPEND_RUNNAME ]; then
        FN="${RUN_NAME}.${FN}"
    fi

    # We are copying OUT_FN to DEST_FN
    DEST_FN="$OUTD/$FN"
    DCC_FN="$DCC_OUTD/$FN"

    # If "manifest only", we don't copy data but assume it is there.
    if [ -z $NO_COPY ]; then  
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
    else
        >&2 echo Not copying data, testing to make sure it exists
        if [ ! -e $DEST_FN ]; then  
            if [ $WARN_MISSING ]; then
                >&2 echo WARNING: $DEST_FN does not exist.  Continuing
                return
            else
                >&2 echo $DEST_FN does not exist.  Quitting
                exit 1
            fi
        fi
    fi

    # Now evaluate values needed for manifest file
	# If DRYRUN, evaluate only if files exist (they may not)
    # otherwise assume files exist
    if [ ! -f $DEST_FN ]; then
        if [ $DRYRUN ]; then
            SIZE="unknown"
            MD5="unknown"
        else
            >&2 echo ERROR: $DEST_FN does not exist
            exit 1
        fi
    else
        SIZE=$(stat --printf="%s" $DEST_FN)
        test_exit_status
        MD5=$(md5sum $DEST_FN | cut -f 1 -d ' ')
        test_exit_status
    fi

# The following variables read as globals are needed for DCC_LINE
# ANALYSIS
# PIPELINE_VER
# DATESTAMP
    MANIFEST_DATA=$( printf "$DCC_FN\t$CASE\t$DIS\t$FN\t$SIZE\t$OUT_FF\t$MD5\t$AR_TAIL\n" )
#    DCC_LINE=$( printf "$CASE\t$DIS\t$ANALYSIS\t$PIPELINE_VER\t$DATESTAMP\t$DCC_FN\t$SIZE\t$OUT_FF\t$MD5\t$AR_TAIL\n" )

    echo "$DCC_FN" "$CASE" "$DIS" "$FN" "$SIZE" "$OUT_FF" "$MD5" "$AR_TAIL"
}

# stage_data.sh [options] analysis_summary analysis pipeline_version

if [ "$#" -ne 3 ]; then
    >&2 echo Error: Require 3 arguments: analysis_summary analysis pipeline_version
    >&2 echo Got: $# : $@ 
    >&2 echo "$USAGE"
    exit 1  # exit code 1 indicates error
fi

ANALYSIS_SUMMARY=$1  
ANALYSIS=$2
PIPELINE_VER=$3

# get manifest header.  It is built up of info from analysis summary and info from here
# mandatory : 1. Run name 2.Case name 3.Disease 4.Output File Path 5.Output File Format 
# variable, e.g. : 6.Tumor sample name 7.Tumor BAM UUID 7.Normal sample name 8 Normal BAM UUID
# Currently, run name is ignored
AR_HEADER=$( head -n 1 $ANALYSIS_SUMMARY )
AR_HEADER_TAIL=$( echo "$AR_HEADER" | cut -f 6- )
MAN_HEADER=$( printf "# case\tdisease\tfilename\tfilesize\tfile_format\tmd5sum\t$AR_HEADER_TAIL\n" )
DCC_HEADER=$( printf "# case\tdisease\tpipeline_name\tpipeline_version\ttimestamp\tC3Y\tDCC_path\tfilesize\tfile_format\tmd5sum\t$AR_HEADER_TAIL\n" )

echo STAGE_ROOT = $STAGE_ROOT
mkdir -p $STAGE_ROOT
test_exit_status

# Output directory is $STAGE_ROOT/$DCC_PREFIX/$DIS/$DESTD
# where DESTD is generated by $( get_dest_dir )

# Initialize DCC_SUMMARY file if it does not exist.  If it does, simply append to it later,
# since this may be written to more than once during staging
if [ ! -z $DCC_SUMMARY ]; then
    if [ ! $DRYRUN ]; then
        if [ ! -f $DCC_SUMMARY ]; then
            # Create header for DCC Analysis Summary 
            >&2 echo Initializing DCC Analysis Summary $DCC_SUMMARY
            echo "$DCC_HEADER" > $DCC_SUMMARY
            test_exit_status
        else
            >&2 echo NOTE: DCC Analysis Summary $DCC_SUMMARY exists.  Appending
        fi
    fi
fi

# Loop over all entries in an analysis summary file
# skip first line whether comment or not
# https://www.unix.com/unix-for-dummies-questions-and-answers/170787-skip-first-line-when-doing-read-csv-file.html
sed 1d $ANALYSIS_SUMMARY | while read AD; do

    [[ $AD = \#* ]] && continue  # Skip commented out entries

    DIS=$( echo "$AD" | cut -f 3  )
    DESTD=$(get_dest_dir $DIS $ANALYSIS $PIPELINE_VER $BATCH $DATESTAMP)
    # OUTD is the full path to where this file will be staged
    OUTD=$STAGE_ROOT/$DCC_PREFIX/$DIS/$DESTD
    MAN="$OUTD/$MANIFEST_FILENAME"
    # Directory relative to DCC.  Essentially OUTD with STAGE_ROOT = /
    DCC_DATD="/$DCC_PREFIX/$DIS/$DESTD"


    # If dry run, spit out some additional details
    if [ $DRYRUN ]; then
        >&2 echo Manifest path: $MAN
        if [ ! -z $DCC_SUMMARY ]; then
            >&2 echo DCC analysis summary path: $DCC_SUMMARY
        fi
    fi

    # Test if OUTD exists.  If it does not, create it, and create a manifest.txt header.
    # Also copy processing summary file to Output directory, if needed
    if [ ! -d $OUTD ] ; then
        >&2 echo OUTD does not exist.  Creating $OUTD
        mkdir -p $OUTD
        test_exit_status

        if [ ! $NO_MANIFEST ]; then
            # Create header for manifest.txt.  Any old one will be silently deleted
            >&2 echo Initializing manifest $MAN
            echo "$MAN_HEADER" > $MAN
            test_exit_status
        else
            >&2 echo Skipping manifest writing
        fi

        # Copy processing description file
        if [ -z $NO_COPY ]; then
            if [ ! -z $PROCESSING_TXT ]; then
                if [ ! -f $PROCESSING_TXT ]; then
                    >&2 echo Error: Processing description does not exist: $PROCESSING_TXT
                    exit 1
                fi
                >&2 echo Copying $PROCESSING_TXT to $OUTD
                cp $PROCESSING_TXT $OUTD
                test_exit_status
            fi
        fi
    fi

    # from https://stackoverflow.com/questions/2488715/idioms-for-returning-multiple-values-in-shell-scripting
    read DCC_FN CASE DIS FN SIZE OUT_FF MD5 AR_TAIL < <( process_result $OUTD $DCC_DATD "$AD" )
    test_exit_status

    MAN_LINE=$( printf "$CASE\t$DIS\t$FN\t$SIZE\t$OUT_FF\t$MD5\t$AR_TAIL\n" )

# The following variables read as globals are needed for DCC_LINE
# ANALYSIS PIPELINE_VER DATESTAMP C3Y
    DCC_LINE=$( printf "$CASE\t$DIS\t$ANALYSIS\t$PIPELINE_VER\t$DATESTAMP\t$C3Y\t$DCC_FN\t$SIZE\t$OUT_FF\t$MD5\t$AR_TAIL\n" )

    if [ "$DRYRUN" == "d" ]; then
        >&2 echo Dryrun: adding manifest line: $MAN_LINE
        if [ ! -z $DCC_SUMMARY ]; then
            >&2 echo Dryrun: adding DCC Summary line: $DCC_LINE
        fi
    else
        if [ -z $NO_MANIFEST ]; then
            echo "$MAN_LINE" >> $MAN
        fi
        if [ ! -z $DCC_SUMMARY ]; then
            echo "$DCC_LINE" >> $DCC_SUMMARY
        fi
    fi

    if [ $STOPATONE ]; then
        >&2 echo Stopping after one
        exit 0  # 0 indicates no error 
    fi

#done < $ANALYSIS_SUMMARY
done 

>&2 echo Data staged to subdirectories of $STAGE_ROOT
