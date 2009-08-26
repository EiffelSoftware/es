#!/bin/bash

#Method to test, either "or" or "ps", "or" means original AutoTest, "ps" means AutoTest with precondition evaluation.

method="ps"

#Machines that are to be used as testing testi00~testi08

machines="0 1 4 5 6 7 8"

#Start and end index for test run for each class,
start_index=1
end_index=3

#Time to spend in each test run
minute=61

#Start all machines for testing
for i in $machines; do
	screen -d -m -S testi0${i} ssh weiy@testi0${i}.inf.ethz.ch /home/weiy/sats/scripts/run.sh testi0${i} $start_index $end_index $method $minute
done

