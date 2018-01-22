# Project definitions

DATD="dat"
mkdir -p $DATD

# SR and BAM MAP are used to get all cases and the associated disease
IMPORT_CONFIG="/gscuser/mwyczalk/projects/CPTAC3/data/GDC_import/import.config/CPTAC3.b1"

# SR file (from "Submitted Reads") is created by case discovery, and provides information necessary
# for download of BAM and FASTQ files from GDC
SR="$IMPORT_CONFIG/SR.CPTAC3.b1.dat"

# BamMap file is generated during download of BAM/FASTQ, provides paths to the sequence data
BM="$IMPORT_CONFIG/CPTAC3.b1.WXS.BamMap.dat"

PROJECT="CPTAC3.b1"
BATCH="batch1"
VER="v1.0"
DATE="20180122"  # YYYYMMDD
SUBMIT="C"  # This is not currently used, but implies WGS-Somatic and WGS-Germline

DISEASES="CCRC UCEC"

# where verbatim copy of uploaded data is stored
STAGE_ROOT="/gscmnt/gc2521/dinglab/mwyczalk/CPTAC3-submit/staged_data.${PROJECT}.${SUBMIT}"

###
# get canonical staging directory names.  This is what the paths on DCC will look like
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
