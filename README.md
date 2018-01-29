Submission scripts for CPTAC3.b1.D submission late January

* WGS CNV

# Data sources

## WGS CNV

I've put per-sample VCFs at `/diskmnt/Projects/CPTAC3CNV/genomestrip/deliverables/batch1`. There's also processing description in REAME.md (with address to the git repository containing the codes).

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
``` 
/diskmnt/Projects/CPTAC3CNV/genomestrip/deliverables/batch1/README.md
```
### Data: 
``` 
/diskmnt/Projects/CPTAC3CNV/genomestrip/deliverables/batch1/C3L-00032.N.vcf
```

# Data Summary

???

Create a results.summary file, with the following columns for each Sample Name:
* SampleName
* Disease
* AnalysisType
* DataPath - where result file found

# Manifest


# Staging


# Upload

using ascp 
