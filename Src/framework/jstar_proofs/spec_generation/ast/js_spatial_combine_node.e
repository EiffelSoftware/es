indexing
	description: "Summary description for {JS_SPATIAL_COMBINE_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_SPATIAL_COMBINE_NODE

inherit
	JS_SPATIAL_NODE

create
	make

feature

	make (c: JS_COMBINE_NODE)
		do
			combine_content := c
		end

	combine_content: JS_COMBINE_NODE

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_spatial_combine (Current)
		end
		
end
