indexing
	description: "Summary description for {JS_STAR_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_STAR_NODE

inherit
	JS_ASSERTION_NODE

create
	make

feature

	make (l, r: JS_ASSERTION_NODE)
		do
			left_assertion := l
			right_assertion := r
		end

	left_assertion: JS_ASSERTION_NODE

	right_assertion: JS_ASSERTION_NODE

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_star (Current)
		end

end
