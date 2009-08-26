#!/bin/bash

for i in $(seq 0 1 8); do
	echo ----------------------------------------------------
	echo testi0$i:
	ssh weiy@testi0${i}.inf.ethz.ch ps aux | grep weiy
	echo
done

