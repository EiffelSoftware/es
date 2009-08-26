#!/bin/bash

for i in $(seq 1 1 10); do
	echo --${i}----------------------------------------------------
	for j in $(seq 0 1 8); do
		ssh weiy@testi0${j}.inf.ethz.ch bash /home/weiy/sats/scripts/kill_testing.sh
	done
done
#ssh weiy@testi00.inf.ethz.ch bash /home/weiy/sats/scripts/kill_testing.sh
#ssh weiy@testi01.inf.ethz.ch bash /home/weiy/sats/scripts/kill_testing.sh
#ssh weiy@testi02.inf.ethz.ch bash /home/weiy/sats/scripts/kill_testing.sh
#ssh weiy@testi03.inf.ethz.ch bash /home/weiy/sats/scripts/kill_testing.sh
#ssh weiy@testi04.inf.ethz.ch bash /home/weiy/sats/scripts/kill_testing.sh
#ssh weiy@testi05.inf.ethz.ch bash /home/weiy/sats/scripts/kill_testing.sh
#ssh weiy@testi06.inf.ethz.ch bash /home/weiy/sats/scripts/kill_testing.sh
#ssh weiy@testi07.inf.ethz.ch bash /home/weiy/sats/scripts/kill_testing.sh
#ssh weiy@testi08.inf.ethz.ch bash /home/weiy/sats/scripts/kill_testing.sh

