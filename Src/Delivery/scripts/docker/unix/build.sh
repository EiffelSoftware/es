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
	*)
		echo "Usage: "
		echo "  pp: build porterpackage"
		echo "  beta: build beta deliveries"
		echo "  std|standard  : build standard deliveries"
		echo "  ent|enterprise: build enterprise deliveries"
		;;
esac
