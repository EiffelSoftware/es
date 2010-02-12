indexing
	description: "Summary description for {JS_NAMED_IMPLICATION_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_NAMED_IMPLICATION_NODE

inherit
	JS_NAMED_FORMULA_NODE

create
	make

feature

	make (n: STRING; a: JS_ASSERTION_NODE; c: JS_ASSERTION_NODE)
		do
			name := n
			antecedent := a
			consequent := c
		end

	name: STRING

	antecedent: JS_ASSERTION_NODE

	consequent: JS_ASSERTION_NODE

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_named_implication (Current)
		end

end
