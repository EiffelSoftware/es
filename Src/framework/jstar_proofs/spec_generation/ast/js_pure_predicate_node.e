indexing
	description: "Summary description for {JS_PURE_PREDICATE_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_PURE_PREDICATE_NODE

inherit
	JS_ASSERTION_NODE

create
	make

feature

	make (n: STRING; a: LINKED_LIST [JS_ARGUMENT_NODE])
		do
			predicate_name := n
			argument_list := a
		end

	predicate_name: STRING

	argument_list: LINKED_LIST [JS_ARGUMENT_NODE]

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_pure_predicate (Current)
		end

end
