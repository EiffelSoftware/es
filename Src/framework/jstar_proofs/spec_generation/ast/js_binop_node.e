indexing
	description: "Summary description for {JS_BINOP_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_BINOP_NODE

inherit
	JS_ASSERTION_NODE

create
	make

feature

	make (a1: JS_ARGUMENT_NODE; o: STRING; a2: JS_ARGUMENT_NODE)
		do
			left_argument := a1
			operator := o
			right_argument := a2
		end

	left_argument: JS_ARGUMENT_NODE

	operator: STRING

	right_argument: JS_ARGUMENT_NODE

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_binop (Current)
		end
		
end
