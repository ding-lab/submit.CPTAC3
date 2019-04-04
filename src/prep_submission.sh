#!/bin/bash

# Matthew Wyczalkowski <m.wyczalkowski@wustl.edu>
# https://dinglab.wustl.edu/

read -r -d '' USAGE <<'EOF'
Prepare submitted CPTAC3 analysis data prior to upload to DCC

Usage:
  prep_submission.sh [options] 
options:
  -h: Print this help message
  -1: process just one step and stop
  -d: dry run.  Print out what would be done, but don't do anything
  -w: Warn if data file missing, rather than quit
  -A ANALYSIS_DAT: path to analyses.dat
  -B BATCH_DAT: Path to batch.dat
  -S SYSTEM_DAT: Path to system.dat

Preparation takes three steps:
1. Stage the data.  This involves copying data, possibly compressing it, and converting to standardized filename
2. Create manifest.  This also requires what datatypes (e.g., tumor + normal) used for the analysis
3. Add processing description.  This is typically just copied from file provided by analysts
Data are uploaded following data preparation.

The file analyses.txt defines the details of each pipeline analysis to upload

EOF

ANALYSES_DAT="analyses.dat"
BATCH_DAT="batch.dat"
SYSTEM_DAT="system.dat"

ARGS=""
# http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts ":hd1wA:B:S:" opt; do
  case $opt in
    h)  
      echo "$USAGE"
      exit 0
      ;;
    d)  
      >&2 echo "Dry run"
      ARGS="$ARGS -d" 
      ;;
    1) 
      >&2 echo "Stop after one"
      ARGS="$ARGS -1" 
      STOPATONE=1
      ;;
    w) 
      >&2 echo "Warn if data missing"
      ARGS="$ARGS -w" 
      ;;
    A) 
      ANALYSES_DAT="$OPTARG"
      confirm $ANALYSES_DAT
      ;;
    B) 
      BATCH_DAT="$OPTARG"
      confirm $BATCH_DAT
      ;;
    S) 
      SYSTEM_DAT="$OPTARG"
      confirm $SYSTEM_DAT
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

function test_exit_status {
    # Evaluate return value for chain of pipes; see https://stackoverflow.com/questions/90418/exit-shell-script-based-on-process-exit-code
    # exit code 137 is fatal error signal 9: http://tldp.org/LDP/abs/html/exitcodes.html

    rcs=${PIPESTATUS[*]}; 
    for rc in ${rcs}; do 
        if [[ $rc != 0 ]]; then 
            >&2 echo Fatal error.  Exiting 
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

source $BATCH_DAT # defines DATESTAMP, BATCH
test_exit_status

source $SYSTEM_DAT $LOCALE # defines STAGE_ROOT, 
test_exit_status

# Content:
# 1. ANALYSIS
# 2. PIPELINE_VER
# 3. ANALYSIS_DESCRIPTION
# 4. PROCESSING_TXT
# 5. REF
# 6. DO_COMPRESS
# 7. PREPEND_CASE

# Iterate over all entries in analyses.dat
while read i; do
# analysis description file columns:


    ANALYSIS=$( echo "$i" | cut -f 1 )
    PIPELINE_VER=$( echo "$i" | cut -f 2 )
    ANALYSIS_DESCRIPTION=$( echo "$i" | cut -f 3  )
    PROCESSING_TXT=$( echo "$i" | cut -f 4  )
    REF=$( echo "$i" | cut -f 5  )
    DO_COMPRESS=$( echo "$i" | cut -f 6  )
    PREPEND_CASE=$( echo "$i" | cut -f 7  )

    confirm $ANALYSIS_DESCRIPTION
    confirm $PROCESSING_TXT

	>&2 echo Processing $ANALYSIS

    if [ $DO_COMPRESS == 1 ]; then
        STEP_ARGS="$STEP_ARGS -z"
    fi
    if [ $PREPEND_CASE == 1 ]; then
        STEP_ARGS="$STEP_ARGS -D"
    fi

    CMD="src/stage_data.sh $ARGS $STEP_ARGS -P $PROCESSING_TXT -S $STAGE_ROOT -s $DATESTAMP -B $BATCH $ANALYSIS_DESCRIPTION $ANALYSIS $PIPELINE_VER"

    >&2 echo Running: $CMD
    eval $CMD
    test_exit_status

    if [ $STOPATONE ]; then
        >&2 echo Stopping after one
        exit 0  # 0 indicates no error 
    fi


done < <(sed 's/#.*$//' $ANALYSES_DAT | sed '/^\s*$/d' )  # skip comments and blank lines. May require `set +o posix`

