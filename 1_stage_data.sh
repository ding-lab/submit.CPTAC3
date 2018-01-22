# Go through all cases and make links to WXS-Germline data

# Where Song deposited result data, filename e.g., C3L-00010.maf
ANALYSIS="WGS-Germline"
DATD="/gscmnt/gc2521/dinglab/scao/cptac3/wgs/germline_per_sample"
bash ./stage_VCF.sh $ANALYSIS $DATD


ANALYSIS="WGS-Somatic"
DATD="/gscuser/scao/gc2521/dinglab/scao/cptac3/wgs/somatic_per_sample"
bash ./stage_VCF.sh $ANALYSIS $DATD
