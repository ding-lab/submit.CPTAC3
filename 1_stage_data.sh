# Stage WGS-Germline and WGS-Somatic
# WGS-Germline has large VCF-format output. Compress it (gz) during staging

ANALYSIS="WGS-Germline"
DATD="/gscmnt/gc2521/dinglab/scao/cptac3/wgs/germline_per_sample"
FT="vcf"
# -z flag to compress large VCFs
bash ./stage_data.sh -z $ANALYSIS $DATD $FT WGS

# Somatic seems is MAF
ANALYSIS="WGS-Somatic"
DATD="/gscuser/scao/gc2521/dinglab/scao/cptac3/wgs/somatic_per_sample"
FT="maf"
bash ./stage_data.sh $ANALYSIS $DATD $FT WGS
