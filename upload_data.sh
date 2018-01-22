ANALYSIS=$1

source submit_config.sh
ln -fs $INI

#https://cptc-xfer.uis.georgetown.edu/aspera/home.html

function transfer {
DATA=$1
REMOTE_DIR=$2

python $CPTACTRANSFER put $DATA $REMOTE_DIR

}

function transfer_data {
    CANCER=$1
    ANALYSIS=$2

    RD=$(getrd $CANCER)  # e.g., /CPTAC3_UCEC
    SOURCED=$(getd $CANCER $ANALYSIS)

    transfer $SOURCED "/$RD"
}

for DIS in $DISEASES; do
    transfer_data $DIS $ANALYSIS
done
