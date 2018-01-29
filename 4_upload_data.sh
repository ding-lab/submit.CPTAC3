
#https://cptc-xfer.uis.georgetown.edu/aspera/home.html

source path_config.sh

# Upload all staged data.  Formulation below places all staged directories relative to / remotely
echo bash submit.CPTAC3/ascp_transfer.sh "$STAGE_ROOT/*" /
