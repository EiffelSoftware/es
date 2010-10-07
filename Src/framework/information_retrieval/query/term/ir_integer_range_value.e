note
	description: "A value representing an integer range"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IR_INTEGER_RANGE_VALUE

inherit
	IR_VALUE
		redefine
			item,
			is_integer_range,
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (a_lower: INTEGER; a_upper: INTEGER)
			-- Initialize Current.
		do
			create item.make (a_lower, a_upper)
			type := ir_integer_range_value_type
		end

feature -- Access

	item: INTEGER_INTERVAL
			-- Value wrapped in Current

	hash_code: INTEGER
			-- Hash code value
		do
			Result := item.lower + item.upper
		end

	text: STRING
			-- Text representation of Current
		do
			create Result.make (32)
			Result.append_character ('[')
			Result.append (item.lower.out)
			Result.append_character (',')
			Result.append_character (' ')
			Result.append (item.upper.out)
			Result.append_character (']')
		end

feature -- Status report

	is_integer_range: BOOLEAN = True
			-- Is current an integer range?

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
			a_visitor.process_integer_range_term_value (Current)
		end

end
