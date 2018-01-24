
#https://cptc-xfer.uis.georgetown.edu/aspera/home.html

source submit_config.sh

# Upload all staged data
bash ascp_transfer.sh $STAGE_ROOT /
