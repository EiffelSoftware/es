# 
#	component:   "openEHR common libraries"
#	description: "Object Graph Parser builder script"
#	keywords:    "paths"
#	author:      "thomas.beale@oceaninformatics.com"
#	support:     "http://www.openehr.org/issues/browse/AWB"
#	copyright:   "Copyright (c) 2010 openEHR Foundation <http://www.openEHR.org>"
#	license:     "See notice at bottom of class"
#
#	file:        "$URL: https://svn.origo.ethz.ch/abel/trunk/libraries/openehr/src/object_graph/path/make_parser.sh $"
#	revision:    "$LastChangedRevision$"
#	last_change: "$LastChangedDate$"
#

$GOBO/bin/geyacc --new_typing -v parser_errs.txt -t OG_PATH_TOKENS -o og_path_validator.e og_path_validator.y

$GOBO/bin/geyacc --doc=html -v parser_errs.txt -t OG_PATH_TOKENS -o og_path_validator.html og_path_validator.y
