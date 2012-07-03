note
	description: "Represents a part of the object graph that should be set to NULL in the database."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_NULL_REFERENCE_PART

inherit
	PS_SIMPLE_PART
		redefine
			storable_tuple
		end

create default_make

feature {PS_EIFFELSTORE_EXPORT} -- Status report

	is_representing_object:BOOLEAN = False
		-- Is `Current' representing an existing object?

	storable_tuple (optional_primary: INTEGER): PS_PAIR[STRING, STRING]
		-- The storable tuple of the current object.
		require else
			nothing: True
		do
			create Result.make ("0", "NONE")
		end
end
