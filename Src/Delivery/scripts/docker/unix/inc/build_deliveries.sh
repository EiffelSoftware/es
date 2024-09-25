#!/bin/bash

if [ -f ".env" ]; then
	. ./.env
fi

#####################
# Optional settings #
#####################

#export GIT_EIFFELSTUDIO_REPO_ID=....
#export GIT_EIFFELSTUDIO_BRANCH=Eiffel_19.12
#export SVN_ISE_BRANCH=/branches/Eiffel_19.12


#include_enterprise=true

#include_64bits="true"
#include_64bits="false"
#include_32bits="true"
#include_32bits="false"

#################################
# Do not modify following lines #
#################################
if test -z "$GIT_EIFFELSTUDIO_REPO_ID"; then
	if ! test -z "$1"; then
		export GIT_EIFFELSTUDIO_REPO_ID=$1
	fi
fi

var_dir=`pwd`/var

if [ "$include_enterprise" = "true" ]; then
	edition_kind=ent
else
	edition_kind=standard
fi

echo include_enterprise=$include_enterprise
echo edition_kind=$edition_kind

output_dir=$var_dir/${edition_kind}
if [ ! -e $output_dir ]; then
	mkdir $output_dir
fi

share_deliv_folder()
{
	dn=$1
	msg="$2"
	if [ -e "./share_delivery" ]; then
		sh ./share_delivery $dn "" "$msg"
	else
		echo Folder $dn was not shared.
	fi
}

share_deliv_file()
{
	fn=$1
	msg="$2"
	k=$3
	if [ -e "./share_delivery" ]; then
		sh ./share_delivery $fn $k "$msg"
	else
		echo File $fn was not shared.
	fi
}


if [ "$GIT_EIFFELSTUDIO_REPO_ID" = "" ]; then
	export GIT_EIFFELSTUDIO_REPO_ID=HEAD
fi

echo "===================================="
echo "= Build the $edition_kind PorterPackage ======"
echo "===================================="
sh ./build_porterpackage.sh
if [ -e "$output_dir/last_built_id" ]; then
	deliv_id=`head -n 1 $output_dir/last_built_id`
	porterpackage_tar=$output_dir/$deliv_id/PorterPackage_${deliv_id}.tar
	if [ -e "$porterpackage_tar" ]; then
		pp_filesize=$(stat -c%s "$porterpackage_tar")
		if (( $pp_filesize < 50000000 )); then
			echo "ERROR: File size of $porterpackage_tar sounds too small to be valid (size=$pp_filesize), stop delivery!"
			rm "$porterpackage_tar"
		else
			if [ "$include_enterprise" = "true" ]; then
				echo "Sharing the $edition_kind PorterPackage (including enterprise) to (ent)"
				share_deliv_file $output_dir/${deliv_id}/PorterPackage_${deliv_id}.tar "New $edition_kind Porterpackage for [${deliv_id}]" ent
			else
				if [ "$edition_kind" = "ent" ]; then
					echo "Sharing the $edition_kind PorterPackage to (ent)"
					share_deliv_file $output_dir/${deliv_id}/PorterPackage_${deliv_id}.tar "New $edition_kind Porterpackage for [${deliv_id}]" ${edition_kind}
				else
					echo "Sharing the $edition_kind PorterPackage to (std)"
					share_deliv_file $output_dir/${deliv_id}/PorterPackage_${deliv_id}.tar "New $edition_kind Porterpackage for [${deliv_id}]" ${edition_kind}
				fi
			fi
		fi
	fi
	if [ -e "$porterpackage_tar" ]; then
		if [ "$include_64bits" = "false" ] && [ "$include_32bits" = "false" ]; then
			echo "======================================"
			echo "= Do not build any platform delivery ="
			echo "= only the PorterPackage             ="
			echo "======================================"
		fi
		if [ "$include_64bits" = "true" ]; then
			echo "===================================="
			echo "= Build the $edition_kind 64bits ============="
			echo "===================================="
			sh ./inc/build_images_from.sh $porterpackage_tar $output_dir/${deliv_id} 64 $edition_kind
			share_deliv_folder $output_dir/${deliv_id} "New $edition_kind linux-x86-64 release for [${deliv_id}]"
		fi

		if [ "$include_32bits" = "true" ]; then
			echo "===================================="
			echo "= Build the $edition_kind 32bits ============="
			echo "===================================="
			sh ./inc/build_images_from.sh $porterpackage_tar $output_dir/${deliv_id} 32 $edition_kind
			share_deliv_folder $output_dir/${deliv_id} "New $edition_kind linux-x86 release for [${deliv_id}]"
		fi
	else
		echo ERROR: missing porterpackage "$porterpackage_tar" !
	fi
else
	echo ERROR: issue with previous porterpackage building!
fi
