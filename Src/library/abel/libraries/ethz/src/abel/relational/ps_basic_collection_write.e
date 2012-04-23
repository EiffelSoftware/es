note
	description: "Represent a general collection of basic types. Descendants represent an actual collection like LIST or SPECIAL"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_BASIC_COLLECTION_WRITE [COLLECTION_TYPE -> ITERABLE[ANY]]

inherit
--	PS_COLLECTION_PART [COLLECTION_TYPE]

--create make

feature

	values:LINKED_LIST[ANY]
		-- The referenced objects of basic type

	is_of_basic_type:BOOLEAN = True

	dependencies:LINKED_LIST[PS_OBJECT_GRAPH_PART]

feature { NONE }

	create_other_attributes
		do
			create values.make
			create dependencies.make
--			if is_in_relational_mode then
--				dependencies.extend (reference_owner)
--			end
		end


end
