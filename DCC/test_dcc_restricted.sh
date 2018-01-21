SRC="CPTAC2_prospective_genomic_results_WashU/CPTAC2_COAD/LiDIng_Colorectal_Genomic_Analysis/CRC_v0.9_Manifest.txt"

CPTACTRANSFER="python /Users/mwyczalk/src/cptacdcc/cptactransfer.py"

DAT="dat.tmp.dcc_restricted"
mkdir -p $DAT

$CPTACTRANSFER get $SRC

