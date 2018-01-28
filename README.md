Submission scripts for CPTAC3.b1.C Jan 15 submission.

* WGS Somatic
* WGS Germline

Somatic manifest has both tumor and normal, while germline has just normal
Somitic manifest based on epazote:/Users/mwyczalk/Data/CPTAC3/submit.CPTAC3.b1.A/manifest/2_make_Somatic.WXW_Manifest.sh

VCF is gzipped prior to upload

# git strategy

* Different submissions will have different directories on disk, but share codebase, which is versioned and tagged for every submit.  Implicit assumption is that submissions worked on one at a time, then not reworked thereafter.
```
git tag -a CPTAC3.b1.C
```

# Data source details

## WGS CNV
### Description: 
``` ```
### Data: 
``` ```

## WGS Germline
### Description: 
``` /gscmnt/gc2521/dinglab/scao/cptac3/wgs/germline_per_sample/processing_description_121517.txt ```
### Data: 
``` /gscmnt/gc2521/dinglab/scao/cptac3/wgs/germline_per_sample  ```

## WGS Somatic
### Description: 
``` /gscmnt/gc2521/dinglab/scao/cptac3/wgs/somatic_per_sample/processing_description_121517.txt ```
### Data: 
``` /gscuser/scao/gc2521/dinglab/scao/cptac3/wgs/somatic_per_sample ```







# Data Summary

Create a results.summary file, with the following columns for each Sample Name:
* SampleName
* Disease
* AnalysisType
* DataPath - where result file found

# Manifest

Writes to ./manifest.  Duplicates some work of Data Summary (e.g., finding paths to orig data)

# Staging

Copies all data to STAGING_ROOT using paths which will be on DCC



# Upload

using ascp 
