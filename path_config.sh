# Set system-specific paths here


# SR and BAM MAP are used to get all cases and the associated disease

# BMHOME is where BamMap files live (one each for WGS, RNA-SEQ, WXS).  Note that this will be different for b2, which has a single unified BamMap file
#BMHOME="/diskmnt/Projects/Users/mwyczalk/data/CPTAC3/import.CPTAC3/import.CPTAC3.b1/BamMap"
BMHOME="/gscuser/mwyczalk/projects/CPTAC3/data/GDC_import/import.config/CPTAC3.b1"

# SR file (from "Submitted Reads") is created by case discovery, and provides information necessary
# for download of BAM and FASTQ files from GDC
SR="$BMHOME/SR.CPTAC3.b1.dat"

# where verbatim copy of uploaded data is stored
STAGE_ROOT="/gscmnt/gc2521/dinglab/mwyczalk/CPTAC3-submit/staged_data.${PROJECT}.${SUBMIT}"

#ASCP_CONNECT="/home/mwyczalk_test/.aspera/connect"
ASCP_CONNECT="/gscuser/mwyczalk/.aspera/connect"
