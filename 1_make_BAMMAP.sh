# Processing is driven by BamMap cases.  Here, make list of all cases associated with LUAD b5/6,
# then create katmai-specific BamMap

mkdir -p dat.tmp

ALLCASES="/home/mwyczalk_test/Projects/CPTAC3/CPTAC3.catalog/CPTAC3.C325.cases.dat"
ALLBAMMAP="/home/mwyczalk_test/Projects/CPTAC3/CPTAC3.catalog/katmai.BamMap.dat"

MYCASES="dat.tmp/cases.LUAD.b56.dat"
MYBAMMAP="dat.tmp/katmai.BamMap.WXS.LUAD.b56.dat"

awk 'BEGIN{OFS="\t";FS="\t"}{if ($2 == "LUAD" && ($3 == "b5" || $3 == "b6" )) print $1}' $ALLCASES > $MYCASES

echo Written to $MYCASES

# Now create BamMap of hg38 WXS data for cases of interest

head -n1 $ALLBAMMAP > $MYBAMMAP
grep -f $MYCASES $ALLBAMMAP | grep "WXS" | grep "hg38" >> $MYBAMMAP

echo Written to $MYBAMMAP
