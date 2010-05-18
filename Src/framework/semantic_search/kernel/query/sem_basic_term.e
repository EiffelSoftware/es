note
	description: "Class that represents a term consisting a field name and a string value"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_BASIC_TERM

inherit
	SEM_TERM
create
	make

feature {NONE} -- Initialization

	make (a_field_name: like field_name; a_value: like value; a_context: like context)
			-- Initialize `field_name' with `a_field_name' and `value' with `a_value'.
			-- Make a copy of `a_field_name' and `a_value'.
		do
			context := a_context
			field_name := a_field_name.twin
			value := a_value.twin
		end

feature -- Access

	field_name: STRING
			-- Field name of current term

	value: STRING
			-- Value of current term

end
