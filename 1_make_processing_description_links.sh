
OUTD="processing_description"
mkdir -p $OUTD

# WXS Germline
DAT="/gscmnt/gc2521/dinglab/scao/cptac3/wxs/germline_per_sample/processing_description_121517.txt"
cp $DAT "$OUTD/WXS-Germline.description.txt"

# Fusion 
DAT="/gscmnt/gc2521/dinglab/qgao/Scripts/Fusion/fusion_worklog"
cp $DAT "$OUTD/Fusion.description.txt"

