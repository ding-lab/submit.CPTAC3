# CPTAC3 Year 2 submissions

What's new:
* All analyses come with analysis description file, which is defined here
    https://docs.google.com/document/d/1Ho5cygpxd8sB_45nJ90d15DcdaGCiDqF0_jzIcc-9B4/edit
* Submission takes place using Google Form, https://docs.google.com/forms/d/1hkN9QsLChNDe3xipwE1O3aDBoCfdIMTztoOWSDEagr4/edit
  * This populates Pipeline Management Y2 sheet: https://docs.google.com/spreadsheets/d/19t62v6OA22KK3moXg-kn_CNfXXCGSqtbz5koqVaWqy8/edit#gid=1096034881
  * Submission link: https://docs.google.com/forms/d/e/1FAIpQLSfw5EXIeUEw_pIEjyGhOCJaIAA9MT4Ub5Qlhthudy6RLBVRYw/viewform?usp=sf_link
* Resurrecting submit.CPTAC3 project, incorporating analysis description logic to simplify manifest file creation

GitHub:
```
git clone https://github.com/ding-lab/submit.CPTAC3 PROJECT_NAME
```

# Quick start

Info below is from Y1, may be outdated

## Configuration

### Config file 

Edit the following files.  
* batch.dat - timestamp, locale, other per-submission information
* analyses.dat - Details of analyses (pipelines) used in this batch.  One row per analysis 
* system.dat - system paths per locale
Note that all of these are executed as bash scripts.

### DCC
Configure DCC upload files.  
```
cd DCC
cp ascp_config.ini-template ascp_config.ini
```
Configure `ascp_config.ini` with username and token.  Note that if you are not
uploading to DCC there is no need to configure this file.

#### Testing
Note that this test procedure places a small test file named `uploader_test.tmp` in the root directory of DCC.
It will have the upload user and date, and it is your responsibility to remove it.
```
bash ascp_test.sh
```
Remove test file from DCC using the web interface.

## Processing

```
bash prep_submission.sh stage
bash prep_submission.sh manifest
bash prep_submission.sh description
bash upload_submission.sh
```

# Details
## Definition files:

Each analysis in each submission has configuration defined by 3 files:
* batch.dat - timestamp, other per-submission information
  * `DATESTAMP` - YYYYMMDD timestamp
  * `BATCH` - e.g., Y2.b1
  * `LOCALE` - `MGI`, `katmai`, `denali`
* analyses.dat - one row per analysis, may be multiple rows.  Columns are:
  * `ANALYSIS` - canonical analysis name
  * `PIPELINE_VER` - version of this pipeline, e.g., v1.1
  * `ANALYSIS_DESCRIPTION` - Description of all results and their input.  Format described [here](https://docs.google.com/document/d/1Ho5cygpxd8sB_45nJ90d15DcdaGCiDqF0_jzIcc-9B4/edit)
  * `PROCESSING_TXT` - path to processing description
  * `REF` - string description of reference
  * `DO_COMPRESS` - 1 if compressing data files upon staging, 0 otherwise
  * `PREPEND_CASE` - 1 if add prefix CASE to data filename upon staging, 0 otherwise
* system.dat - system paths
  * `BAMMAP` - path to BamMap file, which defines the paths to input data.  Submission scripts iterate over this file
  * `SR` - "Submitted Reads" file, providing information about data at GDC
  * `STAGE_ROOT` - path to staging directory
  * `ASCP_CONNECT` - path to ascp

For each new submission need to edit (at a minimum) `batch.dat` and `analysis.dat`.  The per-pipeline 
details should not change once they are defined.

`batch_config.sh` sources all these and has various scripts for defining paths

The motivation for all these definitions is to allow easier reuse and standardization of pipeline submission

# Testing Uploads

Need to get token in ./DCC

Run `DCC/test_dcc.sh`.  Will need to delete test dataset on DCC.
