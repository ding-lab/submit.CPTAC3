# Stage WGS-SV
# WGS-Germline has large VCF-format output. Compress it (gz) during staging

ANALYSIS="WGS-SV"
DATD="/gscmnt/gc2521/dinglab/wliao/somatic/SV/Manta/filtered_VCF"
INPUT_SUFFIX="somaticSV.filtered.vcf"
OUTPUT_SUFFIX="vcf"


# -D adds disease name to path
bash ./submit.CPTAC3/stage_data.sh -D $ANALYSIS $DATD $INPUT_SUFFIX $OUTPUT_SUFFIX WGS
