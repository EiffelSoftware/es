#!/bin/bash
#

if [ -f ".env" ]; then
	. ./.env
fi

if [ -z "$GIT_EIFFELSTUDIO_REPO_ID" ]; then
        GIT_EIFFELSTUDIO_REPO_ID=HEAD
fi

var_dir=`pwd`/var

if [ "$include_enterprise" = "true" ]; then
	edition_kind=ent
else
	edition_kind=standard
fi


docker_image_name=local/eiffel-deliv-porterpackage
docker rmi ${docker_image_name}

docker build -t ${docker_image_name} -f ./porterpackage/dockerfile porterpackage

if [ -z "$SVN_ISE_REPO" ]; then
	SVN_ISE_REPO=svn://svn.ise/ise_svn
fi
if [ -z "$GIT_EIFFELSTUDIO_REPO" ]; then
        GIT_EIFFELSTUDIO_REPO=https://gitlab.com/eiffelsoftware/es.git
fi
if [ -z "$GIT_EIFFELSTUDIO_BRANCH" ]; then
        GIT_EIFFELSTUDIO_BRANCH=master
fi
if [ -z "$make_delivery_args" ]; then
        make_delivery_args=
fi
echo Use EiffelStudio repo $GIT_EIFFELSTUDIO_REPO branch $GIT_EIFFELSTUDIO_BRANCH
echo Use ISE repo $SVN_ISE_REPO

# Volumes ...

if [ -d "$var_dir/eiffel" ]; then
	echo Use Eiffel installation from $var_dir/eiffel/...
    t_docker_vol_opts="-v $var_dir/eiffel:/home/eiffel/Eiffel"
	#docker volume create eiffel-deliv-pp-eiffel
fi

docker_output_volume=eiffel-deliv-pp-output-$edition_kind
#docker volume create ${docker_output_volume}

#Container execution
docker run \
		--rm \
        --name=eiffel-deliv-pp \
        --network host \
		--user $(id -u):$(id -g) \
		-e USER_ID=$(id -u) \
		-e USER_GID=$(id -g) \
        -e SVN_ISE_REPO=$SVN_ISE_REPO \
        -e SVN_ISE_BRANCH=$SVN_ISE_BRANCH \
        -e GIT_EIFFELSTUDIO_REPO=$GIT_EIFFELSTUDIO_REPO \
        -e GIT_EIFFELSTUDIO_BRANCH=$GIT_EIFFELSTUDIO_BRANCH \
        -e GIT_EIFFELSTUDIO_REPO_ID=$GIT_EIFFELSTUDIO_REPO_ID \
		-e INCLUDE_ENTERPRISE=$include_enterprise \
		-e MAKE_DELIVERY_ARGS=$make_delivery_args \
        --mount source=${docker_output_volume},target=/home/eiffel/deliv/output ${t_docker_vol_opts} \
        ${docker_image_name}


output_dir=$var_dir/$edition_kind
mkdir -p $output_dir

echo "Copy PorterPackage results from volume to [${output_dir}]"
docker run -d --name ${docker_output_volume}_tmp --mount source=${docker_output_volume},target=/data alpine
docker cp ${docker_output_volume}_tmp:/data/. ${output_dir}
docker kill ${docker_output_volume}_tmp
docker rm ${docker_output_volume}_tmp

#docker rmi ${docker_image_name}

