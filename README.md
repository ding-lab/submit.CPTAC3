Submission scripts for CPTAC3.b1.B December 15 submission.

Based on work on Epazote here: /Users/mwyczalk/Data/CPTAC3/submit.CPTAC3.b1.A, which is partly copied 
to ./submit.CPTAC3.b1.A for reference

Some improvements can be made here for modularity (e.g., process per-modality)
Also, clear up redundancy between data summary and manifest

Data are staged for downloding here: /gscmnt/gc2521/dinglab/mwyczalk/CPTAC3-submit/staged_data.CPTAC3.b1.B

# Workflow:

Process the following Analyses:
* WXS Germline
* Fusion

For each, need data and processing description.

WXS Germline
* Description: /gscmnt/gc2521/dinglab/scao/cptac3/wxs/germline_per_sample/processing_description_121517.txt
* Data: /gscmnt/gc2521/dinglab/scao/cptac3/wxs/germline_per_sample

Fusion
* Description: /gscmnt/gc2521/dinglab/qgao/Scripts/Fusion/fusion_worklog
* Data: /gscmnt/gc2521/dinglab/qgao/Submission/Fusion/Fusionsin*.txt

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


