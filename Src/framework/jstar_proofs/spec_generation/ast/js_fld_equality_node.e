indexing
	description: "Summary description for {JS_FLD_EQUALITY_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_FLD_EQUALITY_NODE

inherit
	JS_SPEC_NODE

create
	make

feature

	make (l: STRING; r: JS_ARGUMENT_NODE)
		do
			fld := l
			value := r
		end

	fld: STRING

	value: JS_ARGUMENT_NODE

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_fld_equality (Current)
		end

end
