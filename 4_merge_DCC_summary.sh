DCC_MASTER="/diskmnt/Projects/cptac_scratch/CPTAC3.workflow/CPTAC3.catalog/DCC_Analysis_Summary/RNA-Seq_Fusion.DCC_analysis_summary.dat"
# If no errors, write merged DCC analysis summary, which is DCC analysis summary and DCC_MASTER concatenated and sorted
# The output filename will be $BAMMAP.merged
# If master BAMMAP not defined, exit with no error; if defined but not exist, exit with error
if [ ! -e $DCC_MASTER ]; then
    >&2 echo Error: DCC master defined but does not exist.  Exiting
    >&2 echo DCC_MASTER: $DCC_MASTER
    exit 1
fi

DCC="dat/RNA-Seq_Fusion.DCC_analysis_summary.dat"
DCC_MERGED="${DCC}.merged"

head -n1 $DCC > $DCC_MERGED
cat $DCC_MASTER $DCC | grep -v "^#" | sort -u >> $DCC_MERGED

>&2 echo $DCC merged with master $DCC_MASTER
>&2 echo and written to merged master $DCC_MERGED
>&2 echo Please examine merged master file and replace original master as appropriate

