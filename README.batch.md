Testing staging and upload for CPTAC3 Y2 b2

From email 5/2/19, "CPTAC3 Year 2 Batch 2 analysis request":
    The specific cases we are considering are listed in the CPTAC3.cases.dat
    file.  There are two types of “sub-batches” (column 3 in cases file) we are
    processing:
    * Batch "Y2.b2" has 56 cases, 17 GBM and 39 UCEC.  This sub-batch has WXS,
      WGS, and RNA-Seq data Batch 
    * "Y2.b2-noWXS" has 77 PDA cases.  This sub-batch has WGS, and RNA-Seq data.
      DO NOT process WXS data (even if it is available) since it will be replaced
      at a later time.

As a result, WXS-based analyses will have 56 cases, while RNA-Seq and WGS analyses will have 133 cases

Pipelines being uploaded here:
* WXS_MSI
* RNA-Seq_Transcript_Splicing
* RNA-Seq_Fusion
* WGS_CNV_Somatic
* WGS_SV

Note that the following pipelines have GBM and UCEC results in separate directories
* WXS_MSI
* RNA-Seq_Fusion

The analysis summary format for WGS_CNV_Somatic is old, and requires manual correction.
These changes should be communicated to Yige and fixed on her end for batch 3.  For now,
doing ad hoc script to modify the analysis summary based on work for Y2 batch 1.
Corrected analysis summary file:
    /diskmnt/Projects/cptac_scratch/CPTAC3.workflow/submit.Y2/Y2.b2.20190529/analysis_summary.manual_edit/BICSEQ2/BICSEQ2.Y2.b1.analysis_description.dat
