note
	description: "A class that represents an unspecified value, used as wildcard *"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IR_ANY_VALUE

inherit
	IR_VALUE
		redefine
			is_any_value
		end

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			text := once "*"
			hash_code := text.hash_code
		end

feature -- Access

	item: ANY
			-- Value wrapped in Current
		do
		end

	text: STRING
			-- Text representation of Current

	hash_code: INTEGER
			-- Hash code value

feature -- Status report

	is_any_value: BOOLEAN = True
			-- Is current an unspecified value?

feature -- Process

	process (a_visitor: IR_TERM_VALUE_VISITOR)
			-- Process Current with `a_visitor'.
		do
			a_visitor.process_any_term_value (Current)
		end

end
