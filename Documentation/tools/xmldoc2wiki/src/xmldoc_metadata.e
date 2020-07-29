indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	XMLDOC_METADATA

inherit
	XMLDOC_ITEM
		redefine
			process_visitor
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			create meta_list.make (1)
		end

feature -- Access

	meta_list: ARRAYED_LIST [XMLDOC_META]
			-- List of META

feature -- Element change

	add_meta (v: XMLDOC_META)
		do
			meta_list.extend (v)
		end

feature {XMLDOC_VISITOR} -- Visitor

	process_visitor (v: XMLDOC_VISITOR)
		do
			v.process_metadata (Current)
		end

end
