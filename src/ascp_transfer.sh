# Upload (submit) data to DCC
# Usage:
# ascp_transfer.sh [options] local_src dcc_dest
#
# local_src: path to base of local directory to be copied
# dcc_dest: path to base directory where submitted data will be written on DCC.  
# Note that the token must be obtained for dcc_dest; it is typically /

# Options:
# -d: dry run

source batch.dat # timestamp, other per-submission information
source system.dat $LOCALE # system paths

if [ ! -e $ASCP_INI ]; then
    >&2 echo ASCP configuration file does not exist: $ASCP_INI
    exit 1
fi

# from ascp_config.ini get values for ASCP_USER and ASCP_TOKEN
source $ASCP_INI

ASCP="$ASCP_CONNECT/bin/ascp"

# http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts ":d" opt; do
  case $opt in
    d) # Dry run 
      >&2 echo "Dry run" >&2
      ASCP="echo $ASCP"
      ;;
#    x) # example of value argument
#      FILTER=$OPTARG
#      >&2 echo "Setting memory $MEMGB Gb" 
#      ;;
    \?)
      >&2 echo "Invalid option: -$OPTARG" 
      exit 1
      ;;
    :)
      >&2 echo "Option -$OPTARG requires an argument." 
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

# Require 1 argument
if [ "$#" -ne 2 ]; then
    >&2 echo Error: Require 2 argument: local_src and dcc_dest
    exit 1  # exit code 1 indicates error
fi

SRC=$1
DEST=$2

# These parameters as suggested by Ratna Thangudu 1/24/18
$ASCP  \
 -i $ASCP_CONNECT/etc/asperaweb_id_dsa.openssh \
 -P 33001 \
 -O 33001 \
 -l 300M \
 -k 2 \
 -T \
 -Q \
 --user $ASCP_USER \
 -W $ASCP_TOKEN \
 --host cptc-xfer.uis.georgetown.edu \
 --mode send \
$SRC $DEST

