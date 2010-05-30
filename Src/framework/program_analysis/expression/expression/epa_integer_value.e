note
	description: "Class that represents an integer value"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_INTEGER_VALUE

inherit
	EPA_EXPRESSION_VALUE
		redefine
			is_integer,
			as_integer
		end

create
	make

feature{NONE} -- Initialization

	make (a_item: like item)
			-- Initialize `item' with `a_item'.
		do
			item_cache := a_item
		ensure
			item_set: item = item_cache
		end

feature -- Access

	type: TYPE_A
			-- Type of current value
		do
			Result := integer_type
		end

	item: INTEGER
			-- Value item in current
		do
			Result := item_cache
		end

	as_integer: detachable EPA_INTEGER_VALUE
			-- Current as integer
		do
			Result := Current
		end

feature -- Status report

	is_integer: BOOLEAN is True
			-- Is current an integer value?

feature -- Process

	process (a_visitor: EPA_EXPRESSION_VALUE_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_integer_value (Current)
		end

feature{NONE} -- Implementation

	item_cache: INTEGER
			-- Cache for `item'

end
