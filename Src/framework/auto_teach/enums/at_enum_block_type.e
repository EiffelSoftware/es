note
	description: "Enum type for code block types."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_ENUM_BLOCK_TYPE

inherit

	AT_ENUM [AT_BLOCK_TYPE]
		redefine
			name
		end

feature -- Access

	name: STRING = "block_type"
			-- <Precursor>

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

feature {AT_ENUM} -- Value list

	value_list: ARRAY [TUPLE [numerical_value: INTEGER; value_name: STRING]]
			-- Effective list of values.
		once ("PROCESS")
			Result := <<	[1, at_strings.Bt_feature],
							[2, at_strings.Bt_arguments],
							[3, at_strings.Bt_argument_declaration],			-- Atomic
							[4, at_strings.Bt_precondition],
							[5, at_strings.Bt_locals],
							[6, at_strings.Bt_local_declaration],				-- Atomic
							[7, at_strings.Bt_routine_body],
							[8, at_strings.Bt_postcondition],
							[9, at_strings.Bt_class_invariant],
							[10, at_strings.Bt_assertion],						-- Atomic
							[11, at_strings.Bt_instruction],					-- Atomic
							[12, at_strings.Bt_if],
							[13, at_strings.Bt_if_condition],					-- Atomic
							[14, at_strings.Bt_if_branch],
							[15, at_strings.Bt_inspect],
							[16, at_strings.Bt_inspect_branch],
							[17, at_strings.Bt_loop],
							[18, at_strings.Bt_loop_initialization],
							[19, at_strings.Bt_loop_invariant],
							[20, at_strings.Bt_loop_termination],
							[21, at_strings.Bt_loop_termination_expression],	-- Atomic
							[22, at_strings.Bt_loop_body],
							[23, at_strings.Bt_loop_variant],
							[24, at_strings.Bt_loop_variant_expression]	>>		-- Atomic
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

	Bt_argument_declaration: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (3)
		end

	Bt_precondition: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (4)
		end

	Bt_locals: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (5)
		end

	Bt_local_declaration: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (6)
		end

	Bt_routine_body: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (7)
		end

	Bt_postcondition: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (8)
		end

	Bt_class_invariant: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (9)
		end

	Bt_assertion: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (10)
		end

	Bt_instruction: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (11)
		end

	Bt_if: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (12)
		end

	Bt_if_condition: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (13)
		end

	Bt_if_branch: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (14)
		end

	Bt_inspect: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (15)
		end

	Bt_inspect_branch: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (16)
		end

	Bt_loop: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (17)
		end

	Bt_loop_initialization: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (18)
		end

	Bt_loop_invariant: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (19)
		end

	Bt_loop_termination: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (20)
		end

	Bt_loop_termination_expression: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (21)
		end

	Bt_loop_body: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (22)
		end

	Bt_loop_variant: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (23)
		end

	Bt_loop_variant_expression: AT_BLOCK_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (24)
		end

feature -- Complex blocks

	complex_block_types: ARRAY [AT_BLOCK_TYPE]
			-- The list of complex block types.
		once ("PROCESS")
			Result := <<Bt_feature, Bt_arguments, Bt_precondition, Bt_locals, Bt_routine_body, Bt_postcondition, Bt_class_invariant, Bt_if, Bt_if_branch, Bt_inspect, Bt_inspect_branch, Bt_loop, Bt_loop_initialization, Bt_loop_invariant, Bt_loop_termination, Bt_loop_body, Bt_loop_variant>>
		end

	is_complex_block_type (a_block_type: AT_BLOCK_TYPE): BOOLEAN
			-- Is `a_block_type' a complex block type?
		do
			Result := complex_block_types.has (a_block_type)
		end

	is_atomic_block_type (a_block_type: AT_BLOCK_TYPE): BOOLEAN
			-- Is `a_block_type' an atomic block type?
		do
			Result := not is_complex_block_type (a_block_type)
		end

feature {NONE} -- Implementation

	at_strings: AT_STRINGS
		once ("PROCESS")
			create Result
		end

end
