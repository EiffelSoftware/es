note
	description: "Class that represents a queryable term"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_TERM

inherit
	DEBUG_OUTPUT

	SEM_FIELD_NAMES

feature -- Access

	context: EPA_CONTEXT
			-- Context in which current term is type checked

	field_name: STRING
			-- Field name of current term
		deferred
		end

	value: STRING
			-- Value of current term
		deferred
		end

	text, debug_output: STRING
			-- Text of Current term
		do
			Result := field_name + field_name_value_separator + value
		end

end
