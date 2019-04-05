Testing staging and upload for CPTAC3 Y2

Analysis Summary details.  Some of these were modified by hand in analysis_summary.manual_edit

Details of file format: https://docs.google.com/document/d/1Ho5cygpxd8sB_45nJ90d15DcdaGCiDqF0_jzIcc-9B4/edit

## Analysis Summary

MSI: after discussion, Dan updated analysis summary to reflect what I need.  Can be used directly:
    /diskmnt/Projects/cptac_scratch/CPTAC3_analysis/MSI_hg38/Y2.b1/LSCC/Y2.b1_LSCC.analysis_description.dat
    /diskmnt/Projects/cptac_scratch/CPTAC3_analysis/MSI_hg38/Y2.b1/GBM/Y2.b1_GBM.analysis_description.dat
    /diskmnt/Projects/cptac_scratch/CPTAC3_analysis/MSI_hg38/Y2.b1/HNSCC/Y2.b1_HNSCC.analysis_description.dat

BICSEQ:
    /diskmnt/Projects/CPTAC3CNV/BICSEQ2/BICSEQ2/testing/docker_call/run_cases.Y2.b1.katmai/dat/Y2.b1.analysis_description.dat
    edited automatically to yield
    /home/mwyczalk_test/Projects/CPTAC3/submit.Y2/Y2.b1.A.SomaticSV/analysis_summary.manual_edit/BICSEQ2/BICSEQ2.Y2.b1.analysis_description.dat
    -> this needs to be compressed

SomaticSV: good as is
    /home/mwyczalk_test/Projects/SomaticSV/somatic_sv_workflow/demo/task_call/katmai.C3/dat/analysis_summary.dat

QC:
    /diskmnt/Projects/cptac_scratch/CPTAC3_analysis/CPTAC3_QC/y2.b1/y2.b1.QC_FastQC.dat
    Edited by script to yield
	/home/mwyczalk_test/Projects/CPTAC3/submit.Y2/Y2.b1.A.SomaticSV/analysis_summary.manual_edit/QC/QC.Y2.b1.analysis_summary.dat
