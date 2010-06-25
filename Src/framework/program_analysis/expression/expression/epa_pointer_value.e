note
	description: "Class that represents a pointer value"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_POINTER_VALUE

inherit
	EPA_EXPRESSION_VALUE
		redefine
			is_pointer,
			as_pointer
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
			Result := real_64_type
		end

	item: STRING
			-- Value item in current
		do
			Result := item_cache
		end

	as_pointer: detachable EPA_POINTER_VALUE
			-- Current as pointer
		do
			Result := Current
		end

feature -- Status report

	is_pointer: BOOLEAN = True
			-- Is current a pointer value?

feature -- Process

	process (a_visitor: EPA_EXPRESSION_VALUE_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_pointer_value (Current)
		end

feature{NONE} -- Implementation

	item_cache: STRING
			-- Cache for `item'

end
