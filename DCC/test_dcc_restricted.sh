source ../submit_config.sh
ln -fs $INIR

CPTACTRANSFER="python $CPTACDCC/cptactransfer.py"


SRC="CPTAC2_prospective_genomic_results_WashU/CPTAC2_COAD/LiDIng_Colorectal_Genomic_Analysis/CRC_v0.9_Manifest.txt"


DAT="dat.tmp.dcc_restricted"
mkdir -p $DAT

$CPTACTRANSFER get $SRC

