#!/bin/sh

# set version number in $3 to the latest SVN repository version number.
# $1 = SVN repository
# $2 = pattern to transform
# $3 = file to process if any, otherwise display version on output

# get build id 

cd $1 > /dev/null
computed_build_id=`git rev-list HEAD | wc -l`
computed_build_sha1=`git rev-parse HEAD`
cd - > /dev/null

if [ "$2" = "" -o "$3" = "" ]; then
	echo $computed_build_id
else
	sed -e "s/$2/$computed_build_id/g" $3 > tmp
	mv tmp $3


	#update the version_info ... if any
	curr_date=$(date '+%Y-%m-%d')
	sed -e "s/Version_info:\ STRING\ =\ \"[0-9a-zA-Z_\,\ \/\:()\.\=\-]*\"/Version_info:\ STRING\ =\ \"Build:\ $computed_build_id ($computed_build_sha1) , Compilation:\ ${curr_date}\"/g" $3 > tmp
	mv tmp $3

fi
