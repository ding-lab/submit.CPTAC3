DAT="/gscmnt/gc2741/ding/scao/cptac3/batch2/wxs/germline_per_sample/processing_description.txt"
ANALYSIS="WXS_Germline"
bash ./submit.CPTAC3/stage_description.sh $ANALYSIS $DAT


DAT="/gscmnt/gc2741/ding/scao/cptac3/batch2/wxs/somatic_per_sample/processing_description.txt"
ANALYSIS="WXS_Somatic"
bash ./submit.CPTAC3/stage_description.sh $ANALYSIS $DAT


