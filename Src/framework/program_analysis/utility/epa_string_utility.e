note
	description: "Various helper functions to generate strings"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_STRING_UTILITY

inherit
	EPA_TYPE_UTILITY

feature -- Access

	curly_brace_surrounded_integer (i: INTEGER): STRING
			-- An interger surrounded by curly braces
			-- For example {0}.
		do
			create Result.make (20)
			Result.append_character ('{')
			Result.append (i.out)
			Result.append_character ('}')
		end

	curly_brace_surrounded_typed_integer (i: INTEGER; a_type: TYPE_A): STRING
			-- An interger (with type) surrounded by curly braces
			-- For example {LINKED_LIST [ANY] @ 1}
		do
			create Result.make (32)
			Result.append_character ('{')
			Result.append (cleaned_type_name (a_type.name))
			Result.append (once " @ ")
			Result.append (i.out)
			Result.append_character ('}')
		end

end
