# Copy processing description to staging directory
# Does this for all disease types 

source batch_config.sh

# http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts ":1d" opt; do
  case $opt in
    1)  
      STOPATONE=1 # this is meaningless, but keeping for consistency
      ;;
    d)  
      DRY_RUN=1
      ;;
    \?)
      >&2 echo "Invalid option: -$OPTARG" 
      exit 1
      ;;
    :)
      >&2 echo "Option -$OPTARG requires an argument." 
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

ANALYSIS=$1
PROCESSING_TXT=$2
PIPELINE_VER=$3

function stage_processing_description {
COI=$1

FN="processing_description.$ANALYSIS.$PROJECT.txt" 
DESTD=$(getd $COI $ANALYSIS $PIPELINE_VER)
DESTFN="$DESTD/$FN"

# Confirm file exists and is not empty

if [ ! -e $PROCESSING_TEXT ]; then
    >&2 echo ERROR: Processing description $PROCESSING_TEXT does not exist
    exit 1
fi

if [ ! -s $PROCESSING_TEXT ]; then
    >&2 echo ERROR: Processing description $PROCESSING_TEXT zero size
    exit 1
fi


>&2 echo Copying $PROCESSING_TXT to $DESTFN
if [ -z $DRY_RUN ]; then
    cp $PROCESSING_TXT $DESTFN
else
    >&2 echo cp $PROCESSING_TXT $DESTFN
fi

}

if [ ! -e $PROCESSING_TXT ]; then
    >&2 echo $PROCESSING_TXT does not exist.  Quitting.
    exit 1
fi

for COI in $DISEASES; do
    stage_processing_description $COI
done

