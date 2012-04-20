# 
#	component:   "Deep Thought Reusable Libraries"
#	description: "ADL scanner builder script"
#	keywords:    "ADL, scanner"
#
#	author:      "Thomas Beale <thomas@deepthought.com.au>"
#	copyright:   "Copyright (c) 2002 Deep Thought Informatics Pty Ltd"
#	licence:     "The Eiffel Forum License, version 1"
#
#	file:        "$URL: http://www.openehr.org/svn/ref_impl_eiffel/TRUNK/components/adl_parser/src/syntax/adl/parser/make_scanner.sh $"
#	revision:    "$LastChangedRevision$"
#	last_change: "$LastChangedDate$"
#

$GOBO/bin/gelex adl_scanner.l
