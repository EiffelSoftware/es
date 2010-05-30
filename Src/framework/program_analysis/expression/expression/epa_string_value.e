note
	description: "Summary description for {EPA_STRING_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_STRING_VALUE

inherit
	EPA_ANY_VALUE
		rename
			make as old_make
		redefine
			text, out
		end

create
	make

feature{NONE} -- Initialization

	make (a_address: STRING; a_str: STRING)
		-- Initialize Current.
		do
			old_make (a_address)
			string_value := a_str.twin
		end

feature -- Access

	string_value: STRING
			-- String value

	text, out: STRING
			-- New string containing terse printable representation
			-- of current object
		do
			Result := string_value
		end

end
