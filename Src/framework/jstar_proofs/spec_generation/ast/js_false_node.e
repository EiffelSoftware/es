indexing
	description: "Summary description for {JS_FALSE_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_FALSE_NODE

inherit
	JS_ASSERTION_NODE

create
	make

feature

	make
		do
		end

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_false (Current)
		end

end
