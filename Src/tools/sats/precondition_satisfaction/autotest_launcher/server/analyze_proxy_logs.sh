#!/bin/bash
# This script analyze logs files from AutoTest and store results.
# Usage: analyze_proxy_logs.sh <testi_machine>
# <testi_machine> is the machine name in the testi cluster where log files are storeed, for example testi01


testi_machine=$1

logs_dir=~/sats/logs
temp_logs_dir=~/sats/temp_logs
results_dir=~/sats/results
project_dir=~/sats/project

#Copy logs files from testi cluster
scp weiy@${testi_machine}.inf.ethz.ch://home/weiy/sats/logs/*.txt ${temp_logs_dir}

#Analyze logs in ${temp_logs_dir}
python analyze_logs.py ${temp_logs_dir} ${results_dir} ${project_dir}

#Copy logs from ${temp_logs_dir} to ${logs_dir}
cp ${temp_logs_dir}/*.txt ${logs_dir}

#Remove logs in ${temp_logs_dir}
rm ${temp_logs_dir}/*


