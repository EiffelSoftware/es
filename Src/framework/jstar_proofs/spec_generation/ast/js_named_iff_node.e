indexing
	description: "Summary description for {JS_NAMED_IFF_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_NAMED_IFF_NODE

inherit
	JS_NAMED_FORMULA_NODE

create
	make

feature

	make (n: STRING; l: JS_ASSERTION_NODE; r: JS_ASSERTION_NODE)
		do
			name := n
			left_assertion := l
			right_assertion := r
		end

	name: STRING

	left_assertion: JS_ASSERTION_NODE

	right_assertion: JS_ASSERTION_NODE

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_named_iff (Current)
		end

end
