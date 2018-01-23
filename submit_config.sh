# Project definitions

DATD="dat"
mkdir -p $DATD

# SR and BAM MAP are used to get all cases and the associated disease
IMPORT_CONFIG="/gscuser/mwyczalk/projects/CPTAC3/data/GDC_import/import.config/CPTAC3.b1"

# SR file (from "Submitted Reads") is created by case discovery, and provides information necessary
# for download of BAM and FASTQ files from GDC
SR="$IMPORT_CONFIG/SR.CPTAC3.b1.dat"

PROJECT="CPTAC3.b1"
BATCH="batch1"
VER="v1.0"
DATESTAMP="20180122"  # YYYYMMDD
SUBMIT="C"  # This is not currently used, but implies WGS-Somatic and WGS-Germline

# We loop through all these diseases
DISEASES="CCRC UCEC"

# where verbatim copy of uploaded data is stored
STAGE_ROOT="/gscmnt/gc2521/dinglab/mwyczalk/CPTAC3-submit/staged_data.${PROJECT}.${SUBMIT}"

# Uploading is with cptactransfer.py.  Define installation path
CPTACTRANSFER="/gscuser/mwyczalk/projects/CPTAC3/DCC/cptacdcc-1.6.20/cptacdcc/cptactransfer.py"
# cptactransfer.py requires that cptactransfer.ini be in the current path
INI="/gscuser/mwyczalk/projects/CPTAC3/submit.CPTAC3.b1.B/DCC/cptactransfer.ini"

# Get the path to the BamMap file for a given experimental strategy
function getBM {
    SES=$1  # Source Experimental Strategy.  Typically WGS, WXS, or RNA-Seq
    # BamMap file is generated during download of BAM/FASTQ, provides paths to the sequence data
    echo "$IMPORT_CONFIG/$PROJECT.$SES.BamMap.dat"
}


###
# get canonical staging directory names.  This is what the paths on DCC will look like
# e.g. CPTAC3_UCEC/UCEC_CNV_WXS_batch1_v1.0_12062017
# CCRC has directory name CCRCC
function getrd { # get the remote directory name.
    CANCER=$1

    if [ $CANCER == "CCRC" ]; then
        echo "CPTAC3_CCRCC"
    else
        echo "CPTAC3_$CANCER"
    fi
}

function getd {
    CANCER=$1
    ANALYSIS=$2
    D=$(getrd $CANCER)
    echo $STAGE_ROOT/$D/${CANCER}_${ANALYSIS}_${BATCH}_${VER}_${DATESTAMP}
}
