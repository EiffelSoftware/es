#!/bin/bash

porterpackage_archive=$1
image_output=$2
deliv_platform=$3
edition_kind=$4
case $deliv_platform in
	64|linux-x86-64)
		deliv_platform="64bits"
		;;
	32|linux-x86)
		deliv_platform="32bits"
		;;
	*)
		deliv_platform="64bits"
		;;
esac

echo Build the $edition_kind for ${deliv_platform}  
echo  - from $porterpackage_archive
echo  - output $image_output

if [ -e "$porterpackage_archive" ]; then
	if [ -d "$image_output" ]; then

		docker_image_name=local/eiffel-deliv-image-${deliv_platform}
		docker_output_volume=eiffel-deliv-image-output-$edition_kind
		     
		docker rmi $docker_image_name 
		docker build -t $docker_image_name -f ./image/dockerfile-${deliv_platform} image
		docker run \
			--rm \
			--name=eiffel-deliv-img-${deliv_platform} \
			--network host \
			--user $(id -u):$(id -g) \
			-e USER_ID=$(id -u) \
			-e USER_GID=$(id -g) \
			-e PORTERPACKAGE_TAR=/home/eiffel/porterpackage.tar \
        	--mount source=${docker_output_volume},target=/home/eiffel/deliv/image \
			-v ${porterpackage_archive}:/home/eiffel/porterpackage.tar \
			${docker_image_name}
		#docker rmi $docker_image_name 
		#
		echo "Copy results from volume to [${image_output}]"
		docker run -d --name ${docker_output_volume}_tmp --mount source=${docker_output_volume},target=/data alpine
		docker cp ${docker_output_volume}_tmp:/data/. $image_output
		docker kill ${docker_output_volume}_tmp
		docker rm ${docker_output_volume}_tmp

	else
		echo ERROR: bad output folder ${image_output} !
	fi
else
	echo ERROR: missing porterpackage ${porterpackage_archive} 
fi

