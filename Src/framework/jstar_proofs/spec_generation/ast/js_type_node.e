indexing
	description: "Summary description for {JS_TYPE_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_TYPE_NODE

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

	set_name (n: STRING)
		do
			name := n
		end

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_type (Current)
		end
		
end
