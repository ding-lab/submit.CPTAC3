# Create DCC Analysis Summary file without modifying data in STAGE_ROOT

# NOte, this is done only for old submissions where analysis summary file was not created during staging
# 

mkdir -p ./dat

bash 1_prep_submission.sh -MNC $@
