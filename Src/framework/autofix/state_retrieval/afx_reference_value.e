note
	description: "Summary description for {AFX_REFERENCE_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_REFERENCE_VALUE

inherit
	AFX_EXPRESSION_VALUE
		redefine
			type,
			item,
			is_reference
		end

create
	make

feature{NONE} -- Initialization

	make (a_item: like item; a_type: like type)
			-- Initialize `item' with `a_item' and `type' with `a_type'.
		do
			item := a_item.twin
			type := a_type
		end

feature -- Access

	type: TYPE_A
			-- Type of current value

	item: STRING
			-- Value item in current

feature -- Status report

	is_reference: BOOLEAN is True
			-- Is current a reference value?

end
