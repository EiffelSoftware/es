indexing
	description: "Summary description for {JS_FUNCTION_TERM_AS_ARG_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_FUNCTION_TERM_AS_ARG_NODE

inherit
	JS_ARGUMENT_NODE

create
	make

feature

	make (n: STRING; a: LINKED_LIST [JS_ARGUMENT_NODE])
		do
			function_name := n
			argument_list := a
		end

	function_name: STRING

	argument_list: LINKED_LIST [JS_ARGUMENT_NODE]

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_function_term_as_arg (Current)
		end
		
end
