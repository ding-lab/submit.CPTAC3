# Upload (submit) data to DCC
# Usage:
# ascp_transfer.sh local_src dcc_dest
#
# local_src: path to base of local directory to be copied
# dcc_dest: path to base directory where submitted data will be written on DCC.  
# Note that the token must be obtained for dcc_dest; it is typically /

source submit_config.sh

# from ascp_config.ini get values for ASCP_USER and ASCP_TOKEN
source $ASCP_INI

ASCP="$ASCP_CONNECT/bin/ascp"

# Require 1 argument
if [ "$#" -ne 2 ]; then
    >&2 echo Error: Require 2 argument: local_src and dcc_dest
    exit 1  # exit code 1 indicates error
fi

SRC=$1
DEST=$2

# These parameters as suggested by Ratna Thangudu 1/24/18
$ASCP  \
 -i $ASCP_CONNECT/etc/asperaweb_id_dsa.openssh \
 -P 33001 \
 -O 33001 \
 -l 300M \
 -k 2 \
 -T \
 -Q \
 --user $ASCP_USER \
 -W $ASCP_TOKEN \
 --host cptc-xfer.uis.georgetown.edu \
 --mode send \
$SRC $DEST

