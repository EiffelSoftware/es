#!/bin/bash

# Setup environment, and remaining installation steps
echo id=`id`
echo Current dir =`pwd` 
echo WORK_DIR=$WORK_DIR

cd workspace
mkdir -p home
export HOME=$(pwd)/home
export XDG_DATA_HOME=${HOME}/.local/share
mkdir -p ${XDG_DATA_HOME}

echo Install the dotnet environment
curl -sSL -o dotnet-install.sh https://dot.net/v1/dotnet-install.sh
chmod +x ./dotnet-install.sh
export DOTNET_CLI_HOME=${HOME}
export DOTNET_ROOT=${DOTNET_CLI_HOME}/.dotnet
./dotnet-install.sh --version latest --channel 6.0 --install-dir ${DOTNET_ROOT}
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

# Build porterpackage
echo User: $(id -u):$(id -g)
echo + SVN_ISE_REPO=$SVN_ISE_REPO
echo + SVN_ISE_BRANCH=$SVN_ISE_BRANCH
echo + GIT_EIFFELSTUDIO_REPO=$GIT_EIFFELSTUDIO_REPO
if [ -z "$GIT_EIFFELSTUDIO_BRANCH" ]; then
	export GIT_EIFFELSTUDIO_BRANCH=master
	echo ++GIT_EIFFELSTUDIO_BRANCH=$GIT_EIFFELSTUDIO_BRANCH
else
	echo + GIT_EIFFELSTUDIO_BRANCH=$GIT_EIFFELSTUDIO_BRANCH
fi
echo + INCLUDE_ENTERPRISE=$INCLUDE_ENTERPRISE
echo + ONLY_PORTERPACKAGE=$ONLY_PORTERPACKAGE
echo + MAKE_DELIVERY_ARGS=$MAKE_DELIVERY_ARGS

export DELIV_DIR=$1
echo = DELIV_DIR=$DELIV_DIR
if [ ! -d "$DELIV_DIR" ]; then
	echo Create $DELIV_DIR
	mkdir -p $DELIV_DIR
fi
if [ ! -d "$DELIV_DIR/output" ]; then
	echo Create $DELIV_DIR/output
	mkdir -p $DELIV_DIR/output
fi


echo Install EiffelStudio
if [ -z "$EIFFEL_SETUP_CHANNEL" ]; then
	export EIFFEL_SETUP_CHANNEL=nightly
fi
if [ -d $WORK_DIR/Eiffel ]; then
	ls -la  $WORK_DIR/Eiffel
else
	mkdir -p $WORK_DIR/Eiffel
fi
if [ -d $WORK_DIR/Eiffel/${EIFFEL_SETUP_CHANNEL}/studio ]; then
	echo "Already installed!"
else
	echo Installing nighlty release from eiffel.org/setup.
	curl -sSL https://www.eiffel.org/setup/install.sh | bash -s -- --channel ${EIFFEL_SETUP_CHANNEL} --platform ${ISE_PLATFORM} --install-dir $WORK_DIR/Eiffel/${EIFFEL_SETUP_CHANNEL} --dir $WORK_DIR
fi

# Define Eiffel environment variables
export ISE_EIFFEL=$WORK_DIR/Eiffel/${EIFFEL_SETUP_CHANNEL}
export ISE_LIBRARY=$ISE_EIFFEL
export PATH=$PATH:$ISE_EIFFEL/studio/spec/$ISE_PLATFORM/bin:$ISE_EIFFEL/tools/spec/$ISE_PLATFORM/bin:$ISE_EIFFEL/library/gobo/spec/$ISE_PLATFORM/bin:$ISE_EIFFEL/esbuilder/spec/$ISE_PLATFORM/bin

export DELIV_ID=$GIT_EIFFELSTUDIO_REPO_ID

echo = ISE_EIFFEL=$ISE_EIFFEL

# Initialization
export PATH=$PATH:.
if [ -z "$GIT_EIFFELSTUDIO_REPO" ]; then
	export GIT_EIFFELSTUDIO_REPO=https://gitlab.com/eiffelsoftware/es.git
fi

export DEFAULT_ES_ROOT=$GIT_EIFFELSTUDIO_REPO
echo DEFAULT_ES_ROOT=$DEFAULT_ES_ROOT
export DEFAULT_ES_BRANCH=$GIT_EIFFELSTUDIO_BRANCH
echo DEFAULT_ES_BRANCH=$DEFAULT_ES_BRANCH

if [ -z "$SVN_ISE_REPO" ]; then
	export SVN_ISE_REPO=svn://svn.ise/ise_svn
fi
if [ -z "$SVN_ISE_BRANCH" ]; then
	export DEFAULT_ISE_SVN=$SVN_ISE_REPO/trunk
else
	export DEFAULT_ISE_SVN=$SVN_ISE_REPO$SVN_ISE_BRANCH
fi
echo = DEFAULT_ISE_SVN=$DEFAULT_ISE_SVN

echo Build PorterPackage in $DELIV_DIR
echo Use EiffelStudio repo url: $DEFAULT_ES_ROOT branch $DEFAULT_ES_BRANCH
echo Use ISE svn url: $DEFAULT_ISE_SVN

# Main
export DELIV_WORKSPACE=$WORK_DIR/workspace

# save setup in setup.rc for convenience
echo export ISE_EIFFEL=$ISE_EIFFEL > ${DELIV_WORKSPACE}/setup.rc
echo export ISE_PLATFORM=$ISE_PLATFORM >> ${DELIV_WORKSPACE}/setup.rc
echo export DOTNET_ROOT=$DOTNET_ROOT >> ${DELIV_WORKSPACE}/setup.rc
echo export PATH=$PATH >> ${DELIV_WORKSPACE}/setup.rc

if [ -d "$DELIV_WORKSPACE/tmp" ]; then
	echo Clean $DELIV_WORKSPACE/tmp
	\rm -rf $DELIV_WORKSPACE/tmp
fi

echo Build delivery for $ISE_PLATFORM
if [ -n "$DELIV_ID" ]; then
	echo build id: $DELIV_ID
fi

git clone --single-branch --branch $GIT_EIFFELSTUDIO_BRANCH $GIT_EIFFELSTUDIO_REPO $DELIV_WORKSPACE/wc
ln -s $DELIV_WORKSPACE/wc/Src/Delivery/scripts/unix $DELIV_WORKSPACE/tmp

echo Get revision from source code
if [ ! "$DELIV_ID" ]; then
	DELIV_ID=`$DELIV_WORKSPACE/tmp/set_version.sh $DELIV_WORKSPACE/tmp`
else
	if [ "$DELIV_ID" = "HEAD" ]; then
		DELIV_ID=`$DELIV_WORKSPACE/tmp/set_version.sh $DELIV_WORKSPACE/tmp`
	else
		DELIV_ID=$DELIV_ID
	fi
fi

echo Building for $DELIV_ID
DELIV_OUTPUT=$DELIV_DIR/output/${DELIV_ID}

# Clean previous porterpackage building
if [ -e "${DELIV_DIR}/output/last_built_id" ]; then
	\rm -f $DELIV_DIR/output/last_built_id
fi
if [ -d "${DELIV_OUTPUT}" ]; then
	\rm -rf ${DELIV_OUTPUT}
fi

# Create output folder
mkdir -p ${DELIV_OUTPUT}

DELIV_LOGDIR=$DELIV_OUTPUT/${DELIV_ID}_pp_logs/
if [ -d "$DELIV_LOGDIR" ]; then
	\rm -rf "$DELIV_LOGDIR"
fi
mkdir -p "$DELIV_LOGDIR"

cd $DELIV_WORKSPACE/tmp
STUDIO_PORTERPACKAGE_TAR=$DELIV_OUTPUT/PorterPackage_${DELIV_ID}.tar
if [ -f "$STUDIO_PORTERPACKAGE_TAR" ]; then
	echo Reuse $STUDIO_PORTERPACKAGE_TAR
	tar xf "$STUDIO_PORTERPACKAGE_TAR"
fi
if [ ! -d "PorterPackage" ]; then
	if [ "$INCLUDE_ENTERPRISE" == "true" ]; then
		echo Build Standard+Enterprise PorterPackage ...
		./make_delivery all $MAKE_DELIVERY_ARGS
	else
		echo Build Standard PorterPackage ...
		./make_delivery $MAKE_DELIVERY_ARGS
	fi
	echo Copy log files to $DELIV_LOGDIR
	cp *.log $DELIV_LOGDIR/.
fi
if [ -d "PorterPackage" ]; then
	if [ ! -f "$STUDIO_PORTERPACKAGE_TAR" ]; then
		echo Create tar archive $STUDIO_PORTERPACKAGE_TAR .
		tar cvf $STUDIO_PORTERPACKAGE_TAR PorterPackage
	fi
	echo PorterPackage is ready: $STUDIO_PORTERPACKAGE_TAR
	ls -la $DELIV_OUTPUT
	echo ${DELIV_ID} > $DELIV_DIR/output/last_built_id
	echo content of $DELIV_DIR/output/
	ls -la $DELIV_DIR/output/
else
	echo Missing PorterPackage!
fi
