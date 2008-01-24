#!/bin/bash
currentTime=`date +%F__%T | sed 's/:/./g'`
mkdir -p ./_RESULTS_/${currentTime}/expected
mkdir -p ./_RESULTS_/${currentTime}/outcome
cp -r ./_RESULTS_/outcome/* -t ./_RESULTS_/${currentTime}/outcome
cp -r ./_RESULTS_/expected/* -t ./_RESULTS_/${currentTime}/expected
cp ./_RESULTS_/result.txt ./_RESULTS_/${currentTime}/result.txt
