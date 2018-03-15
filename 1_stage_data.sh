#* Timestamp: 20180312
#  * MSI
#  * Transcript.  Includes batch 2 Gene Expression
#  * Fusion

# TODO: in future revisions, all the details below should be defined just once, rather than in steps 1, 2, 3

#  MSI
ANALYSIS="WXS_MSI"
ES="WXS"
DATD="MSI.tmp/dat"  # prestage to normalize filenames
INPUT_SUFFIX="dat"
OUTPUT_SUFFIX="MSIsensor.dat"
PIPELINE_VER="v1.0"
# -z to compress while staging
ARGS=""
bash ./submit.CPTAC3/stage_data.sh $ARGS $ANALYSIS $DATD $INPUT_SUFFIX $OUTPUT_SUFFIX $ES $PIPELINE_VER

## Transcript BED
ANALYSIS="RNA-Seq_Transcript"
ES="RNA-Seq"
DATD="/gscmnt/gc2741/ding/qgao/CPTAC3/Submission/Batch_20180209/Transcript"
INPUT_SUFFIX="bed"
OUTPUT_SUFFIX="bed"
PIPELINE_VER="v1.0"
# -z to compress while staging
ARGS="-z "

bash ./submit.CPTAC3/stage_data.sh $ARGS $ANALYSIS $DATD $INPUT_SUFFIX $OUTPUT_SUFFIX $ES $PIPELINE_VER

## Transcript FPKM
ANALYSIS="RNA-Seq_Transcript"
ES="RNA-Seq"
DATD="/gscmnt/gc2741/ding/qgao/CPTAC3/Submission/Batch_20180209/GE"
INPUT_SUFFIX="fpkm"
OUTPUT_SUFFIX="fpkm"
PIPELINE_VER="v1.0"
# -z to compress while staging
ARGS="-z "

bash ./submit.CPTAC3/stage_data.sh $ARGS $ANALYSIS $DATD $INPUT_SUFFIX $OUTPUT_SUFFIX $ES $PIPELINE_VER

# Fusion
ANALYSIS="RNA-Seq_Fusion"
ES="RNA-Seq"
DATD="/gscuser/mwyczalk/projects/CPTAC3/submit/submit.CPTAC3.b2.C/Fusions.tmp/dat"
INPUT_SUFFIX="Fusions.dat"
OUTPUT_SUFFIX="Fusions.dat"
PIPELINE_VER="v1.0"
# -z to compress while staging
ARGS=""
bash ./submit.CPTAC3/stage_data.sh $ARGS $ANALYSIS $DATD $INPUT_SUFFIX $OUTPUT_SUFFIX $ES $PIPELINE_VER
