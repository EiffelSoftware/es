#!/bin/bash

source ~/.bashrc

session_length=$5
desired_host_name=$1
start_index=$2
end_index=$3
method=$4

python ~/sats/scripts/start_autotest.py $desired_host_name ~/sats/classes/60classes/0145678/${desired_host_name}_classes.txt -m $method -t $session_length -s ${start_index}-${end_index}

