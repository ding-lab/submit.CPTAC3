BATCH_DAT="batch.dat"
SYSTEM_DAT="system.dat"
ANALYSES_DAT="analyses.dat"

function test_exit_status {
    # Evaluate return value for chain of pipes; see https://stackoverflow.com/questions/90418/exit-shell-script-based-on-process-exit-code
    rcs=${PIPESTATUS[*]};
    for rc in ${rcs}; do
        if [[ $rc != 0 ]]; then
            >&2 echo Fatal error.  Exiting.
            exit $rc;
        fi;
    done
}

source $BATCH_DAT # defines DATESTAMP, BATCH
test_exit_status

source $SYSTEM_DAT $LOCALE # defines STAGE_ROOT, 
test_exit_status

function merge_analysis {
    ANALYSIS=$1

    DCC_MASTER="$CATALOGD/DCC_Analysis_Summary/${ANALYSIS}.DCC_analysis_summary.dat"

    # DCC as written
    DCC="dat/${ANALYSIS}.DCC_analysis_summary.dat"
    DCC_MERGED="dat/${ANALYSIS}.MERGED.DCC_analysis_summary.dat"

    # If no errors, write merged DCC analysis summary, which is DCC analysis summary and DCC_MASTER concatenated and sorted
    # The output filename will be $BAMMAP.merged
    # If master BAMMAP not defined, exit with no error; if defined but not exist, exit with error
    if [ ! -e $DCC_MASTER ]; then
        >&2 echo DCC master does not exist.  Assume new run
        >&2 echo DCC_MASTER: $DCC_MASTER

        >&2 echo Copying $DCC to $DCC_MERGED
        cp $DCC $DCC_MERGED
    else

        >&2 echo Merging existing $DCC_MASTER 
        >&2 echo with $DCC
        >&2 echo Writing to $DCC_MERGED
        head -n1 $DCC_MASTER > $DCC_MERGED
        cat $DCC_MASTER $DCC | grep -v "^#" | sort -u >> $DCC_MERGED

        # Adding this after realizing that inconsistent headers can be silently missed
        >&2 echo Confirm headers are consistent:
        >&2 head -n1 $DCC
        >&2 head -n1 $DCC_MASTER
    fi

#    >&2 echo Batch DCC_Analysis_Summary: $DCC 
#    >&2 echo Master DCC_Analysis_Summary: $DCC_MASTER
#    >&2 echo Merged DCC_Analysis_Summary: $DCC_MERGED
#    >&2 echo Examine and copy Master to Merged 
    >&2 printf "\n"
}


# Iterate over all entries in analyses.dat
while read i; do
    ANALYSIS=$( echo "$i" | cut -f 1 )

    >&2 echo Processing $ANALYSIS
    merge_analysis $ANALYSIS


done < <(sed 's/#.*$//' $ANALYSES_DAT | sed '/^\s*$/d' )  # skip comments and blank lines. May require `set +o posix`

