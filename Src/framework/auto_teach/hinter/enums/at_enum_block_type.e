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
			Result := <<	[1, at_strings.Bt_feature],
							[2, at_strings.Bt_arguments],
							[3, at_strings.Bt_precondition],
							[4, at_strings.Bt_locals],
							[5, at_strings.Bt_routine_body],
							[6, at_strings.Bt_postcondition],
							[7, at_strings.Bt_class_invariant],
							[8, at_strings.Bt_assertion],
							[9, at_strings.Bt_instruction],
							[10, at_strings.Bt_if],
							[11, at_strings.Bt_if_condition],
							[12, at_strings.Bt_if_branch]				>>
		end

feature -- Values

	Bt_feature: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (1)
		end

	Bt_arguments: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (2)
		end

	Bt_precondition: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (3)
		end

	Bt_locals: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (4)
		end

	Bt_routine_body: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (5)
		end

	Bt_postcondition: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (6)
		end

	Bt_class_invariant: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (7)
		end

	Bt_assertion: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (8)
		end

	Bt_instruction: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (9)
		end

	Bt_if: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (10)
		end

	Bt_if_condition: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (11)
		end

	Bt_if_branch: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (12)
		end

feature -- Complex blocks

	complex_block_types: ARRAY [AT_BLOCK_TYPE]
			-- The list of complex block types.
		once ("PROCESS")
			Result := <<Bt_feature, Bt_arguments, Bt_precondition, Bt_locals, Bt_routine_body, Bt_postcondition, Bt_class_invariant, Bt_if, Bt_if_branch>>
		end

	is_complex_block_type (a_block_type: AT_BLOCK_TYPE): BOOLEAN
			-- Is `a_block_type' a complex block type?
		do
			Result := complex_block_types.has (a_block_type)
		end

	is_simple_block_type (a_block_type: AT_BLOCK_TYPE): BOOLEAN
			-- Is `a_block_type' a simple block type?
		do
			Result := not is_complex_block_type (a_block_type)
		end

feature -- Hybrid blocks

		-- Hybrid blocks are blocks that can be threated both as complex and as simple blocks,
		-- depending on the user choice. The default is always to treat them as complex blocks,
		-- currently there is no plan to enable the user to modify this default behaviour.

	hybrid_block_types: ARRAY [AT_BLOCK_TYPE]
			-- The list of hybrid block types.
		once ("PROCESS")
			Result := <<Bt_if>>
		ensure
			subset_of_complex_blocks:
				across Result as ic all complex_block_types.has (ic.item) end
		end

	is_hybrid_block_type (a_block_type: AT_BLOCK_TYPE): BOOLEAN
			-- Is `a_block_type' a hybrid block type?
		do
			Result := hybrid_block_types.has (a_block_type)
		end

	corresponding_simple_block_type (a_hybrid_block_type: AT_BLOCK_TYPE): AT_BLOCK_TYPE
			-- What is the simple block type corresponding to `a_hybrid_block_type'?
			-- (that is, if we have to process a block of type `a_hybrid_block_type',
			-- to what simple type should we consider it to belong?
		require
			hybrid_block_type: is_hybrid_block_type (a_hybrid_block_type)
		do
			if a_hybrid_block_type = Bt_if then
				Result := Bt_instruction
			else
				check found: False end
			end
		ensure
			simple_block_type: not is_complex_block_type (Result)
		end

feature {NONE} -- Implementation

	at_strings: AT_STRINGS
		once ("PROCESS")
			create Result
		end

end
