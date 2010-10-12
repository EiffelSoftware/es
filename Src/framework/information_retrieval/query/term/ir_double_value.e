note
	description: "A double value"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IR_DOUBLE_VALUE

inherit
	IR_VALUE
		redefine
			item,
			is_double_value,
			is_equal
		end

	DOUBLE_MATH
		undefine
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (a_item: DOUBLE)
			-- Initialize `item' with `a_item'
		do
			item_cache := a_item
			type := ir_double_value_type
		ensure
			item_set: item = a_item
		end

feature -- Access

	item: DOUBLE
			-- Value wrapped in Current
		do
			Result := item_cache
		end

	hash_code: INTEGER
			-- Hash code value
		do
			Result := floor (item).hash_code
		end

	text: STRING
			-- Text representation of Current
		do
			Result := item.out
		end

feature -- Status report

	is_double_value: BOOLEAN = True
			-- Is current a double value?

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result := item = other.item
		end

feature -- Process

	process (a_visitor: IR_TERM_VALUE_VISITOR)
			-- Process Current with `a_visitor'.
		do
			a_visitor.process_double_term_value (Current)
		end

feature{NONE} -- Implementation

	item_cache: DOUBLE
			-- Cache for `item'

end
