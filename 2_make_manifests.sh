# Create and stage manifest files for WGS-SV
# This analysis uses both Tumor and Normal WGS data to produce calls.  As a result, using -t somatic

ANALYSIS="RNA-Seq_DeNovo"
SOURCE_ES="RNA-Seq" # Experimental Strategy
REF="hg19"      # Reference
MANIFEST_TYPE="RNA-Seq"

bash ./submit.CPTAC3/write_manifest.sh -t $MANIFEST_TYPE -y "fasta.gz" $ANALYSIS $DATD $SOURCE_ES $REF

