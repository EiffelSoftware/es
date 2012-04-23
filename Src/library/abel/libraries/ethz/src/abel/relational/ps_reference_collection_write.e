note
	description: "Represent a general collection of reference types. Descendants represent an actual collection like LIST or SPECIAL."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_REFERENCE_COLLECTION_WRITE [COLLECTION_TYPE -> ITERABLE[ANY]]

--inherit
--	PS_COLLECTION_PART [COLLECTION_TYPE]

--create make


feature

	references:LINKED_LIST [PS_OBJECT_GRAPH_PART]
		-- The referenced objects


	is_of_basic_type:BOOLEAN = False

	dependencies: LINKED_LIST[PS_OBJECT_GRAPH_PART]
		-- All the operations on which `Current' is dependent on.
		do
			create Result.make
			Result.append (references)
--			if is_in_relational_mode then
--				Result.extend (reference_owner)
--			end
		end


feature {NONE}

	create_other_attributes
	do
		create references.make
	end

end
