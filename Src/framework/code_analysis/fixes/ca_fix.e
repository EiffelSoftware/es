note
	description: "Summary description for {CA_FIX}."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_FIX

inherit
	AST_ROUNDTRIP_ITERATOR

	CA_SHARED_NAMES

	SHARED_SERVER

	INTERNAL_COMPILER_STRING_EXPORTER

create
	make

feature {NONE} -- Implementation
	make (a_caption: STRING_32; a_class: CLASS_C)
		do
			caption := a_caption
			class_to_change := a_class
		end

	matchlist: LEAF_AS_LIST
		do
			Result := Match_list_server.item (class_to_change.class_id)
		end

feature -- Properties

	caption: STRING_32

	class_to_change: CLASS_C

end
