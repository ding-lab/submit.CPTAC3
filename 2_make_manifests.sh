# Create and stage manifest files for WGS-SV
# This analysis uses both Tumor and Normal WGS data to produce calls.  As a result, using -t somatic

ANALYSIS="WGS-SV"
SOURCE_ES="WGS" # Experimental Strategy
REF="hg19"      # Reference



bash ./submit.CPTAC3/write_manifest.sh -t somatic -y "vcf" $ANALYSIS $DATD $SOURCE_ES $REF

