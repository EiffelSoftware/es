note
	description: "Loads a semantic document into a SEM_QUERYABLE"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_QUERYABLE_LOADER [G -> SEM_QUERYABLE]

inherit
	SEM_QUERYABLE_IO [G]

	SEM_FIELD_NAMES

	SEM_UTILITY

	SHARED_WORKBENCH

feature -- Access

	last_queryable: detachable G
			-- Last queryable read from `load'

feature -- Basic operations

	load
			-- Load document from `medium', make result
			-- available in `last_queryable'.
		require
			input_attached: medium /= Void
			input_read_to_read: medium.is_open_read
		deferred
		end

end
