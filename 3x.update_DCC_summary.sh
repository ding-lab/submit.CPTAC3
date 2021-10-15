# Create DCC Analysis Summary file without modifying data in STAGE_ROOT

# NOte, this is done only for old submissions where DCC analysis summary file was not created during staging,
# or when the DCC analysis summary file was corrupted or lost
# 

mkdir -p ./dat

bash 1_prep_submission.sh -MNC $@
