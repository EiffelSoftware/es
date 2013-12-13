note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_AUTOPROOF_ERROR

inherit

	E2B_VERIFICATION_RESULT

feature -- Access

	type: STRING
			-- Type of error.

	single_line_message (a_formatter: TEXT_FORMATTER)
			-- Single line description of this result.
		do
			a_formatter.add (internal_message)
		end

	context_line_number: INTEGER
			-- Line number of error (if any)

	is_warning: BOOLEAN
			-- Should verification proceed if this error occurs?

feature -- Element change

	set_type (a_string: STRING)
			-- Set `type' to `a_type'.
		do
			type := a_string
		end

	set_message (a_string: STRING)
			-- Set `single_line_message' to `a_string'.
		do
			internal_message := a_string
		end

	set_line_number (a_value: INTEGER)
			-- Set `context_line_number' to `a_value'.
		do
			context_line_number := a_value
		end

	set_warning (a_flag: BOOLEAN)
			-- Set `is_warning' to `a_flag'
		do
			is_warning := a_flag
		end

feature {NONE} -- Implementation

	internal_message: STRING
			-- Message for this error.

end
