# Based on email from Ratna Thangudu 1/24/18

#ASCP="/gscuser/mwyczalk/.aspera/connect/bin/ascp"
source ../path_config.sh
ASCP="$ASCP_CONNECT/bin/ascp"
#ASCP_CONNECT="/home/mwyczalk_test/.aspera/connect"

# from ascp_config.ini get values for ASCP_USER and ASCP_TOKEN
source ascp_config.ini

#SRC="/WashU_Data_Transfer/WashU_test.tmp"
SRC="/Methylation_CPTAC3"
DEST="/gscmnt/gc2741/ding/CPTAC3-data/DCC_import"

$ASCP  \
 -i ~/.aspera/connect/etc/asperaweb_id_dsa.openssh \
 -P 33001 \
 -O 33001 \
 -l 300M \
 -k 2 \
 -T \
 -Q \
 --user $ASCP_USER \
 -W $ASCP_TOKEN_RECEIVE \
 --host cptc-xfer.uis.georgetown.edu \
 --mode recv \
$SRC $DEST

