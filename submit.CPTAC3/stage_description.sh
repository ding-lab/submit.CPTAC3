# Copy processing description to staging directory
# Does this for all disease types 

source batch_config.sh
ANALYSIS=$1
PROCESSING_TXT=$2

function stage_processing_description {
COI=$1

FN="processing_description.$ANALYSIS.$PROJECT.txt" 
DESTD=$(getd $COI $ANALYSIS)
DESTFN="$DESTD/$FN"

>&2 echo Copying $PROCESSING_TXT to $DESTFN
cp $PROCESSING_TXT $DESTFN

}

if [ ! -e $PROCESSING_TXT ]; then
    >&2 echo $PROCESSING_TXT does not exist.  Quitting.
    exit 1
fi

for COI in $DISEASES; do
    stage_processing_description $COI
done

