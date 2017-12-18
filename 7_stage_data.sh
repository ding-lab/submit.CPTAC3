BATCH="batch1"
VER="v1.0"
DATE="12182017"

#DATD="/Users/mwyczalk/Data/CPTAC3/submit"
PD="./processing_description"
MD="./manifest"

OD="./data.links"

STAGE_ROOT="/gscmnt/gc2521/dinglab/mwyczalk/CPTAC3-submit/staged_data.CPTAC3.b1.B"
mkdir -p $STAGE_ROOT
echo Data written to $STAGE_ROOT

# Analyses A:
#   CNV_WXS
#   MSI_WXS
#   Somatic_WXS
#   Transcript_RNA-Seq

# Analysis B
# WXS-Germline
# Fusion

# get canonical output directory names
# e.g. CPTAC3_UCEC/UCEC_CNV_WXS_batch1_v1.0_12062017
# CCRC has directory name CCRCC
function getd {
    CANCER=$1
    PROC=$2

    if [ $CANCER == "CCRC" ]; then
        D="CPTAC3_CCRCC"
    else
        D="CPTAC3_$CANCER"
    fi

    echo $STAGE_ROOT/$D/${CANCER}_${PROC}_${BATCH}_${VER}_${DATE}
}

function make_dirs {
    echo Making directories
    MKDIR="mkdir -p"

#    $MKDIR $(getd CCRC CNV_WXS)
#    $MKDIR $(getd UCEC CNV_WXS)
#
#    $MKDIR $(getd CCRC MSI_WXS)
#    $MKDIR $(getd UCEC MSI_WXS)
#
#    $MKDIR $(getd CCRC Somatic_WXS)
#    $MKDIR $(getd UCEC Somatic_WXS)
#
#    $MKDIR $(getd CCRC Transcript_RNA-Seq)
#    $MKDIR $(getd UCEC Transcript_RNA-Seq)

# Batch b1.B
    $MKDIR $(getd CCRC WXS-Germline)
    $MKDIR $(getd UCEC WXS-Germline)

    $MKDIR $(getd CCRC Fusion)
    $MKDIR $(getd UCEC Fusion)
}


function copy_processing {
# Copy the processing data
#   CNV.description.txt
#   MSI.description.txt
#   Somatic.description.txt
#   Transcript.description.txt
    echo Copying processing
    CP="cp"

#    $CP $PD/CNV.description.txt $(getd CCRC CNV_WXS)
#    $CP $PD/CNV.description.txt $(getd UCEC CNV_WXS)
#
#    $CP $PD/MSI.description.txt $(getd CCRC MSI_WXS)
#    $CP $PD/MSI.description.txt $(getd UCEC MSI_WXS)
#
#    $CP $PD/Somatic.description.txt $(getd CCRC Somatic_WXS)
#    $CP $PD/Somatic.description.txt $(getd UCEC Somatic_WXS)
#
#    $CP $PD/Transcript.description.txt $(getd CCRC Transcript_RNA-Seq)
#    $CP $PD/Transcript.description.txt $(getd UCEC Transcript_RNA-Seq)

    $CP $PD/WXS-Germline.description.txt $(getd CCRC WXS-Germline)
    $CP $PD/WXS-Germline.description.txt $(getd UCEC WXS-Germline)

    $CP $PD/Fusion.description.txt $(getd CCRC Fusion)
    $CP $PD/Fusion.description.txt $(getd UCEC Fusion)

}

function copy_manifest {
    echo Copying manifest
    CP="cp"
#    $CP $MD/CNV.WXS.CPTAC3.b1.CCRC.manifest.dat $(getd CCRC CNV_WXS)
#    $CP $MD/CNV.WXS.CPTAC3.b1.UCEC.manifest.dat $(getd UCEC CNV_WXS)
#
#    $CP $MD/MSI.CPTAC3.b1.CCRC.manifest.dat $(getd CCRC MSI_WXS)
#    $CP $MD/MSI.CPTAC3.b1.UCEC.manifest.dat $(getd UCEC MSI_WXS)
#
#    $CP $MD/Somatic.WXS.CPTAC3.b1.CCRC.manifest.dat $(getd CCRC Somatic_WXS)
#    $CP $MD/Somatic.WXS.CPTAC3.b1.UCEC.manifest.dat $(getd UCEC Somatic_WXS)
#
#    $CP $MD/Transcript.CPTAC3.b1.CCRC.manifest.dat $(getd CCRC Transcript_RNA-Seq)
#    $CP $MD/Transcript.CPTAC3.b1.UCEC.manifest.dat $(getd UCEC Transcript_RNA-Seq)

    $CP $MD/WXS-Germline.CPTAC3.b1.CCRC.manifest.dat $(getd CCRC WXS-Germline)
    $CP $MD/WXS-Germline.CPTAC3.b1.UCEC.manifest.dat $(getd UCEC WXS-Germline)

    $CP $MD/Fusion.CPTAC3.b1.CCRC.manifest.dat $(getd CCRC Fusion)
    $CP $MD/Fusion.CPTAC3.b1.UCEC.manifest.dat $(getd UCEC Fusion)
}

# TODO: make use of summary details to get paths
function copy_data {
    echo Copying data
    CP="cp -v"
#    $CP $OD/CNV.WXS/CPTAC3.b1.CCRC/* $(getd CCRC CNV_WXS)
#    $CP $OD/CNV.WXS/CPTAC3.b1.UCEC/* $(getd UCEC CNV_WXS)
#
#    $CP $OD/MSI/CCRC/* $(getd CCRC MSI_WXS)
#    $CP $OD/MSI/UCEC/* $(getd UCEC MSI_WXS)
#
#    $CP $OD/Somatic.WXS/CCRC/* $(getd CCRC Somatic_WXS)
#    $CP $OD/Somatic.WXS/UCEC/* $(getd UCEC Somatic_WXS)
#
    $CP $OD/WXS-Germline/CCRC/* $(getd CCRC WXS-Germline)
    $CP $OD/WXS-Germline/UCEC/* $(getd UCEC WXS-Germline)

    $CP $OD/Fusion/CCRC/* $(getd CCRC Fusion)
    $CP $OD/Fusion/UCEC/* $(getd UCEC Fusion)
}

make_dirs
copy_processing
copy_manifest
copy_data
