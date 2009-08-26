#!/bin/bash

curr_dir=`pwd`

cd $EIFFEL_SRC
svn up
cd $EIFFEL_SRC/library/base/elks

mkdir ~/eifgens/sats64
cd $EIFFEL_SRC/Eiffel/Ace

ec -config ec.ecf -target bench_unix -project_path ~/eifgens/sats64 -c_compile -finalize -clean

cp ~/eifgens/sats64/EIFGENs/bench_unix/F_code/ec $ISE_EIFFEL/studio/spec/$ISE_PLATFORM/bin/ecp

cd $curr_dir





