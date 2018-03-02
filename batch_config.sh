# Project definitions

DATESTAMP="20180302"  # YYYYMMDD
SUBMIT="B"  
PROJECT="CPTAC3.b2"
BATCH="batch2"
VER="v1.0"

# We loop through all these diseases
DISEASES="CCRC UCEC"

# path_config has system-specific path info
source path_config.sh

# not sure this should stay here...
ASCP_INI="DCC/ascp_config.ini"
if [ ! -e $ASCP_INI ]; then
    >&2 echo ASCP configuration file does not exist: $ASCP_INI
    exit 1
fi

# Deprecated.  Simply returns $BAMMAP
function getBM {
    echo $BAMMAP
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
