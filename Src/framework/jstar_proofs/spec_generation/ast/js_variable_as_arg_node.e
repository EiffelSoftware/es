indexing
	description: "Summary description for {JS_VARIABLE_AS_ARG_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_VARIABLE_AS_ARG_NODE

inherit
	JS_ARGUMENT_NODE

create
	make

feature

	make (v: JS_VARIABLE_NODE)
		do
			variable := v
		end

	variable: JS_VARIABLE_NODE

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_variable_as_arg (Current)
		end

end
