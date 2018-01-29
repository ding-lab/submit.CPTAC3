# Stage WGS-CNV
# WGS-Germline has large VCF-format output. Compress it (gz) during staging

ANALYSIS="WGS-CNV"
DATD="/diskmnt/Projects/CPTAC3CNV/genomestrip/deliverables/batch1"
FT="vcf"
# -z flag to compress large VCFs
bash ./submit.CPTAC3/stage_data.sh -T -z $ANALYSIS $DATD $FT WGS
