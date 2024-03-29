# Based on email from Ratna Thangudu 1/24/18

#ASCP="/gscuser/mwyczalk/.aspera/connect/bin/ascp"
cd ..
source batch.dat
source system.dat $LOCALE
ASCP="$ASCP_CONNECT/bin/ascp"
#ASCP_CONNECT="/home/mwyczalk_test/.aspera/connect"


# from ascp_config.ini get values for ASCP_USER and ASCP_TOKEN
source DCC/ascp_config.ini
TEMPLATE="DCC/upload_template.txt"
UPLOAD_DAT="uploader_test.tmp"

# add username and date to template to create UPLOAD_DAT

DT=$(date '+%d/%m/%Y %H:%M:%S');
TAG="Uploaded by user $ASCP_USER on $DT"

cp $TEMPLATE $UPLOAD_DAT
echo $TAG >> $UPLOAD_DAT
echo Created $UPLOAD_DAT
echo Uploading to DCC site at https://cptac-data-portal.georgetown.edu/cptac/
echo Please remove this file from this site when test complete

DEST="/"

CMD="$ASCP  \
 -P 33001 \
 -O 33001 \
 -l 300M \
 -k 2 \
 -T \
 -Q \
 --user $ASCP_USER \
 --host cptc-xfer.uis.georgetown.edu \
 --mode send \
$UPLOAD_DAT $DEST"

echo Running: $CMD
echo Enter password for \"aspera connect ascp\" when prompted
eval $CMD

# -i $ASCP_CONNECT/etc/asperaweb_id_dsa.openssh \
# -W $ASCP_TOKEN \

