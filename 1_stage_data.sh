# Stage WGS-SV
# WGS-Germline has large VCF-format output. Compress it (gz) during staging

ANALYSIS="RNA-Seq_DeNovo"
DATD="/Projects/cptac/denovo/Submission"
INPUT_SUFFIX="fasta.gz"
OUTPUT_SUFFIX="fasta.gz"


# -D adds disease name to path
bash ./submit.CPTAC3/stage_data.sh -D $ANALYSIS $DATD $INPUT_SUFFIX $OUTPUT_SUFFIX WGS
