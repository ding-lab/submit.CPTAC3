
#https://cptc-xfer.uis.georgetown.edu/aspera/home.html

source batch.dat # timestamp, other per-submission information
source system.dat $LOCALE # system paths

ASCP_INI="DCC/ascp_config.ini"
if [ ! -e $ASCP_INI ]; then
    >&2 echo ASCP configuration file does not exist: $ASCP_INI
    exit 1
fi



# Upload all staged data.  Formulation below places all staged directories relative to / remotely
bash submit.CPTAC3/ascp_transfer.sh "$STAGE_ROOT/*" /
