note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_VIOLATION

inherit

	E2B_VERIFICATION_ERROR

create
	make_with_description

feature {NONE} -- Initialization

	make_with_description (a_code, a_message, a_description: STRING)
			-- Initialize.
		do
			make (a_code, a_message)
			set_description (a_description)
		end

feature -- Access

	description: STRING
			-- Description of violation.

feature -- Element change

	set_description (a_description: STRING)
			-- Set `description' to `a_description'.
		do
			description := a_description.twin
		ensure
			description ~ a_description
		end

feature -- Display

	single_line_message (a_formatter: TEXT_FORMATTER)
			-- <Precursor>
		do
			a_formatter.add (description)
		end

end
