# Go through all cases and make links to WXS-Germline data

# SR and BAM MAP are used to get all cases and the associated disease

OUTD="data.links/WXS-Germline"
mkdir -p $OUTD


SR="/gscuser/mwyczalk/projects/CPTAC3/import.preliminary/SR/SR_merged.dat"
BM="/gscuser/mwyczalk/projects/CPTAC3/import.CPTAC3b1/BamMap/CPTAC3.b1.WXS.BamMap.dat"

# Where Song deposited result data, filename e.g., C3L-00010.maf
DATD="/gscmnt/gc2521/dinglab/scao/cptac3/wxs/germline_per_sample"

function process_case {
CASE=$1

CANCER=$(cut -f 1,2 $SR | grep $CASE | cut -f 2 | sort -u)
FN="$DATD/${CASE}.maf"

if [ ! -e $FN ]; then
echo $FN does not exist.
return
fi

#STAGEDFN="staged/$CANCER/${CASE}.maf"

DESTD="$OUTD/$CANCER"
mkdir -p $DESTD

ln -s $FN $DESTD

#printf "$CASE\t$CANCER\tWXS-Germline\t$FN\t$STAGEDFN\n" >> $OUT

}



while read CASE; do

[[ $CASE = \#* ]] && continue  # Skip commented out entries
>&2 echo Processing $CASE

process_case $CASE


done < <(grep -v "^#" $BM | cut -f 2 | sort -u)  # pull out all case IDs out of BamMap and loop through them

>&2 echo Written to $OUTD
