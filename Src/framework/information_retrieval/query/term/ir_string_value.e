note
	description: "A string value"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IR_STRING_VALUE

inherit
	IR_VALUE
		redefine
			item,
			is_string_value,
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (a_item: like item)
			-- Initialize `item' with `a_item'
		do
			item := a_item.twin
			type := ir_string_value_type
		ensure
			item_set: item ~ a_item
		end

feature -- Access

	item: STRING
			-- Value wrapped in Current

	hash_code: INTEGER
			-- Hash code value
		do
			Result := item.hash_code
		end

	text: STRING
			-- Text representation of Current
		do
			Result := item.twin
		end

feature -- Status report

	is_string_value: BOOLEAN = True
			-- Is current a string?

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result := item ~ other.item
		end

feature -- Process

	process (a_visitor: IR_TERM_VALUE_VISITOR)
			-- Process Current with `a_visitor'.
		do
			a_visitor.process_string_term_value (Current)
		end

end
