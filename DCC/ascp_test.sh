# Based on email from Ratna Thangudu 1/24/18

#ASCP="/gscuser/mwyczalk/.aspera/connect/bin/ascp"
source ../system.dat
ASCP="$ASCP_CONNECT/bin/ascp"
#ASCP_CONNECT="/home/mwyczalk_test/.aspera/connect"

# from ascp_config.ini get values for ASCP_USER and ASCP_TOKEN
source ascp_config.ini

SRC="test_dataset.tmp"
DEST="/"

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

