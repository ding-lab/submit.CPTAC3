mkdir -p dat

# prep_submission.sh reads analyses.dat, batch.dat, system.dat
src/prep_submission.sh -C $@
