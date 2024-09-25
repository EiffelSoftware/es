#!/bin/bash

#####################
# Optional settings #
#####################

if [ -n "$1" ]; then
	export SVN_ISE_BRANCH=/branches/Eiffel_$1
	export GIT_EIFFELSTUDIO_BRANCH=Eiffel_$1
	if [ -n "$2" ]; then
		export GIT_EIFFELSTUDIO_REPO_ID=$2
	fi
fi

export include_enterprise=true

#export include_64bits="true"
export include_64bits="false"
#export include_32bits="true"
export include_32bits="false"

./inc/build_deliveries.sh

