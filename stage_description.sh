# Copy processing description to staging directory
# Does this for all disease types 

source submit_config.sh
ANALYSIS=$1
PROCESSING_TXT=$2

function stage_processing_description {
COI=$1

FN="$ANALYSIS.description.txt" 
DESTD=$(getd $COI $ANALYSIS)

>&2 echo Copying $PROCESSING_TXT to $FN/$DESTD
cp $PROCESSING_TXT $FN/$DESTD

}

if [ ! -e $PROCESSING_TXT ]; then
    >&2 echo $PROCESSING_TXT does not exist.  Quitting.
    exit 1
fi

for COI in $DISEASES; do
    stage_processing_description $COI
done

