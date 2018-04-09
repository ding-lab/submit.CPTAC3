# TODO: combine steps 1, 2, 3 into one

ANALYSES="analyses.dat"
# Columns in data file
    # ANALYSIS
    # PIPELINE_VER
    # DATD
    # PROCESSING_TXT
    # REF
    # PIPELINE

source batch_config.sh

# use to pass -d -1 and other debugging flags
SCRIPT_ARGS="$@"

while read i; do

    ANALYSIS=$( echo "$i" | cut -f 1 )
    PIPELINE_VER=$( echo "$i" | cut -f 2 )
    DATD=$( echo "$i" | cut -f 3  )
    PROCESSING_TXT=$( echo "$i" | cut -f 4  )
    REF=$( echo "$i" | cut -f 5  )
    PIPELINE_DAT=$( echo "$i" | cut -f 6  )

    if [ ! -e $PIPELINE_DAT ]; then
        >&2 echo Error: $PIPELINE_DAT does not exist
        exit 1
    fi
    source $PIPELINE_DAT

    MANIFEST_ARGS="$SCRIPT_ARGS"

	bash ./submit.CPTAC3/write_manifest.sh $MANIFEST_ARGS -t $MANIFEST_TYPE -y $RESULT_SUFFIX $ANALYSIS $SOURCE_ES $REF $PIPELINE_VER

done < <(sed 's/#.*$//' $ANALYSES | sed '/^\s*$/d' )  # skip comments and blank lines



##  Germline
#ANALYSIS="WGS_Germline"
#SOURCE_ES="WGS" # Experimental Strategy
#REF="hg19"      # Reference
#MANIFEST_TYPE="germline"
#RESULT_SUFFIX="vcf.gz"
#PIPELINE_VER="v1.1"
#bash ./submit.CPTAC3/write_manifest.sh -t $MANIFEST_TYPE -y $RESULT_SUFFIX $ANALYSIS $DATD $SOURCE_ES $REF $PIPELINE_VER
#
### Somatic
#ANALYSIS="WGS_Somatic"
#SOURCE_ES="WGS" 
#REF="hg19"      
#MANIFEST_TYPE="somatic"
#RESULT_SUFFIX="maf"
#PIPELINE_VER="v1.1"
#bash ./submit.CPTAC3/write_manifest.sh -t $MANIFEST_TYPE -y $RESULT_SUFFIX $ANALYSIS $DATD $SOURCE_ES $REF $PIPELINE_VER
