# stage data by copying source data to target.  Staging directories created
# Usage: 
#  write_manifest.sh [options] analysis source-es reference pipeline_version
#
# analysis: canonical analysis name, e.g., WGS-Germline
# source-es: experimental strategy of input data: WGS or WXS typically
# reference: the reference used in this analysis.  e.g., 'hg19'
# pipeline_version: a text identifier of this pipeline, used for destination path creation

# The parameter "-t manifest_type" determines the data files associated with analysis for this case
# The following types are known: cnv, germline, somatic, tumor, RNA-Seq
#  * germline: normal sample associated with each case
#  * tumor: tumor sample associated with each case
#  * somatic: a paired tumor and normal sample associated with each case
#  * cnv: tumor and normal samples are analyzed individually for each case
#  * RNA-Seq: two FASTQ data files (R1, R2) associated with each case
# Development notes: Ideally, upstream analyses should report explicitly what files they used, rather than us
# having to assume it here.  In particular, adjacent normal analysis may complicate this scheme significantly
#
# Options:
# -1: Stop after one case
# -t manifest_type: See above.  somatic is default
# -y filetype: the type of data, e.g., 'maf' or 'vcf', as output in manifest. Default is 'vcf'
# -s file_suffix: Used to construct data filename, as ANALYSIS.CASE.SUFFIX
#       If not defined, set to value of filetype

# Manifest columns - note this differs slightly based on manifest_type
# * cancer
# * case_ID
# * input_experimental_strategy
# * tumor_submitter_id          Varies with manifest_type
# * tumor_UUID                  Varies with manifest_type
# * normal_submitter_id         Varies with manifest_type
# * normal_UUID                 Varies with manifest_type
# * reference_version
# * file_type
# * file_name
# * file_size
# * md5sum

source batch_config.sh

# Old versions of BamMap have 9 columns.  Newer versions have filesize column, and 10 columns in all
# UUID is the last column. Here, we simply hard code it, with the understanding that this will be changed to 10
# once upstream analyses stabilize
UUID_COL=10

# Write to stdout manifest details for given case, provided that case cancer matches requested disease
function process_case {
CASE=$1
COI=$2  # the cancer of interest we wish to retain
TUMOR_SUFFIX=$3  # T or N if MANIFEST_TYPE=cnv, ignored otherwise
    # see stage_data.sh comments for comments about multiple results per case

# Batch 2 SR has Sample Name as first column, followed by case and disease
CANCER=$(cut -f 2,3 $SR | grep $CASE | cut -f 2 | sort -u)

# Skip without writing if cancer types differ
if [ ! $COI == $CANCER ]; then
    return
else
    ONELINEDONE=1   # this lets us quit when one line has been printed
fi

>&2 echo Processing $CASE \($CANCER\)

# Taking advantage of logic used to build sample name, which separates tumor and normal. E.g.,
# C3L-00010.WXS.T
# C3L-00010.WXS.N
# incorporate this into logic
    # C3L-000010.RNA-Seq.R1.T
    # C3L-000010.RNA-Seq.R2.T

if [[ $MANIFEST_TYPE == "RNA-Seq" ]]; then
    R1SN="${CASE}.RNA-Seq.R1.T"
    R1UUID=$(grep $R1SN $BAMMAP | cut -f $UUID_COL)
    if [ -z $R1UUID ]; then  # want to catch unmatched sample name because it leads to confusing errors downstream
        >&2 echo Entry for $R1SN not found in $BAMMAP
        exit 1
    fi
    R1FN=$(grep $R1SN $BAMMAP | cut -f 6 | xargs basename )
    R2SN="${CASE}.RNA-Seq.R2.T"
    R2UUID=$(grep $R2SN $BAMMAP | cut -f $UUID_COL)
    R2FN=$(grep $R2SN $BAMMAP | cut -f 6 | xargs basename )


else  # Using WGS/WXS BAM files.  Find tumor and normal samples in BamMap and add them to manifest as appropriate for analysis type
      # Note that we are *assuming* what the upstream analysis did; it would be better if they provided us this list
    TSN="${CASE}.${SOURCE_ES}.T"
    TUUID=$(grep $TSN $BAMMAP | cut -f $UUID_COL)
    if [ -z $TUUID ]; then  # want to catch unmatched sample name because it leads to confusing errors downstream
        >&2 echo Entry for $TSN not found in $BAMMAP
        exit 1
    fi
    TFN=$(grep $TSN $BAMMAP | cut -f 6 | xargs basename )

    NSN="${CASE}.${SOURCE_ES}.N"
    NUUID=$(grep $NSN $BAMMAP | cut -f $UUID_COL)
    if [ -z $NUUID ]; then
        >&2 echo Entry for $NSN not found in $BAMMAP
        exit 1
    fi
    NFN=$(grep $NSN $BAMMAP | cut -f 6 | xargs basename )
fi
 
# Constructing FN as generated during staging

# Note that file suffix can be different from filetype; file suffix is the
# ending of the data file, while filetype is a (possibly unrelated) file
# type identifier. These are often the same. 

if [[ $MANIFEST_TYPE == "cnv" ]]; then
    FN="$ANALYSIS.${CASE}.${TUMOR_SUFFIX}.${FILE_SUFFIX}"
else
    #   `Somatic.WXS/C3L-00010.maf
    FN="$ANALYSIS.${CASE}.${FILE_SUFFIX}"
fi
DESTD=$(getd $CANCER $ANALYSIS $PIPELINE_VER)
DESTFN="$DESTD/$FN"  # this is the staged filename

if [ ! -e $DESTFN ] ; then
    >&2 echo $DESTFN does not exist
    exit
fi
SIZE=$(stat --printf="%s" $DESTFN)
MD5=$(md5sum $DESTFN | cut -f 1 -d ' ')

# Somatic
if [[ $MANIFEST_TYPE == "somatic" ]]; then
    printf "$CANCER\t$CASE\t$SOURCE_ES\t$TFN\t$TUUID\t$NFN\t$NUUID\t$REF\t$FILETYPE\t$FN\t$SIZE\t$MD5\n" 
elif [[ $MANIFEST_TYPE == "germline" ]]; then
    printf "$CANCER\t$CASE\t$SOURCE_ES\t$NFN\t$NUUID\t$REF\t$FILETYPE\t$FN\t$SIZE\t$MD5\n" 
elif [[ $MANIFEST_TYPE == "tumor" ]]; then
    printf "$CANCER\t$CASE\t$SOURCE_ES\t$TFN\t$TUUID\t$REF\t$FILETYPE\t$FN\t$SIZE\t$MD5\n" 
elif [[ $MANIFEST_TYPE == "cnv" ]]; then
    if [[ $TUMOR_SUFFIX == "T" ]]; then
        printf "$CANCER\t$CASE\t$SOURCE_ES\t$TFN\t$TUUID\t$REF\t$FILETYPE\t$FN\t$SIZE\t$MD5\n" 
    else
        printf "$CANCER\t$CASE\t$SOURCE_ES\t$NFN\t$NUUID\t$REF\t$FILETYPE\t$FN\t$SIZE\t$MD5\n" 
    fi
elif [[ $MANIFEST_TYPE == "RNA-Seq" ]]; then
    printf "$CANCER\t$CASE\t$SOURCE_ES\t$R1FN\t$R1UUID\t$R2FN\t$R2UUID\t$REF\t$FILETYPE\t$FN\t$SIZE\t$MD5\n"
else
    &>2 echo Unknown manifest type: $MANIFEST_FN
fi
}


# First write the header, then loop over each case and write manifest line
function write_disease_manifest {
COI=$1  # The cancer of interest we wish to retain

DESTD=$(getd $COI $ANALYSIS $PIPELINE_VER)
MANIFEST_FN="$DESTD/manifest.$ANALYSIS.$PROJECT.$COI.dat"

if [[ $MANIFEST_TYPE == "somatic" ]]; then
    HEADER="cancer\tcase_ID\tinput_experimental_strategy\ttumor_submitter_id\ttumor_UUID\tnormal_submitter_id\tnormal_UUID\treference_version\tfile_type\tfile_name\tfile_size\tmd5sum\n" 
elif [[ $MANIFEST_TYPE == "germline" ]]; then
    HEADER="cancer\tcase_ID\tinput_experimental_strategy\tnormal_submitter_id\tnormal_UUID\treference_version\tfile_type\tfile_name\tfile_size\tmd5sum\n" 
elif [[ $MANIFEST_TYPE == "tumor" ]]; then
    HEADER="cancer\tcase_ID\tinput_experimental_strategy\ttumor_submitter_id\ttumor_UUID\treference_version\tfile_type\tfile_name\tfile_size\tmd5sum\n" 
elif [[ $MANIFEST_TYPE == "cnv" ]]; then
    # we're changing to "input_UUID", etc., to avoid confusion since both tumor and normal have separate results
    HEADER="cancer\tcase_ID\tinput_experimental_strategy\tinput_submitter_id\tinput_UUID\treference_version\tfile_type\tfile_name\tfile_size\tmd5sum\n" 
elif [[ $MANIFEST_TYPE == "RNA-Seq" ]]; then
    HEADER="cancer\tcase_ID\tinput_experimental_strategy\tR1_submitter_id\tR1_UUID\tR2_submitter_id\tR2_UUID\treference_version\tfile_type\tfile_name\tfile_size\tmd5sum\n" 
else
    &>2 echo Unknown manifest type: $MANIFSET_TYPE
fi

printf $HEADER > $MANIFEST_FN

while read CASE; do

    [[ $CASE = \#* ]] && continue  # Skip commented out entries

    if [ $MANIFEST_TYPE == "cnv" ]; then
        process_case $CASE $COI T >> $MANIFEST_FN
        process_case $CASE $COI N >> $MANIFEST_FN
    else 
        process_case $CASE $COI X >> $MANIFEST_FN
    fi

    if [ $STOPATONE ] && [ $ONELINEDONE ]; then
        >&2 echo Stopping after one case
        >&2 echo Written to $MANIFEST_FN
        exit 0  # 0 indicates no error 
    fi

done < <(grep -v "^#" $BAMMAP | cut -f 2 | sort -u)  # pull out all case IDs out of BamMap and loop through them

>&2 echo Written to $MANIFEST_FN
}

# Default manifest type
MANIFEST_TYPE="somatic"
FILETYPE="vcf"

# http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts ":1t:y:s:" opt; do
  case $opt in
    1)  
      STOPATONE=1
      ;;
    t) 
      MANIFEST_TYPE=$OPTARG
      ;;
    y) 
      FILETYPE=$OPTARG
      ;;
    s) 
      FILE_SUFFIX=$OPTARG
      ;;
    \?)
      >&2 echo "Invalid option: -$OPTARG" 
      exit 1
      ;;
    :)
      >&2 echo "Option -$OPTARG requires an argument." 
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

# set FILE_SUFFIX to FILETYPE unless it was explicitly defined
if [ -z $FILE_SUFFIX ]; then
    FILE_SUFFIX=$FILETYPE
fi

# Require 3 arguments
if [ "$#" -ne 4 ]; then
    >&2 echo Error: Require 4 arguments: analysis, source-es, reference, pipeline_version
    exit 1  # exit code 1 indicates error
fi

if [[ "$MANIFEST_TYPE" != "somatic" && "$MANIFEST_TYPE" != "germline" && "$MANIFEST_TYPE" != "tumor" \
        && "$MANIFEST_TYPE" != "cnv" && "$MANIFEST_TYPE" != "RNA-Seq" ]]; then
    >&2 echo Error: unknown manifest type : $MANIFEST_TYPE
    >&2 echo Must be one of : somatic, germline, tumor, cnv, RNA-Seq
    exit 1
fi

ANALYSIS=$1
SOURCE_ES=$2 # "WGS" # Experimental Strategy
REF=$3 # "hg19"      # Reference
PIPELINE_VER=$4      # e.g., "v1.0"

for COI in $DISEASES; do
    write_disease_manifest $COI
done
