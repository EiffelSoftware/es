note
	description: "Daikon invariant in format of an expression"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DKN_EXPRESSION_INVARIANT

inherit
	DKN_INVARIANT
		redefine
			is_expression
		end

create
	make

feature{NONE} -- Initialization

	make (a_text: like text)
			-- Initialize Current.
		do
			text := a_text.twin
		end

feature -- Access

	text: STRING
			-- Text of current invariant

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := text
		end

	hash_code: INTEGER
			-- Hash code
		do
			Result := text.hash_code
		end

feature -- Status report

	is_expression: BOOLEAN = True
			-- Is current invariant an expression?

end
