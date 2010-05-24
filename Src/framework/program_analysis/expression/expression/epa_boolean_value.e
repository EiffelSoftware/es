note
	description: "Summary description for {AFX_BOOLEAN_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_BOOLEAN_VALUE

inherit
	EPA_EXPRESSION_VALUE
		redefine
			is_boolean,
			as_boolean
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
			Result := boolean_type
		end

	item: BOOLEAN
			-- Value item in current
		do
			Result := item_cache
		end

	as_boolean: detachable EPA_BOOLEAN_VALUE
			-- Current as integer
		do
			Result := Current
		end

feature -- Status report

	is_boolean: BOOLEAN is True
			-- Is current a boolean value?

	is_true: BOOLEAN
			-- Is current a True value?
		do
			Result := item
		end

	is_false: BOOLEAN
			-- Is current a False value?
		do
			Result := not item
		end

feature{NONE} -- Implementation

	item_cache: BOOLEAN
			-- Cache for `item'

feature -- Process

	process (a_visitor: EPA_EXPRESSION_VALUE_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_boolean_value (Current)
		end

end
