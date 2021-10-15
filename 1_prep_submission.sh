mkdir -p dat

# prepend tissue type to case name for RNA-Seq_Transcript
ARG="-x 5"

# prep_submission.sh reads analyses.dat, batch.dat, system.dat
src/prep_submission.sh $ARG -C $@

>&2 echo NOTE: any DCC analysis summary files written now 
>&2 echo will be appended to if this script is run again
>&2 echo To avoid corruption, delete any existing DCC analysis
>&2 echo files

# The reason this is not easy to fix is because the analysis.dat file can have any number of 
# pipelines, and if 2+ batches of the same pipeline are processed then it is expected that
# the results will accumulate.  In this scenario, it is expected that an existing analysis
# summary file is appended to.  This can lead to corruption, though, if the same data is
# staged multiple times; each invocation will append to the DCC analysis summary file
# In most cases, easiest is to just remove duplicate lines
