note
	description: "Represent a general collection of basic types. Descendants represent an actual collection like LIST or SPECIAL"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_BASIC_COLLECTION_WRITE [COLLECTION_TYPE -> ITERABLE[ANY]]

inherit
	PS_ABSTRACT_COLLECTION_OPERATION

create make

feature

	values:LINKED_LIST[ANY]
		-- The referenced objects of basic type

	is_of_basic_type:BOOLEAN = True

	dependencies:LINKED_LIST[PS_ABSTRACT_DB_OPERATION]

feature { NONE }

	create_other_attributes
		do
			create values.make
			create dependencies.make
		end


end
