note
	description: "Class representing a keyword token"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_KEYWORD_TOKEN

inherit
	EXT_TOKEN

create
	make

feature{NONE} -- Initialization

	make (a_keyword: STRING)
			-- Initialize Current.
		do
			keyword := a_keyword.twin
		end

feature -- Access

	keyword: STRING
			-- Keyword inside current token

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := keyword.twin
		end

end
