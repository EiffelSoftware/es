#!/bin/sh
#Written by Eric Lo 2006 for ETHZ DB course, changed by Domenic for Eiffel :-)
find . -name "*.ace" -print | while read filename
do
	mv -f $filename $filename.out
        sed -r 's/\\/\//g' $filename.out > $filename.2
  	sed -r 's/mtnet.lib/libmtnet.a/g' $filename.2 > $filename.3
	sed -r 's/ISE_C_COMPILER/ISE_PLATFORM/g' $filename.3 > $filename
	rm -f $filename.3
	rm -f $filename.2
        rm -f $filename.out
done 
echo "Changed \ --> /, mtnet.lib --> libmtnet, \$ISE_C_COMPILER --> linux-86"
echo "Should now be Linux-Eiffel-readable"
