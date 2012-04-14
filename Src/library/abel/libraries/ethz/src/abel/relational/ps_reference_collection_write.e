note
	description: "Represent a general collection of reference types. Descendants represent an actual collection like LIST or SPECIAL."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_REFERENCE_COLLECTION_WRITE [COLLECTION_TYPE -> ITERABLE[ANY]]

inherit
	PS_ABSTRACT_COLLECTION_OPERATION

create make


feature

	references:LINKED_LIST [PS_ABSTRACT_DB_OPERATION]
		-- The referenced objects


	is_of_basic_type:BOOLEAN = False

	dependencies: LIST[PS_ABSTRACT_DB_OPERATION]
		-- All the operations on which `Current' is dependent on.
		do
			Result:= references
		end


feature {NONE}

	create_other_attributes
	do
		create references.make
	end

end
