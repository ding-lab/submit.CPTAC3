Submission scripts for CPTAC3.b1.E submission early February 2018

* WGS SV

# Data sources

## WGS SV

UCEC: `/gscmnt/gc2521/dinglab/wliao/somatic/SV/Manta/filtered_VCF/UCEC`
CCRC: `/gscmnt/gc2521/dinglab/wliao/somatic/SV/Manta/filtered_VCF/CCRC`

# Git strategy

* Different submissions will have different directories on disk, but share
  codebase, which is versioned and tagged for every submit.  Implicit
assumption is that submissions worked on one at a time, then not reworked
thereafter (pearls on a string).

```
git tag -a CPTAC3.b1.C
```

# Data source details

## WGS CNV
### Description: 
`/gscuser/mwyczalk/projects/CPTAC3/submit/submit.CPTAC3.b1.C/batch.dat/description.somaticSV.txt`

### Data: 
``` 
/gscmnt/gc2521/dinglab/wliao/somatic/SV/Manta/filtered_VCF/CCRC/C3L-00359.somaticSV.filtered.vcf
```

# Data Summary

# Manifest


# Staging


# Upload

## How to test (`DCC/test_ascp.sh`)
