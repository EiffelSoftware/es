note
	description: "Deferred implementation for classes that work with {EXT_VARIABLE_CONTEXT}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXT_VARIABLE_CONTEXT_AWARE

feature {NONE} -- Implementation

	variable_context: EXT_VARIABLE_CONTEXT
			-- Contextual information about relevant variables.

end
