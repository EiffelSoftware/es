#!/bin/sh 
#	component:   "openEHR Reusable Libraries"
#	description: "Units Parser builder script"
#	keywords:    "units, parser"
#
#	author:      "Thomas Beale <thomas@deepthought.com.au>"
#	copyright:   "Copyright (c) 2005 Ocean Informatics"
#	licence:     "The Mozilla Tri-license"
#
#	file:        "$URL: http://www.openehr.org/svn/ref_impl_eiffel/TRUNK/libraries/common_libs/src/unit_parser/parser/make_parser.sh $"
#	revision:    "$LastChangedRevision$"
#	last_change: "$LastChangedDate$"
#

$GOBO/bin/geyacc --new_typing -v parser_errs.txt -t UNITS_TOKENS -o units_parser.e units_parser.y

$GOBO/bin/geyacc --doc=html -v parser_errs.txt -t UNITS_TOKENS -o units_parser.html units_parser.y
