note
	description: "Summary description for {AT_ENUM_BLOCK_TYPE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AT_ENUM_BLOCK_TYPE

inherit

	AT_ENUM

feature -- Values

	values: ARRAY [TUPLE [numerical_value: INTEGER; name: STRING]] -- For some reason, "like tuple_type" is not allowed
		once
			Result := <<	[1, at_strings.bt_feature],
							[2, at_strings.bt_arguments],
							[3, at_strings.bt_precondition],
							[4, at_strings.bt_locals],
							[5, at_strings.bt_routine_body],
							[6, at_strings.bt_postcondition],
							[7, at_strings.bt_class_invariant]		>>
		end

	bt_feature: AT_BLOCK_TYPE
		once
			create Result.make_with_value_name (at_strings.bt_feature)
		end

	bt_arguments: AT_BLOCK_TYPE
		once
			create Result.make_with_value_name (at_strings.bt_arguments)
		end

	bt_precondition: AT_BLOCK_TYPE
		once
			create Result.make_with_value_name (at_strings.bt_precondition)
		end

	bt_locals: AT_BLOCK_TYPE
		once
			create Result.make_with_value_name (at_strings.bt_locals)
		end

	bt_routine_body: AT_BLOCK_TYPE
		once
			create Result.make_with_value_name (at_strings.bt_routine_body)
		end

	bt_postcondition: AT_BLOCK_TYPE
		once
			create Result.make_with_value_name (at_strings.bt_postcondition)
		end

	bt_class_invariant: AT_BLOCK_TYPE
		once
			create Result.make_with_value_name (at_strings.bt_class_invariant)
		end

	value (a_value_name: STRING): AT_BLOCK_TYPE
			-- The value with name `a_value_name'.
		do
			create Result.make_with_value_name (a_value_name)
		end

	value_from_number (a_numerical_value: INTEGER): AT_BLOCK_TYPE
			-- The value with numerical value `a_numerical_value'.
		do
			create Result.make_with_numerical_value (a_numerical_value)
		end

feature {NONE} -- Implementation

	at_strings: AT_STRINGS
		once
			create Result
		end

end
