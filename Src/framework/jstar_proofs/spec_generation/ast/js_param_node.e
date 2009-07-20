indexing
	description: "Summary description for {JS_PARAM_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_PARAM_NODE

inherit
	JS_SPEC_NODE

create
	make

feature

	make (n: STRING; v: JS_VARIABLE_NODE)
		do
			name := n
			variable := v
		end

	name: STRING

	variable: JS_VARIABLE_NODE

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_param (Current)
		end
		
end
