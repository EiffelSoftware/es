indexing
	description: "Summary description for {JS_COMBINE_OROR_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_COMBINE_OROR_NODE

inherit
	JS_COMBINE_NODE

create
	make

feature

	make (l: JS_ASSERTION_NODE; r: JS_ASSERTION_NODE)
		do
			left_assertion := l
			right_assertion := r
		end

	left_assertion: JS_ASSERTION_NODE

	right_assertion: JS_ASSERTION_NODE

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_combine_oror (Current)
		end

end
