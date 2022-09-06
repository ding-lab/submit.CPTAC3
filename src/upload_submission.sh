
#https://cptc-xfer.uis.georgetown.edu/aspera/home.html

source batch.dat # timestamp, other per-submission information
source system.dat $LOCALE # system paths

# Upload all staged data.  Formulation below places all staged directories relative to / remotely
CMD="bash src/ascp_transfer.sh $@ \"$STAGE_ROOT/*\" / "
echo $CMD
eval $CMD

