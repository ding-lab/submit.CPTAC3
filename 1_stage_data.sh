
ANALYSIS="WXS_Germline"
ES="WXS"
DATD="/gscmnt/gc2741/ding/scao/cptac3/batch2/wxs/germline_per_sample"
INPUT_SUFFIX="Germline.WXS.maf"
OUTPUT_SUFFIX="maf"
# -z to compress while staging
ARGS="-z "

bash ./submit.CPTAC3/stage_data.sh $ARGS $ANALYSIS $DATD $INPUT_SUFFIX $OUTPUT_SUFFIX $ES

## WXS Somatic
ANALYSIS="WXS_Somatic"
ES="WXS"
DATD="/gscmnt/gc2741/ding/scao/cptac3/batch2/wxs/somatic_per_sample"
INPUT_SUFFIX="Somatic.WXS.maf"
OUTPUT_SUFFIX="maf"
# -z to compress while staging
ARGS="-z "

bash ./submit.CPTAC3/stage_data.sh $ARGS $ANALYSIS $DATD $INPUT_SUFFIX $OUTPUT_SUFFIX $ES
