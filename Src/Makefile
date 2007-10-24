# Global Makefile for the EiffelStudio source
# 

GEANT=geant

help:
	@echo "EiffelStudio source tree"
	@echo ""
	@echo "The following targets are available:"
	@echo "    check_setup      Check if everything is correctly setup"
	@echo "    build_dev        Setup an environment for development"
	@echo "    build_delivery   Build a delivery from the source tree"
	@echo "    clean            Clean up the tree"

# ----------------------------------------------------------------------
# Official targets

check_setup: check_geant
	geant check_setup

build_dev: check_geant
	
	geant build_dev

clean: check_geant
	geant clean

build_delivery: check_geant
	geant build_delivery

# ----------------------------------------------------------------------
# Supporting targets

check_geant:
	@which ${GEANT} > /dev/null || (echo "geant not found, aborting ..." ; exit 1)

.PHONY: help check_setu dev_setup

