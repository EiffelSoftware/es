note
	description: "Summary description for {AFX_VOID_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_VOID_VALUE

inherit
	AFX_EXPRESSION_VALUE
		redefine
			type,
			item
		end

create
	make

feature{NONE} -- Initialization

	make is
			-- Initialize Current.
		do
			type := none_type
			item := once "<Void>"
		end

feature -- Access

	type: TYPE_A
			-- Type of current value

	item: ANY
			-- Value item in current

end
