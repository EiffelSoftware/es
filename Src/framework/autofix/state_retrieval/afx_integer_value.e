note
	description: "Summary description for {AFX_INTEGER_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_INTEGER_VALUE

inherit
	AFX_EXPRESSION_VALUE
		redefine
			is_integer
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

feature -- Status report

	is_integer: BOOLEAN is True
			-- Is current an integer value?

feature{NONE} -- Implementation

	item_cache: INTEGER
			-- Cache for `item'

end
