
#  MSI
ANALYSIS="WXS_MSI"
SOURCE_ES="WXS" # Experimental Strategy
REF="hg19"      # Reference
MANIFEST_TYPE="tumor"
RESULT_SUFFIX="MSIsensor.dat"
PIPELINE_VER="v1.0"
bash ./submit.CPTAC3/write_manifest.sh -t $MANIFEST_TYPE -y $RESULT_SUFFIX $ANALYSIS $DATD $SOURCE_ES $REF $PIPELINE_VER

## Transcript BED
ANALYSIS="RNA-Seq_Transcript"
SOURCE_ES="RNA-Seq" 
REF="hg19"      
MANIFEST_TYPE="RNA-Seq"
RESULT_SUFFIX="bed.gz"
PIPELINE_VER="v1.0"
bash ./submit.CPTAC3/write_manifest.sh -t $MANIFEST_TYPE -y $RESULT_SUFFIX $ANALYSIS $DATD $SOURCE_ES $REF $PIPELINE_VER

## Transcript FPKM - note the -a flag, which appends info here to manifest from Transcript BED
ANALYSIS="RNA-Seq_Transcript"
SOURCE_ES="RNA-Seq" 
REF="hg19"      
MANIFEST_TYPE="RNA-Seq"
RESULT_SUFFIX="fpkm.gz"
PIPELINE_VER="v1.0"
bash ./submit.CPTAC3/write_manifest.sh -a -t $MANIFEST_TYPE -y $RESULT_SUFFIX $ANALYSIS $DATD $SOURCE_ES $REF $PIPELINE_VER

# Fusion
ANALYSIS="RNA-Seq_Fusion"
SOURCE_ES="RNA-Seq" 
REF="hg19"      
MANIFEST_TYPE="RNA-Seq"
RESULT_SUFFIX="Fusions.dat"
PIPELINE_VER="v1.0"
bash ./submit.CPTAC3/write_manifest.sh -t $MANIFEST_TYPE -y $RESULT_SUFFIX $ANALYSIS $DATD $SOURCE_ES $REF $PIPELINE_VER

