indexing
	description: "Summary description for {JS_VARIABLE_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_VARIABLE_NODE

inherit
	JS_SPEC_NODE

create
	make

feature

	make (n: STRING)
		do
			name := n
		end

	name: STRING

	set_name (s: STRING)
		do
			name := s
		end

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_variable (Current)
		end
		
end
