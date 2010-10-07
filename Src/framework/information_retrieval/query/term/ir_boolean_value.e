note
	description: "A boolean value"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IR_BOOLEAN_VALUE

inherit
	IR_VALUE
		redefine
			item,
			is_boolean_value,
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (a_item: BOOLEAN)
			-- Initialize `item' with `a_item'
		do
			item_cache := a_item
			type := ir_boolean_value_type
		ensure
			item_set: item = a_item
		end

feature -- Access

	item: BOOLEAN
			-- Value wrapped in Current
		do
			Result := item_cache
		end

	hash_code: INTEGER
			-- Hash code value
		do
			Result := item.hash_code
		end

	text: STRING
			-- Text representation of Current
		do
			Result := item.item.out
		end

feature -- Status report

	is_boolean_value: BOOLEAN = True
			-- Is current a boolean?

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result := item.item = other.item.item
		end

feature -- Process

	process (a_visitor: IR_TERM_VALUE_VISITOR)
			-- Process Current with `a_visitor'.
		do
			a_visitor.process_boolean_term_value (Current)
		end

feature{NONE} -- Implementation

	item_cache: BOOLEAN
			-- Cache for `item'

end
