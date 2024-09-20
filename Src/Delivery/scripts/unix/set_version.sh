#!/bin/sh

# set version number in $3 to the latest SVN repository version number.
# $1 = SVN repository
# $2 = pattern to transform
# $3 = file to process if any, otherwise display version on output

# get build id 

cd $1 > /dev/null
computed_build_id=`git rev-list HEAD | wc -l`
cd - > /dev/null

if [ "$2" = "" -o "$3" = "" ]; then
	echo $computed_build_id
else
	sed -e "s/$2/$computed_build_id/" $3 > tmp
	mv tmp $3
fi
