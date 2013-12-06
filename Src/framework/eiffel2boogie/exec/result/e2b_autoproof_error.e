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

feature {NONE} -- Implementation

	internal_message: STRING
			-- Message for this error.

end
