
#  MSI
DAT="/gscmnt/gc2741/ding/qgao/CPTAC3/Submission/Batch_20180209/MSI/README"
ANALYSIS="WXS_MSI"
PIPELINE_VER="v1.0"
bash ./submit.CPTAC3/stage_description.sh $ANALYSIS $DAT $PIPELINE_VER

## Transcript BED + Transcript FPKM - combined description
DAT="/gscuser/mwyczalk/projects/CPTAC3/submit/submit.CPTAC3.b2.C/processing.tmp/Transcript_GeneExpression.txt"
ANALYSIS="RNA-Seq_Transcript"
PIPELINE_VER="v1.0"
bash ./submit.CPTAC3/stage_description.sh $ANALYSIS $DAT $PIPELINE_VER

# Fusion
DAT="/gscuser/mwyczalk/projects/CPTAC3/submit/submit.CPTAC3.b2.C/processing.tmp/Fusions.txt"
ANALYSIS="RNA-Seq_Fusion"
PIPELINE_VER="v1.0"
bash ./submit.CPTAC3/stage_description.sh $ANALYSIS $DAT $PIPELINE_VER



