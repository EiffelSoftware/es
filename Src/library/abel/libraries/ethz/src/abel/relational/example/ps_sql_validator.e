note
	description: "Provide static validation of a generic SQL query."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_SQL_VALIDATOR

feature -- Access

	is_validated: BOOLEAN
			-- Is last validation successful?

feature -- Status report

feature -- Status setting

feature -- Basic operations

	validate (sql: STRING)
			-- validate sql statically.
		do
				-- TODO: parse SQL string
			is_validated := True
		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
