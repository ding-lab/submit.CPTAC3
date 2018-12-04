# Processing is driven by BamMap cases.  Here, make list of all cases associated with LUAD b5/6,
# then create katmai-specific BamMap

source batch_config.sh
mkdir -p dat

awk 'BEGIN{OFS="\t";FS="\t"}{if ($2 == "LUAD" && ($3 == "b5")) print $1}' $ALLCASES > $CASES

echo Written to $CASES

# MYBAMMAP="dat.tmp/BamMap.local.dat"
#head -n1 $ALLBAMMAP > $MYBAMMAP
#grep -f $MYCASES $ALLBAMMAP | grep "hg38" >> $MYBAMMAP
#
#echo Written to $MYBAMMAP
