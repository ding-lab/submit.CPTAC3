CPTACTRANSFER="python /gscuser/mwyczalk/projects/CPTAC3/DCC/cptacdcc-1.6.20/cptacdcc/cptactransfer.py"

# cptactransfer.py requires that cptactransfer.ini be in the current path
INI="/gscuser/mwyczalk/projects/CPTAC3/submit.CPTAC3.b1.B/DCC/cptactransfer.ini"
ln -fs $INI

STAGE_ROOT="/gscmnt/gc2521/dinglab/mwyczalk/CPTAC3-submit/staged_data.CPTAC3.b1.B"
#https://cptc-xfer.uis.georgetown.edu/aspera/home.html

BATCH="batch1_v1.0_12182017"

function transfer {
DATA=$1
REMOTE_DIR=$2

$CPTACTRANSFER put $DATA $REMOTE_DIR

}

#CCRC_CNV_WXS_batch1_v1.0_12062017
#CCRC_MSI_WXS_batch1_v1.0_12062017
#CCRC_Somatic_WXS_batch1_v1.0_12062017
#CCRC_Transcript_RNA-Seq_batch1_v1.0_12062017

RD="/CPTAC3_CCRCC"
#transfer CPTAC3_CCRCC/CCRC_CNV_WXS_batch1_v1.0_12062017 $RD
#transfer CPTAC3_CCRCC/CCRC_MSI_WXS_batch1_v1.0_12062017 $RD
#transfer CPTAC3_CCRCC/CCRC_Somatic_WXS_batch1_v1.0_12062017 $RD
#transfer CPTAC3_CCRCC/CCRC_Transcript_RNA-Seq_batch1_v1.0_12062017 $RD

transfer $STAGE_ROOT/CPTAC3_CCRCC/CCRC_Fusion_$BATCH $RD
transfer $STAGE_ROOT/CPTAC3_CCRCC/CCRC_WXS-Germline_$BATCH $RD


RD="/CPTAC3_UCEC"
# transfer CPTAC3_UCEC/UCEC_CNV_WXS_batch1_v1.0_12062017 $RD
# transfer CPTAC3_UCEC/UCEC_MSI_WXS_batch1_v1.0_12062017 $RD
# transfer CPTAC3_UCEC/UCEC_Somatic_WXS_batch1_v1.0_12062017 $RD
# transfer CPTAC3_UCEC/UCEC_Transcript_RNA-Seq_batch1_v1.0_12062017 $RD

transfer $STAGE_ROOT/CPTAC3_UCEC/UCEC_Fusion_$BATCH $RD
transfer $STAGE_ROOT/CPTAC3_UCEC/UCEC_WXS-Germline_$BATCH $RD
