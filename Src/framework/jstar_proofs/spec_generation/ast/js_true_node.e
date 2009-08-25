indexing
	description: "Summary description for {JS_TRUE_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_TRUE_NODE

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
			v.process_true (Current)
		end

end
