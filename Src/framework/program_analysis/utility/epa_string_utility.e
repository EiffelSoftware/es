note
	description: "Various helper functions to generate strings"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_STRING_UTILITY

feature -- Access

	curly_brace_surrounded_integer (i: INTEGER): STRING
			-- An interger surrounded by curly braces
			-- For example {0}.
		do
			create Result.make_from_string (i.out)
			Result.prepend_character ('{')
			Result.append_character ('}')
		end

end
