# Go through all cases and make links to Fusion data

# SR and BAM MAP are used to get all cases and the associated disease


OUTD="data.links/Fusion"
mkdir -p $OUTD

SR="/gscuser/mwyczalk/projects/CPTAC3/import.preliminary/SR/SR_merged.dat"
BM="/gscuser/mwyczalk/projects/CPTAC3/import.CPTAC3b1/BamMap/CPTAC3.b1.WXS.BamMap.dat"

# Where Qingsong deposited result data, filename e.g., Fusions_in_CCRC__C3L-00010.txt
DATD="/gscmnt/gc2521/dinglab/qgao/Submission/Fusion"

function process_case {
CASE=$1

CANCER=$(cut -f 1,2 $SR | grep $CASE | cut -f 2 | sort -u)
FN="$DATD/Fusions_in_${CANCER}__${CASE}.txt"

if [ ! -e $FN ]; then
echo $FN does not exist.
return
fi

DESTD="$OUTD/$CANCER"
mkdir -p $DESTD

ln -s $FN $DESTD

}



while read CASE; do

[[ $CASE = \#* ]] && continue  # Skip commented out entries
>&2 echo Processing $CASE

process_case $CASE


done < <(grep -v "^#" $BM | cut -f 2 | sort -u)  # pull out all case IDs out of BamMap and loop through them

>&2 echo Written to $OUTD
