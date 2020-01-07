BATCH_DAT="batch.dat"
SYSTEM_DAT="system.dat"
ANALYSES_DAT="analyses.dat"

source $BATCH_DAT # defines DATESTAMP, BATCH
test_exit_status

source $SYSTEM_DAT $LOCALE # defines STAGE_ROOT, 
test_exit_status

function merge_analysis {
    ANALYSIS=$1

    DCC_MASTER="$CATALOGD/DCC_Analysis_Summary/${ANALYSIS}.DCC_analysis_summary.dat"

    # If no errors, write merged DCC analysis summary, which is DCC analysis summary and DCC_MASTER concatenated and sorted
    # The output filename will be $BAMMAP.merged
    # If master BAMMAP not defined, exit with no error; if defined but not exist, exit with error
    if [ ! -e $DCC_MASTER ]; then
        >&2 echo Error: DCC master defined but does not exist.  Exiting
        >&2 echo DCC_MASTER: $DCC_MASTER
        exit 1
    fi

    # DCC as written
    DCC="dat/${ANALYSIS}.DCC_analysis_summary.dat"
    DCC_MERGED="dat/${ANALYSIS}.MERGED.DCC_analysis_summary.dat"

    head -n1 $DCC_MASTER > $DCC_MERGED
    cat $DCC_MASTER $DCC | grep -v "^#" | sort -u >> $DCC_MERGED

    >&2 echo Batch DCC_Analysis_Summary: $DCC 
    >&2 echo Master DCC_Analysis_Summary: $DCC_MASTER
    >&2 echo Merged DCC_Analysis_Summary: $DCC_MERGED
    >&2 echo Examine and copy Master to Merged 
    >&2 printf "\n"
}


# Iterate over all entries in analyses.dat
while read i; do
    ANALYSIS=$( echo "$i" | cut -f 1 )

    >&2 echo Processing $ANALYSIS
    merge_analysis $ANALYSIS


done < <(sed 's/#.*$//' $ANALYSES_DAT | sed '/^\s*$/d' )  # skip comments and blank lines. May require `set +o posix`

