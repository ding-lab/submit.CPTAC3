Submission scripts for CPTAC3.b1.F submission February 2018

* Timestamp: 20180225
* De Novo pipeline.  Processing RNA-Seq.

# Data sources

Description: /Projects/cptac/denovo/Scripts/denovo_worklog
TODO: Edit the description to remove local dependencies 

Data: /Projects/cptac/denovo/Submission

Data filename example: `CCRC__C3N-00194.fasta.gz`

Note that these files are ~1Gb in size uncompressed.  Qingsong has compressed these.

# Description (updated)
```
RNA-Seq denovo assembly was preformed with Trinity (v2.5.1), available at https://github.com/trinityrnaseq/trinityrnaseq/releases

Output files are in standard FASTA format.  Details can be found in https://github.com/trinityrnaseq/trinityrnaseq/wiki/Output-of-Trinity-Assembly
```
This is saved to the file `description/RNA-Seq_DeNovo.txt` by the script `3_stage_description.sh`


# Git strategy

* Different submissions will have different directories on disk, but share
  codebase, which is versioned and tagged for every submit.  Implicit
assumption is that submissions worked on one at a time, then not reworked
thereafter (pearls on a string).

```
git tag -a CPTAC3.b1.C
```

