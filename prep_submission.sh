# Prepare submitted CPTAC3 analysis data and upload to DCC
# Preparation takes three steps:
# 1. Stage the data.  This involves copying data, possibly compressing it, and converting to standardized filename
# 2. Create manifest.  This also requires what datatypes (e.g., tumor + normal) used for the analysis
# 3. Add processing description.  This is typically just copied from file provided by analysts
# Data are uploaded following data preparation.

# Usage:
#   1_prep_submission.sh [options] step
# where step is one of stage, manifest, or description
# options:
# -1: process just one step and stop
# -d: dry run.  Print out what would be done, but don't do anything

ARGS=""
# http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts ":d1" opt; do
  case $opt in
    d)  
      echo "Dry run" >&2
      ARGS="$ARGS -d" 
      ;;
    1) 
      echo "Stop after one" >&2
      ARGS="$ARGS -1" 
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

if [ "$#" -ne 1 ]; then
    >&2 echo Error: Wrong number of arguments
    >&2 echo Error: Must specify step as one of stage, manifest, or description
    exit 1
fi

STEP=$1
if [ $STEP != "stage" ] && [ $STEP != "manifest" ] && [ $STEP != "description" ]; then
    >&2 echo Error: Must specify step as one of stage, manifest, or description
    exit 1
fi


ANALYSES="analyses.dat"
# Columns in data file
    # ANALYSIS
    # PIPELINE_VER
    # DATD
    # PROCESSING_TXT
    # REF
    # PIPELINE

source batch_config.sh

## use to pass -d -1 and other debugging flags
#SCRIPT_ARGS="$@"

while read i; do

    ANALYSIS=$( echo "$i" | cut -f 1 )
    PIPELINE_VER=$( echo "$i" | cut -f 2 )
    DATD=$( echo "$i" | cut -f 3  )
    PROCESSING_TXT=$( echo "$i" | cut -f 4  )
    REF=$( echo "$i" | cut -f 5  )
    PIPELINE_DAT=$( echo "$i" | cut -f 6  )

    if [ ! -e $PIPELINE_DAT ]; then
        >&2 echo Error: Pipeline file $PIPELINE_DAT does not exist
        exit 1
    fi
    source $PIPELINE_DAT

    if [ $STEP == "stage" ]; then
        STEP_ARGS=$ARGS
        if [ $IS_COMPRESSED == 1 ]; then
            STEP_ARGS="$STEP_ARGS -z"
        fi
        if [ $IS_SEPARATE_TUMOR_NORMAL == 1 ]; then
            STEP_ARGS="$STEP_ARGS -T"
        fi
        bash ./submit.CPTAC3/stage_data.sh $STEP_ARGS $ANALYSIS $DATD $INPUT_SUFFIX $OUTPUT_SUFFIX $SOURCE_ES $PIPELINE_VER
    elif [ $STEP == "manifest" ]; then
        bash ./submit.CPTAC3/write_manifest.sh $ARGS -t $MANIFEST_TYPE -y $RESULT_SUFFIX $ANALYSIS $SOURCE_ES $REF $PIPELINE_VER
    elif [ $STEP == "description" ]; then
        bash ./submit.CPTAC3/stage_description.sh $ARGS $ANALYSIS $PROCESSING_TXT $PIPELINE_VER
    fi

done < <(sed 's/#.*$//' $ANALYSES | sed '/^\s*$/d' )  # skip comments and blank lines. May require `set +o posix`

