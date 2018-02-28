Submission scripts for CPTAC3.b2.A submission February 2018

* Timestamp: 20180228
    * WGS SV 
    * WXS CNV

# Data sources

## WGS SV

Results: `/diskmnt/Projects/Users/wliao/CPTAC3/somatic/SV/batch2`

Please read README.md for the workflow description: `/diskmnt/Projects/Users/wliao/CPTAC3/somatic/SV/batch2/README.md`

Data filename example: `C3L-00004.SV.WGS.vcf`

## WXS CNV

Results: `/diskmnt/Projects/CPTAC3CNV/gatk4wxscnv/deliverables`
Processing: /diskmnt/Projects/CPTAC3CNV/gatk4wxscnv/deliverables/README.md
Filename exmple: `C3L-00769.gatk4wxscnv.cnv`


# Git strategy

* Different submissions will have different directories on disk, but share
  codebase, which is versioned and tagged for every submit.  Implicit
assumption is that submissions worked on one at a time, then not reworked
thereafter (pearls on a string).

```
git tag -a CPTAC3.b1.C
```

