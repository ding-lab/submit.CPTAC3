# Project definitions

source batch.dat # timestamp, other per-submission information
source system.dat # system paths

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
    PVER=$3
	if [ -z $PVER ]; then
		>&2 echo Error: Pipeline version not passed to getd
		exit 1
	fi

    D=$(getrd $CANCER)
    echo $STAGE_ROOT/$D/${CANCER}_${ANALYSIS}_${PROJECT}_${PVER}_${DATESTAMP}
}
