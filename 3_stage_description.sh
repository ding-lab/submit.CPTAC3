
#  WGS Germline
DAT="/gscmnt/gc2533/dinglab/scao/cptac3/batch2/wgs/germline_per_sample/processing_description.txt"
ANALYSIS="WGS_Germline"
PIPELINE_VER="v1.1"
bash ./submit.CPTAC3/stage_description.sh $ANALYSIS $DAT $PIPELINE_VER

#  WGS Germline
DAT="/gscuser/scao/gc2521/dinglab/scao/cptac3/wgs/somatic_per_sample/processing_description_121517.txt"
ANALYSIS="WGS_Somatic"
PIPELINE_VER="v1.1"
bash ./submit.CPTAC3/stage_description.sh $ANALYSIS $DAT $PIPELINE_VER
