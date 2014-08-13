note
	description: "Enum type for code block types."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_ENUM_BLOCK_TYPE

inherit

	AT_ENUM
		redefine
			name
		end

feature -- Access

	name: STRING = "block_type"

	value_type: AT_BLOCK_TYPE
			-- The value type of this enum. For typing only.
		do
			check
				callable: False
			end
		end

	value (a_value_name: STRING): like value_type
			-- The value with name `a_value_name'.
		do
			create Result.make_with_value_name (a_value_name)
		end

	value_from_number (a_numerical_value: INTEGER): like value_type
			-- The value with numerical value `a_numerical_value'.
		do
			create Result.make_with_numerical_value (a_numerical_value)
		end

feature {AT_ENUM} -- Value list

	value_list: ARRAY [TUPLE [numerical_value: INTEGER; name: STRING]]
		once ("PROCESS")
			Result := <<	[1, at_strings.bt_feature],
							[2, at_strings.bt_arguments],
							[3, at_strings.bt_precondition],
							[4, at_strings.bt_locals],
							[5, at_strings.bt_routine_body],
							[6, at_strings.bt_postcondition],
							[7, at_strings.bt_class_invariant],
							[8, at_strings.bt_assertion],
							[9, at_strings.bt_instruction],
							[10, at_strings.bt_if],
							[11, at_strings.bt_if_condition],
							[12, at_strings.bt_if_branch]				>>
		end

feature -- Values

	bt_feature: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (1)
		end

	bt_arguments: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (2)
		end

	bt_precondition: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (3)
		end

	bt_locals: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (4)
		end

	bt_routine_body: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (5)
		end

	bt_postcondition: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (6)
		end

	bt_class_invariant: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (7)
		end

	bt_assertion: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (8)
		end

	bt_instruction: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (9)
		end

	bt_if: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (10)
		end

	bt_if_condition: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (11)
		end

	bt_if_branch: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (12)
		end

feature -- Complex blocks

	complex_block_types: ARRAY [AT_BLOCK_TYPE]
		once ("PROCESS")
			Result := <<bt_feature, bt_arguments, bt_precondition, bt_locals, bt_routine_body, bt_postcondition, bt_class_invariant, bt_if, bt_if_branch>>
		end

	is_complex_block_type (a_block_type: AT_BLOCK_TYPE): BOOLEAN
		do
			Result := complex_block_types.has (a_block_type)
		end

feature {NONE} -- Implementation

	at_strings: AT_STRINGS
		once ("PROCESS")
			create Result
		end

end
