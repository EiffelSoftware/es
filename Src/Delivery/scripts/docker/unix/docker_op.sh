#!/bin/sh
#

process_docker_volume() 
{
	echo vol $*
	#echo dname=$dname
	#echo dtype=$dtype
	if [ -n "$1" ]; then
		case "$1" in
			e*)
				dkind=ent
				;;
			s*)
				dkind=standard
				;;
			*)
				dkind=standard
				;;
		esac
		shift

		case "$1" in
			sh*)
				cmd="sh"
				;;
			tree)
				cmd="tree /data"
				;;
			clean)
				#cmd="ls -1R /data/"
				cmd="rm -rf /data/"
				;;
			*)
				if [ -n "$1" ]; then
					cmd=$*
				else
					cmd="tree /data" 
				fi
				;;
		esac

		echo kind=$dkind
		echo cmd=$cmd

		docker_output_volume=eiffel-deliv-${dtype}-output-$dkind
		#echo docker_output_volume=$docker_output_volume
 		docker run --rm -it --name ${dname}_vol_tmp --mount source=${docker_output_volume},target=/data alpine $cmd
 	else
 			echo "Error missing kind: standard | enterprise"
 	fi
}


case "$1" in
	p*)
		dname=eiffel-deliv-pp
		dtype=pp
		;;
	i*32*)
		dtype=image
		dname=eiffel-deliv-img-32bits
		;;
	i*|i*64*)
		dtype=image
		dname=eiffel-deliv-img-64bits
		;;
	*)
		echo "Usage:  (p|i) (logs|shell|volume)"
		echo "  p or pp or porterpackage"
		echo "  i* or i*64* for 64bit image"
		echo "  i*32* for 32bit image"
		exit -1
		;;
esac

shift
case "$1" in
	vol*)
		shift
		process_docker_volume $*
		;;
	log*)
		docker logs $dname
		;;
	sh*)
		docker exec -it $dname sh
		;;
	*)
		echo "Potential actions: logs, shell, vol"
		;;
esac
