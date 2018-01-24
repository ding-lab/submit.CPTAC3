
#https://cptc-xfer.uis.georgetown.edu/aspera/home.html

source submit_config.sh

# Upload all staged data.  Formulation below places all staged directories relative to / remotely
bash ascp_transfer.sh "$STAGE_ROOT/*" /
