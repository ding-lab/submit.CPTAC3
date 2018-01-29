# Create and stage manifest files for WGS-Germline and WGS-Somatic
# Note that there is one manifest file per disease

ANALYSIS="WGS-CNV"
SOURCE_ES="WGS" # Experimental Strategy
REF="hg19"      # Reference

bash ./submit.CPTAC3/write_manifest.sh -t cnv -y "vcf.gz" $ANALYSIS $DATD $SOURCE_ES $REF

# Usage: 
#  write_manifest.sh [options] analysis source-es reference
#
# analysis: canonical analysis name, e.g., WGS-Germline
# source-es: experimental strategy of input data: WGS or WXS typically
# reference: the reference used in this analysis.  e.g., 'hg19'

# Options:
# -1: Stop after one case
# -t manifest_type: currently only 'germline' and 'somatic' (default)
#       germline - only normal sample indicated
#       somatic - both germline and tumor sample 
# -y filetype: the type of data, e.g., 'maf' or 'vcf', as output in manifest. Default is 'vcf'
# -s file_suffix: Used to construct data filename, as ANALYSIS.CASE.SUFFIX
#       If not defined, set to value of filetype
