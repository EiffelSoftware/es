indexing
	description: "Summary description for {JS_FIELD_SIG_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_FIELD_SIG_NODE

inherit
	JS_SPEC_NODE

create
	make

feature

	make (c: STRING; f: STRING)
		do
			class_name := c
			field := f
		end

	class_name: STRING

	field: STRING

	type: STRING

	set_type (t: STRING)
		do
			type := t
		end

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_field_sig (Current)
		end

end
