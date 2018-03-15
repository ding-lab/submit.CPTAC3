
#https://cptc-xfer.uis.georgetown.edu/aspera/home.html

source batch_config.sh

# Upload all staged data.  Formulation below places all staged directories relative to / remotely
bash submit.CPTAC3/ascp_transfer.sh "$STAGE_ROOT/*" /
