# SV uses both Tumor and Normal WGS data to produce calls.  As a result, using -t somatic

ANALYSIS="WXS_Germline"
SOURCE_ES="WXS" # Experimental Strategy
REF="hg19"      # Reference
MANIFEST_TYPE="germline"
RESULT_SUFFIX="maf.gz"

bash ./submit.CPTAC3/write_manifest.sh -t $MANIFEST_TYPE -y $RESULT_SUFFIX $ANALYSIS $DATD $SOURCE_ES $REF

# 
ANALYSIS="WXS_Somatic"
SOURCE_ES="WXS" # Experimental Strategy
REF="hg19"      # Reference
MANIFEST_TYPE="somatic"
RESULT_SUFFIX="maf.gz"

bash ./submit.CPTAC3/write_manifest.sh -t $MANIFEST_TYPE -y $RESULT_SUFFIX $ANALYSIS $DATD $SOURCE_ES $REF



