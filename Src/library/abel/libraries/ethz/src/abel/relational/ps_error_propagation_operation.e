note
	description: "A special operation that is only used to propagate errors during the recursive disassembly function, and to have a default value for void safety in case of an error."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_ERROR_PROPAGATION_OPERATION

inherit
	PS_ABSTRACT_DB_OPERATION

create make

feature

	dependencies:LINKED_LIST[PS_ABSTRACT_DB_OPERATION]
		once
			create Result.make
		end

	make
		do
			create object_id.make (0, dependencies)
		end

end
