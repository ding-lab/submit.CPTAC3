
[Submission details](https://docs.google.com/spreadsheets/d/1Q0GdJpyqJAJBAwk7VkI0Jbqtyldnm4qRjwLjxgLLxRE/edit#gid=386370036)

# Quick start
## Configuration

### Config file 

Edit the following files.  
* batch.dat - timestamp, locale, other per-submission information
* system.dat - system paths per locale
* analyses.dat - Details of analyses (pipelines) used in this batch.  One row per analysis 
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

Each analysis in each submission has configuration defined by 4 files:
* system.dat - system paths
  * `BAMMAP` - path to BamMap file, which defines the paths to input data
  * `SR` - "Submitted Reads" file, providing information about data at GDC
  * `STAGE_ROOT` - path to staging directory
  * `ASCP_CONNECT` - path to ascp
* batch.dat - timestamp, other per-submission information
  * `DATESTAMP` - YYYYMMDD timestamp
  * `SUBMIT` - Submission round (A, B, etc)
  * `PROJECT` - e.g., CPTAC3.b2
  * `DISEASES` - white-space separated list of diseases
* analyses.dat - one row per analysis, may be multiple rows.  Columns are:
  * `ANALYSIS` - canonical analysis name
  * `PIPELINE_VER` - version of this pipeline, e.g., v1.1
  * `DATD` - location of pipeline results directory
  * `PROCESSING_TXT` - path to processing description
  * `REF` - string description of reference
  * `PIPELINE_DAT` - filename of the per-pipeline.dat file, below
* per-pipeline.dat - specified for each analysis, has details of processing and output filename of each pipeline
  * `ES` - experimental strategy
  * `MANIFEST_TYPE` - defines the input files associated with this analysis
  * `INPUT_SUFFIX` - Output filenames have the form, `CASE.INPUT_SUFFIX` (e.g., germline.vcf)
  * `OUTPUT_SUFFIX` - the suffix of the staged files
  * `IS_COMPRESSED` - 1 if compressing file upon staging
  * `RESULT_SUFFIX` - is `OUTPUT_SUFFIX`, add .gz if `IS_COMPRESSED`
  * `IS_SEPARATE_TUMOR_NORMAL` - data are for tumor and normal individually

For each new submission need to edit (at a minimum) `batch.dat` and `analysis.dat`.  The per-pipeline 
details should not change once they are defined.

`batch_config.sh` sources all these and has various scripts for defining paths

The motivation for all these definitions is to allow easier reuse and standardization of pipeline submission

# Testing Uploads

Need to get token in ./DCC

Run `DCC/test_dcc.sh`.  Will need to delete test dataset on DCC.


