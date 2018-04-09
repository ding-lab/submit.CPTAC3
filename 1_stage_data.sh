# TODO:
# source batch_config.sh
# loop over all entries in analyses.dat

# set +o posix  # this might need to be set on OS X 

ANALYSES="analyses.dat"
# Columns in data file
    # ANALYSIS
    # PIPELINE_VER
    # DATD
    # PROCESSING_TXT
    # REF
    # PIPELINE

source batch_config.sh

# use to pass -d -1 and other debugging flags
SCRIPT_ARGS="$@"

while read i; do

    ANALYSIS=$( echo "$i" | cut -f 1 )
    PIPELINE_VER=$( echo "$i" | cut -f 2 )
    DATD=$( echo "$i" | cut -f 3  )
    PIPELINE_DAT=$( echo "$i" | cut -f 6  )

    if [ ! -e $PIPELINE_DAT ]; then
        >&2 echo Error: $PIPELINE_DAT does not exist
        exit 1
    fi
    source $PIPELINE_DAT

    ARGS="$SCRIPT_ARGS"
    if [ $IS_COMPRESSED == 1 ]; then
        ARGS="$ARGS -z"
    fi

    bash ./submit.CPTAC3/stage_data.sh $ARGS $ANALYSIS $DATD $INPUT_SUFFIX $OUTPUT_SUFFIX $ES $PIPELINE_VER
exit

done < <(sed 's/#.*$//' $ANALYSES | sed '/^\s*$/d' )  # skip comments and blank lines

