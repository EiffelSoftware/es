indexing
	description: "Summary description for {JS_INTEGER_AS_ARG_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_INTEGER_AS_ARG_NODE

inherit
	JS_ARGUMENT_NODE

create
	make

feature

	make (v: STRING)
		do
			value := v
		end

	value: STRING

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_integer_as_arg (Current)
		end
		
end
