#!/bin/sh
#


if [ -f "./.env" ]; then 
	. ./.env
fi

op=$1
if [ -n "$1" ]; then
	shift
fi
case "$op" in
	p*)
		./build_porterpackage.sh $*
		;;
	beta)
		./build_beta_deliveries.sh $*
		;;
	ent*)
		./build_ent_deliveries.sh $*
		;;
	st*)
		./build_standard_deliveries.sh $*
		;;
	cancel)
		echo Cancel any running deliv container
		docker kill eiffel-deliv-pp
		docker kill eiffel-deliv-img-64bits
		docker kill eiffel-deliv-img-32bits
		;;
	clean)
		echo Clean PP and Images
		./docker_op.sh pp vol st clean
		./docker_op.sh i64 vol st clean
		./docker_op.sh i32 vol st clean
		;;
	*)
		echo "Usage: "
		echo "  pp: build porterpackage"
		echo "  beta: build beta deliveries"
		echo "  std|standard  : build standard deliveries"
		echo "  ent|enterprise: build enterprise deliveries"
		echo "  cancel: cancel any running deliv execution"
		echo "  clean: clean PP and Images"
		;;
esac
