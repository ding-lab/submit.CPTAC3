# stage VCF data as created by somatic or germline wrapper

source submit_config.sh

ANALYSIS=$1  # e.g. WGS-Somatic
DATD=$2

mkdir -p $STAGE_ROOT
echo Data written to $STAGE_ROOT

# Make destination directory
function make_staging_dir {
CANCER=$1
mkdir -p $(getd $CANCER $ANALYSIS)
}

function process_case {
# Compress VCF, copy to staging directory, rename by adding analysis name in front
CASE=$1

CANCER=$(cut -f 1,2 $SR | grep $CASE | cut -f 2 | sort -u)

# this is the source filename. 
FN="$DATD/${CASE}.vcf"

if [ ! -e $FN ]; then
>&2 echo $FN does not exist.  Continuing
return
fi

# Staging directory
DESTD=$(getd $CANCER $ANALYSIS)
DESTFN="$DESTD/${ANALYSIS}.${CASE}.vcf.gz"

if [ -e $DESTFN ] && [ -s $DESTFN ];  then  # file exists and is not zero size
>&2 echo Destination file $DESTFN exists.  Not reprocessing.
return
fi

>&2 echo Compressing $FN to $DESTFN
#>&2 echo skipping gzip

gzip -v - <$FN > $DESTFN
}

# Make staging directories
for D in $DISEASES; do
    make_staging_dir $D
done


while read CASE; do

    [[ $CASE = \#* ]] && continue  # Skip commented out entries
    >&2 echo Processing $CASE

    process_case $CASE

done < <(grep -v "^#" $BM | cut -f 2 | sort -u)  # pull out all case IDs out of BamMap and loop through them
