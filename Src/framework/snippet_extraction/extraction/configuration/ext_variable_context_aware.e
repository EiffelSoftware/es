note
	description: "Deferred implementation for classes that work with {EXT_VARIABLE_CONTEXT}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXT_VARIABLE_CONTEXT_AWARE

feature -- Configuration

	variable_context: EXT_VARIABLE_CONTEXT
		assign set_variable_context
			-- Contextual information about relevant variables.

	set_variable_context (a_context: EXT_VARIABLE_CONTEXT)
			-- Sets `variable_context' to `a_context'	
		require
			attached a_context
		do
			variable_context := a_context
		end

end
