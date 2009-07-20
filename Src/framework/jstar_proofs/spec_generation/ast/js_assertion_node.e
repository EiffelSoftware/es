indexing
	description: "Summary description for {JS_ASSERTION_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_ASSERTION_NODE

inherit
	JS_SPEC_NODE

create
	make

feature

	make (p: LINKED_LIST [JS_PURE_NODE]; s: LINKED_LIST [JS_SPATIAL_NODE])
		do
			pure_list := p
			spatial_list := s
		end

	pure_list: LINKED_LIST [JS_PURE_NODE]

	spatial_list: LINKED_LIST [JS_SPATIAL_NODE]

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_assertion (Current)
		end

end
