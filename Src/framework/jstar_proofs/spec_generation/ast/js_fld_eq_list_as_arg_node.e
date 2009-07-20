indexing
	description: "Summary description for {JS_FLD_EQ_LIST_AS_ARG_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_FLD_EQ_LIST_AS_ARG_NODE

inherit
	JS_ARGUMENT_NODE

create
	make

feature

	make (l: LINKED_LIST [JS_FLD_EQUALITY_NODE])
		do
			fld_equality_list := l
		end

	fld_equality_list: LINKED_LIST [JS_FLD_EQUALITY_NODE]

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_fld_eq_list_as_arg (Current)
		end
		
end
