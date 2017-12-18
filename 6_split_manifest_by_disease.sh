# split each Manifest file into per-disease manifests

# TODO: This should be done when making the manifests

function split_manifest {
CANCER=$1
INFN=$2
OUTFN=$3

# first, copy header to OUTFN
head -n 1 $INFN > $OUTFN

# Test first column of manifest and output if matches disease
awk -v cancer=$CANCER 'BEGIN{FS="\t";OFS="\t"}{if ($1 == cancer) print}' $INFN >> $OUTFN
echo Written to $OUTFN
}

#split_manifest UCEC dat/CNV.WXS.CPTAC3.b1.manifest.dat dat/CNV.WXS.CPTAC3.b1.UCEC.manifest.dat
#split_manifest CCRC dat/CNV.WXS.CPTAC3.b1.manifest.dat dat/CNV.WXS.CPTAC3.b1.CCRC.manifest.dat
#
##MSI.CPTAC3.b1.manifest.dat
#split_manifest UCEC dat/MSI.CPTAC3.b1.manifest.dat dat/MSI.CPTAC3.b1.UCEC.manifest.dat
#split_manifest CCRC dat/MSI.CPTAC3.b1.manifest.dat dat/MSI.CPTAC3.b1.CCRC.manifest.dat
#
##Somatic.WXS.CPTAC3.b1.manifest.dat
#split_manifest UCEC dat/Somatic.WXS.CPTAC3.b1.manifest.dat dat/Somatic.WXS.CPTAC3.b1.UCEC.manifest.dat
#split_manifest CCRC dat/Somatic.WXS.CPTAC3.b1.manifest.dat dat/Somatic.WXS.CPTAC3.b1.CCRC.manifest.dat
#
##Transcript.CPTAC3.b1.manifest.dat
#split_manifest UCEC dat/Transcript.CPTAC3.b1.manifest.dat dat/Transcript.CPTAC3.b1.UCEC.manifest.dat
#split_manifest CCRC dat/Transcript.CPTAC3.b1.manifest.dat dat/Transcript.CPTAC3.b1.CCRC.manifest.dat


split_manifest UCEC manifest/WXS-Germline.CPTAC3.b1.manifest.dat manifest/WXS-Germline.CPTAC3.b1.UCEC.manifest.dat
split_manifest CCRC manifest/WXS-Germline.CPTAC3.b1.manifest.dat manifest/WXS-Germline.CPTAC3.b1.CCRC.manifest.dat

split_manifest UCEC manifest/Fusion.CPTAC3.b1.manifest.dat manifest/Fusion.CPTAC3.b1.UCEC.manifest.dat
split_manifest CCRC manifest/Fusion.CPTAC3.b1.manifest.dat manifest/Fusion.CPTAC3.b1.CCRC.manifest.dat
