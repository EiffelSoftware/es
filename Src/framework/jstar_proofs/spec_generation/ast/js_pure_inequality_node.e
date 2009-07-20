indexing
	description: "Summary description for {JS_PURE_INEQUALITY_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_PURE_INEQUALITY_NODE

inherit
	JS_PURE_NODE

create
	make
	
feature

	make (a1: JS_ARGUMENT_NODE; a2: JS_ARGUMENT_NODE)
		do
			left_argument := a1
			right_argument := a2
		end

	left_argument: JS_ARGUMENT_NODE

	right_argument: JS_ARGUMENT_NODE

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_pure_inequality (Current)
		end

end
