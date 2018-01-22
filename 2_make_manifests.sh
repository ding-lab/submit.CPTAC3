# Create and stage manifest files for WGS-Germline and WGS-Somatic
# Note that there is one manifest file per disease

ANALYSIS="WGS-Germline"
DATD="/gscmnt/gc2521/dinglab/scao/cptac3/wxs/germline_per_sample"
SOURCE_ES="WGS" # Experimental Strategy
REF="hg19"      # Reference

bash make_germline_manifest.sh $ANALYSIS $DATD $SOURCE_ES $REF

ANALYSIS="WGS-Somatic"
DATD="/gscuser/scao/gc2521/dinglab/scao/cptac3/wgs/somatic_per_sample"
SOURCE_ES="WGS" # Experimental Strategy
REF="hg19"      # Reference

bash make_germline_manifest.sh $ANALYSIS $DATD $SOURCE_ES $REF

