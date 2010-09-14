note
	description: "Loads a semantic document into a SEM_QUERYABLE"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_DOCUMENT_LOADER2 [G -> SEM_QUERYABLE]

inherit
	SEM_FIELD_NAMES

	SEM_UTILITY

	SHARED_WORKBENCH

feature -- Access

	input: detachable IO_MEDIUM
			-- Input medium from which `load' reads		

	last_queryable: detachable G
			-- Last queryable read from `load'

feature -- Setting

	set_input (a_input: like input)
			-- Set `input' with `a_input'.
		do
			input := a_input
		ensure
			input_set: input = a_input
		end

feature -- Basic operations

	load
			-- Load document from `input', make result
			-- available in `last_queryable'.
		require
			input_attached: input /= Void
			input_read_to_read: input.is_open_read
		deferred
		end

end
