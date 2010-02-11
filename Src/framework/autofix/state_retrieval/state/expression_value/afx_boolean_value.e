note
	description: "Summary description for {AFX_BOOLEAN_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOLEAN_VALUE

inherit
	AFX_EXPRESSION_VALUE
		redefine
			is_boolean
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

feature -- Status report

	is_boolean: BOOLEAN is True
			-- Is current a boolean value?

feature{NONE} -- Implementation

	item_cache: BOOLEAN
			-- Cache for `item'

feature -- Process

	process (a_visitor: AFX_EXPRESSION_VALUE_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_boolean_value (Current)
		end

end
