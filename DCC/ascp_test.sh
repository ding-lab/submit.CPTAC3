# Based on email from Ratna Thangudu 1/24/18

#ASCP="/gscuser/mwyczalk/.aspera/connect/bin/ascp"
source ../system.dat
ASCP="$ASCP_CONNECT/bin/ascp"
#ASCP_CONNECT="/home/mwyczalk_test/.aspera/connect"

# from ascp_config.ini get values for ASCP_USER and ASCP_TOKEN
source ascp_config.ini
TEMPLATE="upload_template.txt"
UPLOAD_DAT="uploader_test.tmp"

# add username and date to template to create UPLOAD_DAT

DT=$(date '+%d/%m/%Y %H:%M:%S');
TAG="Uploaded by user $ASCP_USER on $DT"

cp $TEMPLATE $UPLOAD_DAT
echo $TAG >> $UPLOAD_DAT
echo Created $UPLOAD_DAT
echo Uploading to DCC site at cptc-xfer.uis.georgetown.edu.
echo Please remove this file from this site when test complete

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
$UPLOAD_DAT $DEST

