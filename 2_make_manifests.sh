
#  Germline
ANALYSIS="WGS_Germline"
SOURCE_ES="WGS" # Experimental Strategy
REF="hg19"      # Reference
MANIFEST_TYPE="germline"
RESULT_SUFFIX="vcf.gz"
PIPELINE_VER="v1.1"
bash ./submit.CPTAC3/write_manifest.sh -t $MANIFEST_TYPE -y $RESULT_SUFFIX $ANALYSIS $DATD $SOURCE_ES $REF $PIPELINE_VER

## Somatic
ANALYSIS="WGS_Somatic"
SOURCE_ES="WGS" 
REF="hg19"      
MANIFEST_TYPE="somatic"
RESULT_SUFFIX="maf"
PIPELINE_VER="v1.1"
bash ./submit.CPTAC3/write_manifest.sh -t $MANIFEST_TYPE -y $RESULT_SUFFIX $ANALYSIS $DATD $SOURCE_ES $REF $PIPELINE_VER
