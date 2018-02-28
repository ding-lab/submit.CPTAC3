
## WGS SV
# Results: `/diskmnt/Projects/Users/wliao/CPTAC3/somatic/SV/batch2`
# Please read README.md for the workflow description: `/diskmnt/Projects/Users/wliao/CPTAC3/somatic/SV/batch2/README.md`
# Data filename example: `C3L-00004.SV.WGS.vcf`

ANALYSIS="WGS_SV"
DATD="/diskmnt/Projects/Users/wliao/CPTAC3/somatic/SV/batch2"
INPUT_SUFFIX="SV.WGS.vcf"
OUTPUT_SUFFIX="vcf"

bash ./submit.CPTAC3/stage_data.sh $ANALYSIS $DATD $INPUT_SUFFIX $OUTPUT_SUFFIX WGS

## WXS CNV
ANALYSIS="WXS_CNV"
DATD="/diskmnt/Projects/CPTAC3CNV/gatk4wxscnv/deliverables"
INPUT_SUFFIX="gatk4wxscnv.cnv"
OUTPUT_SUFFIX="cnv"

#Results: `/diskmnt/Projects/CPTAC3CNV/gatk4wxscnv/deliverables`
#Processing: /diskmnt/Projects/CPTAC3CNV/gatk4wxscnv/deliverables/README.md
#Filename exmple: `C3L-00769.gatk4wxscnv.cnv`

bash ./submit.CPTAC3/stage_data.sh $ANALYSIS $DATD $INPUT_SUFFIX $OUTPUT_SUFFIX WGS
