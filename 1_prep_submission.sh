mkdir -p dat

# prepend tissue type to case name for RNA-Seq_Transcript
# ARG="-x 5"

# prep_submission.sh reads analyses.dat, batch.dat, system.dat
src/prep_submission.sh $ARG -C $@
