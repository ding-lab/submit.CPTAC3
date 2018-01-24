# Based on email from Ratna Thangudu 1/24/18

ASCP="/gscuser/mwyczalk/.aspera/connect/bin/ascp"

# from ascp_config.ini get values for ASCP_USER and ASCP_TOKEN
source ascp_config.ini

SRC="DCC-debug/test_dataset"
DEST="/"

echo $ASCP  \
 -i ~/.aspera/connect/etc/asperaweb_id_dsa.openssh \
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

