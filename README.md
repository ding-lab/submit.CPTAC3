Submission scripts for CPTAC3.b2.E submission April 2018

* Timestamp: 20180404
  * WGS Germline
  * WGS Somatic

# Uploads

Note: standardized analysis names [here][1]

[1]: https://docs.google.com/spreadsheets/d/1Q0GdJpyqJAJBAwk7VkI0Jbqtyldnm4qRjwLjxgLLxRE/edit#gid=1202137727

# New definition files:

Each analysis in each submission has configuration defined by 4 files:
* system.dat - system paths
  * BAMMAP - path to BamMap file, which defines the paths to input data
  * SR - "Submitted Reads" file, providing information about data at GDC
  * STAGE_ROOT - path to staging directory
  * ASCP_CONNECT - path to ascp
* batch.dat - timestamp, other per-submission information
  * DATESTAMP - YYYYMMDD timestamp
  * SUBMIT - Submission round (A, B, etc)
  * PROJECT - e.g., CPTAC3.b2
  * BATCH - e.g., "batch 2".  This might go away in the future
  * DISEASES - white-space separated list of diseases
* analyses.dat - one row per analysis, may be multiple rows.  Columns are:
  * ANALYSIS - canonical analysis name
  * PIPELINE_VER - version of this pipeline, e.g., v1.1
  * DATD - location of pipeline results directory
  * PROCESSING_TXT - path to processing description
  * REF - string description of reference
  * PIPELINE_DAT - filename of the per-pipeline.dat file, below
* per-pipeline.dat - specified for each analysis, has details of processing and output filename of each pipeline
  * ES - experimental strategy
  * MANIFEST_TYPE - defines the input files associated with this analysis
  * INPUT_SUFFIX - Output filenames have the form, CASE.INPUT_SUFFIX (e.g., germline.vcf)
  * OUTPUT_SUFFIX - the suffix of the staged files
  * IS_COMPRESSED - 1 if compressing file upon staging
  * RESULT_SUFFIX - is OUTPUT_SUFFIX, add .gz if IS_COMPRESSED

`batch_config.sh` sources all these and has various scripts for defining paths

The motivation for all these definitions is to allow easier reuse and standardization of pipeline submission
