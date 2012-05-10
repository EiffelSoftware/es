note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	E2B_EXPRESSION_TRANSLATOR

inherit

	E2B_VISITOR
		redefine
			process_agent_call_b,
			process_argument_b,
			process_array_const_b,
			process_attribute_b,
			process_bin_and_b,
			process_bin_and_then_b,
			process_bin_div_b,
			process_bin_eq_b,
			process_bin_free_b,
			process_bin_ge_b,
			process_bin_gt_b,
			process_bin_implies_b,
			process_bin_le_b,
			process_bin_lt_b,
			process_bin_minus_b,
			process_bin_ne_b,
			process_bin_mod_b,
			process_bin_or_b,
			process_bin_or_else_b,
			process_bin_plus_b,
			process_bin_power_b,
			process_bin_slash_b,
			process_bin_star_b,
			process_bin_tilde_b,
			process_bin_xor_b,
			process_bool_const_b,
			process_char_const_b,
			process_char_val_b,
			process_constant_b,
			process_creation_expr_b,
			process_current_b,
			process_external_b,
			process_feature_b,
			process_int64_val_b,
			process_int_val_b,
			process_integer_constant,
			process_local_b,
			process_loop_expr_b,
			process_nat64_val_b,
			process_nat_val_b,
			process_nested_b,
			process_object_test_b,
			process_object_test_local_b,
			process_parameter_b,
			process_paran_b,
			process_result_b,
			process_routine_creation_b,
			process_string_b,
			process_tuple_access_b,
			process_tuple_const_b,
			process_type_expr_b,
			process_un_free_b,
			process_un_minus_b,
			process_un_not_b,
			process_un_old_b,
			process_void_b
		end

	E2B_SHARED_CONTEXT
		export {NONE} all end

	IV_SHARED_TYPES

	IV_SHARED_FACTORY

	SHARED_BYTE_CONTEXT

	COMPILER_EXPORTER

feature {NONE} -- Initialization

	make
			-- Initialize translator.
		do
			reset
		end

feature -- Access

	entity_mapping: E2B_ENTITY_MAPPING
			-- Entity mapping used for translation.

	last_expression: IV_EXPRESSION
			-- Last generated expression.

	context_feature: FEATURE_I
			-- Context of expression.

	context_type: TYPE_A
			-- Context of expression.

	current_target: IV_EXPRESSION
			-- Current target.

	current_target_type: TYPE_A
			-- Type of current target type.

	locals_map: HASH_TABLE [IV_EXPRESSION, INTEGER]
			-- Mapping of object test locals to entities.

feature -- Basic operations

	set_context (a_feature: FEATURE_I; a_type: TYPE_A)
			-- Set context of expression to `a_feature' in type `a_type'.
		require
			a_feature_attached: attached a_feature
			a_type_attached: attached a_type
		do
			context_feature := a_feature
			context_type := a_type
			current_target_type := a_type
			current_target := entity_mapping.current_entity
			if a_feature.has_return_value then
				entity_mapping.set_default_result (a_feature.type.instantiated_in (current_target_type))
			end
		end

	copy_entity_mapping (a_entity_mapping: E2B_ENTITY_MAPPING)
			-- Set `entity_mapping' to a copy of `a_entity_mapping'.
		do
			create entity_mapping.make_copy (a_entity_mapping)
			current_target := entity_mapping.current_entity
		end

	reset
			-- Reset expression translator.
		do
			last_expression := Void
			context_feature := Void
			context_type := Void
			current_target := Void
			current_target_type := Void
			create entity_mapping.make
			create locals_map.make (10)
			create special_mapping.make (10)
			create safety_check_condition.make
			add_special_mapping_by_name (agent process_array_routine (?, ?, ?, ?), "ARRAY", "")
		end

feature -- Visitors

	process_agent_call_b (a_node: AGENT_CALL_B)
			-- <Precursor>
		do
			last_expression := dummy_node (a_node.type)
		end

	process_argument_b (a_node: ARGUMENT_B)
			-- <Precursor>
		local
			l_name: STRING
			l_type: IV_TYPE
		do
			last_expression := entity_mapping.argument (context_feature, context_type, a_node.position)
		end

	process_array_const_b (a_node: ARRAY_CONST_B)
			-- <Precursor>
		do
			last_expression := dummy_node (a_node.type)
		end

	process_attribute_b (a_node: ATTRIBUTE_B)
			-- <Precursor>
		local
			l_feature: FEATURE_I
		do
			l_feature := helper.feature_for_call_access (a_node, current_target_type)

			process_attribute_call (l_feature)
		end

	process_binary (a_node: BINARY_B; a_operator: STRING)
			-- Process binary node `a_node' with operator `a_operator'.
		local
			l_left, l_right: IV_EXPRESSION
			l_type: IV_TYPE
			l_fcall: IV_FUNCTION_CALL
			l_fname: STRING
		do
			safe_process (a_node.left)
			l_left := last_expression
			safe_process (a_node.right)
			l_right := last_expression
			l_type := types.for_type_a (a_node.type)
			create {IV_BINARY_OPERATION} last_expression.make (l_left, a_operator, l_right, l_type)

			if
				options.is_checking_overflow and then
				(a_node.left.type.is_integer or a_node.left.type.is_natural) and then
				(a_operator ~ "+" or a_operator ~ "-")
			then
					-- Arithmetic operation
				l_fname := "is_" + a_node.left.type.associated_class.name.as_lower
				create l_fcall.make (l_fname, types.bool)
				l_fcall.add_argument (last_expression)
				add_safety_check (l_fcall, "overflow")
			end
		end

	process_binary_semistrict (a_node: BINARY_B; a_operator: STRING; a_positive: BOOLEAN)
			-- Process binary node `a_node' with operator `a_operator'.
			-- If `a_positive' is set, then the left expression has to `true' to trigger
			-- evaluation of right expression, otherwise it has to be false.
		local
			l_left, l_right: IV_EXPRESSION
			l_type: IV_TYPE
			l_fcall: IV_FUNCTION_CALL
			l_fname: STRING
			l_safety_check_condition: IV_EXPRESSION
			l_not: IV_UNARY_OPERATION
		do
			safe_process (a_node.left)
			l_left := last_expression

			if a_positive then
				l_safety_check_condition := l_left
			else
				l_safety_check_condition := factory.not_ (l_left)
			end
			if not safety_check_condition.is_empty then
				l_safety_check_condition := factory.and_ (safety_check_condition.item, l_safety_check_condition)
			end
			safety_check_condition.extend (l_safety_check_condition)

			safe_process (a_node.right)
			l_right := last_expression
			l_type := types.for_type_a (a_node.type)
			create {IV_BINARY_OPERATION} last_expression.make (l_left, a_operator, l_right, l_type)

			safety_check_condition.remove
		end

	process_binary_infix (a_node: BINARY_B)
			-- Process binary infix node `a_node'.
		do
			last_expression := dummy_node (a_node.type)
		end

	process_bin_and_b (a_node: BIN_AND_B)
			-- <Precursor>
		do
			process_binary (a_node, "&&")
		end

	process_bin_and_then_b (a_node: B_AND_THEN_B)
			-- <Precursor>
		do
			process_binary_semistrict (a_node, "&&", True)
		end

	process_bin_div_b (a_node: BIN_DIV_B)
			-- <Precursor>
		do
			if a_node.is_built_in then
				process_binary (a_node, "/")
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_eq_b (a_node: BIN_EQ_B)
			-- <Precursor>
		do
			process_binary (a_node, "==")
		end

	process_bin_free_b (a_node: BIN_FREE_B)
			-- <Precursor>
		do
			process_binary_infix (a_node)
		end

	process_bin_ge_b (a_node: BIN_GE_B)
			-- <Precursor>
		do
			if a_node.is_built_in then
				process_binary (a_node, ">=")
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_gt_b (a_node: BIN_GT_B)
			-- <Precursor>
		do
			if a_node.is_built_in then
				process_binary (a_node, ">")
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_implies_b (a_node: B_IMPLIES_B)
			-- <Precursor>
		do
			process_binary_semistrict (a_node, "==>", True)
		end

	process_bin_le_b (a_node: BIN_LE_B)
			-- <Precursor>
		do
			if a_node.is_built_in then
				process_binary (a_node, "<=")
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_lt_b (a_node: BIN_LT_B)
			-- <Precursor>
		do
			if a_node.is_built_in then
				process_binary (a_node, "<")
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_minus_b (a_node: BIN_MINUS_B)
			-- <Precursor>
		do
			if a_node.is_built_in then
				process_binary (a_node, "-")
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_mod_b (a_node: BIN_MOD_B)
			-- <Precursor>
		do
			process_binary (a_node, "%%")
		end

	process_bin_ne_b (a_node: BIN_NE_B)
			-- <Precursor>
		do
			process_binary (a_node, "!=")
		end

	process_bin_or_b (a_node: BIN_OR_B)
			-- <Precursor>
		do
			process_binary (a_node, "||")
		end

	process_bin_or_else_b (a_node: B_OR_ELSE_B)
			-- <Precursor>
		do
			process_binary_semistrict (a_node, "||", False)
		end

	process_bin_plus_b (a_node: BIN_PLUS_B)
			-- <Precursor>
		do
			if a_node.is_built_in then
				process_binary (a_node, "+")
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_power_b (a_node: BIN_POWER_B)
			-- <Precursor>
		do
			last_expression := dummy_node (a_node.type)
		end

	process_bin_slash_b (a_node: BIN_SLASH_B)
			-- <Precursor>
		do
			if a_node.is_built_in then
				process_binary (a_node, "/")
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_star_b (a_node: BIN_STAR_B)
			-- <Precursor>
		do
			if a_node.is_built_in then
				process_binary (a_node, "*")
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_xor_b (a_node: BIN_XOR_B)
			-- <Precursor>
		do
			process_binary (a_node, "!=")
		end

	process_bin_tilde_b (a_node: BIN_TILDE_B)
			-- <Precursor>
		do
				-- TODO: handle "is_equal"
			process_binary (a_node, "==")
		end

	process_bool_const_b (a_node: BOOL_CONST_B)
			-- <Precursor>
		do
			if a_node.value then
				last_expression := factory.true_
			else
				last_expression := factory.false_
			end
		end

	process_current_b (a_node: CURRENT_B)
			-- <Precursor>
		local
			l_type: LIKE_CURRENT
		do
			last_expression := entity_mapping.current_entity
		end

	process_char_const_b (a_node: CHAR_CONST_B)
			-- <Precursor>
		do
			last_expression := factory.int_value (a_node.value.code)
		end

	process_char_val_b (a_node: CHAR_VAL_B)
			-- <Precursor>
		do
			last_expression := factory.int_value (a_node.value.code)
		end

	process_constant_b (a_node: CONSTANT_B)
			-- <Precursor>
		local
			l_bool: BOOL_VALUE_I
			l_char: CHAR_VALUE_I
		do
			if a_node.value.is_boolean then
				l_bool ?= a_node.value
				check l_bool /= Void end
				if l_bool.boolean_value then
					last_expression := factory.true_
				else
					last_expression := factory.false_
				end
			elseif a_node.value.is_integer or a_node.value.is_numeric then
				create {IV_VALUE} last_expression.make (a_node.value.string_value, types.int)
			elseif a_node.value.is_character then
				l_char ?= a_node.value
				check l_char /= Void end
				last_expression := factory.int_value (l_char.character_value.code)
			elseif a_node.value.is_real then
				last_expression := dummy_node (a_node.type)
			else
				last_expression := dummy_node (a_node.type)
			end
		end

	process_creation_expr_b (a_node: CREATION_EXPR_B)
			-- <Precursor>
		do
			last_expression := dummy_node (a_node.type)
		end

	process_external_b (a_node: EXTERNAL_B)
			-- <Precursor>
		local
			l_feature: FEATURE_I
		do
			l_feature := helper.feature_for_call_access (a_node, current_target_type)
			check feature_valid: l_feature /= Void end
			process_routine_call (l_feature, a_node.parameters)
		end

	process_feature_b (a_node: FEATURE_B)
			-- <Precursor>
		local
			l_feature: FEATURE_I
			l_constant: CONSTANT_I
		do
			l_feature := helper.feature_for_call_access (a_node, current_target_type)
			check feature_valid: l_feature /= Void end

			if l_feature.is_attribute then
				process_attribute_call (l_feature)
			elseif l_feature.is_constant then
				l_constant ?= l_feature
				check l_constant /= Void end
				process_constant_call (l_constant)
			elseif l_feature.is_routine then
				process_routine_call (l_feature, a_node.parameters)
			else
					-- TODO: what else is there?
				check False end
			end
		end

	process_int64_val_b (a_node: INT64_VAL_B)
			-- <Precursor>
		do
			last_expression := factory.int64_value (a_node.value)
		end

	process_int_val_b (a_node: INT_VAL_B)
			-- <Precursor>
		do
			last_expression := factory.int_value (a_node.value)
		end

	process_integer_constant (a_node: INTEGER_CONSTANT)
			-- <Precursor>
		do
			last_expression := factory.int64_value (a_node.integer_64_value)
		end

	process_local_b (a_node: LOCAL_B)
			-- <Precursor>
		local
			l_name: STRING
			l_type: IV_TYPE
		do
			last_expression := entity_mapping.local_ (a_node.position)
		end

	process_loop_expr_b (a_node: LOOP_EXPR_B)
			-- <Precursor>
		local
			b: BOOLEAN
			l_assign: ASSIGN_B
			l_nested: NESTED_B
			l_access: ACCESS_EXPR_B
			l_bin_free: BIN_FREE_B
			l_object_test_local: OBJECT_TEST_LOCAL_B
			l_name: STRING

			l_counter: IV_ENTITY
			l_lower: IV_EXPRESSION
			l_upper: IV_EXPRESSION
			l_binop1, l_binop2: IV_BINARY_OPERATION
			l_and: IV_BINARY_OPERATION
			l_implies: IV_BINARY_OPERATION
			l_quantifier: IV_QUANTIFIER
			l_expression: IV_EXPRESSION
			l_array: IV_EXPRESSION
			l_call: IV_FUNCTION_CALL
		do
			l_assign ?= a_node.iteration_code.first
			check l_assign /= Void end
			l_object_test_local ?= l_assign.target
			check l_object_test_local /= Void end
			l_nested ?= l_assign.source
			check l_nested /= Void end
			l_access ?= l_nested.target
			check l_access /= Void end

			l_name := l_nested.target.type.associated_class.name_in_upper
			if l_name ~ "ARRAY" then

					-- Array expression
				l_nested.target.process (Current)
				l_array := last_expression

					-- Loop content
				create_iterator (types.int)
				l_counter := last_local
				locals_map.put (l_counter, l_object_test_local.position)
				a_node.expression_code.process (Current)
				l_expression := last_expression
				locals_map.remove (l_object_test_local.position)

				create l_call.make ("ARRAY.$is_index", types.bool)
				l_call.add_argument (entity_mapping.heap)
				l_call.add_argument (l_array)
				l_call.add_argument (l_counter)
				create l_implies.make (l_call, "==>", l_expression, types.bool)
				if a_node.is_all then
					create {IV_FORALL} l_quantifier.make (l_implies)
				else
					create {IV_EXISTS} l_quantifier.make (l_implies)
				end
				l_quantifier.add_bound_variable (l_counter.name, l_counter.type)
				last_expression := l_quantifier

			elseif l_name ~ "INTEGER_INTERVAL" then

				l_bin_free ?= l_access.expr
				check l_bin_free /= Void end

				create_iterator (types.int)
				l_counter := last_local

				l_bin_free.left.process (Current)
				l_lower := last_expression
				l_bin_free.right.process (Current)
				l_upper := last_expression

				locals_map.put (l_counter, l_object_test_local.position)
				a_node.expression_code.process (Current)
				l_expression := last_expression
				locals_map.remove (l_object_test_local.position)

				create l_binop1.make (l_lower, "<=", l_counter, types.bool)
				create l_binop2.make (l_counter, "<=", l_upper, types.bool)
				create l_and.make (l_binop1, "&&", l_binop2, types.bool)
				create l_implies.make (l_and, "==>", l_expression, types.bool)
				if a_node.is_all then
					create {IV_FORALL} l_quantifier.make (l_implies)
				else
					create {IV_EXISTS} l_quantifier.make (l_implies)
				end
				l_quantifier.add_bound_variable (l_counter.name, l_counter.type)
				last_expression := l_quantifier
			else
				last_expression := dummy_node (a_node.type)
			end
		end

	process_nat64_val_b (a_node: NAT64_VAL_B)
			-- <Precursor>
		do
			create {IV_VALUE} last_expression.make (a_node.value.out, types.int)
		end

	process_nat_val_b (a_node: NAT_VAL_B)
			-- <Precursor>
		do
			create {IV_VALUE} last_expression.make (a_node.value.out, types.int)
		end

	process_nested_b (a_node: NESTED_B)
			-- <Precursor>
		local
			l_temp_expression: IV_EXPRESSION
			l_target: IV_EXPRESSION
			l_target_name: STRING
			l_target_type: TYPE_A
			l_formal: FORMAL_A

			l_object_test_local: OBJECT_TEST_LOCAL_B
			l_feature: FEATURE_B
			l_call: IV_FUNCTION_CALL
			l_info: IV_ASSERTION_INFORMATION
		do
			l_object_test_local ?= a_node.target
			if False and l_object_test_local /= Void and then locals_map.has (l_object_test_local.position) then
					-- Special mapping of object test local in across loop
				l_feature ?= a_node.message
				if l_feature.feature_name.is_case_insensitive_equal ("item") then

					if true then -- INTEGER INTERVAL
						last_expression := locals_map.item (l_object_test_local.position)
					else -- ARRAY
						create l_call.make ("ARRAY.item", types.generic_type)
						l_call.add_argument (entity_mapping.heap)
						l_call.add_argument (entity_mapping.current_entity)
						l_call.add_argument (locals_map.item (l_object_test_local.position))
						last_expression := l_call
					end

				elseif l_feature.feature_name.is_case_insensitive_equal ("index") then
						-- TODO: lower bound needed
					last_expression := dummy_node (a_node.type)
				else
					last_expression := dummy_node (a_node.type)
				end
			else
				l_temp_expression := last_expression

					-- Evaluate target				
				safe_process (a_node.target)

					-- Use target as new `Current' reference
				l_target := current_target
				l_target_type := current_target_type
				current_target := last_expression
				if a_node.target.type.is_like_current then
					current_target_type := l_target_type
				else
					current_target_type := a_node.target.type.deep_actual_type
				end
				check not current_target_type.is_like end
				if current_target_type.is_formal then
					l_formal ?= current_target_type
					current_target_type := l_target_type.associated_class.constraint (l_formal.position)
				end

					-- Check if target is attached
				translation_pool.add_type (current_target_type)
				create l_call.make ("attached", types.bool)
				l_call.add_argument (entity_mapping.heap)
				l_call.add_argument (current_target)
				l_call.add_argument (create {IV_VALUE}.make (name_translator.boogie_name_for_type (current_target_type), types.type))
				add_safety_check (l_call, "attached")

					-- Evaluate message with original expression
--				if attached {CL_TYPE_A} current_target_type as l_cl_type then
--					if not l_cl_type.has_associated_class_type (Void) then
--						l_cl_type.associated_class.update_types (l_cl_type)
--					end
--					context.change_class_type_context (
--						l_cl_type.associated_class_type (Void),
--						l_cl_type,
--						l_cl_type.associated_class_type (Void),
--						l_cl_type)
--				end

				helper.set_up_byte_context (Void, current_target_type)
--				helper.set_up_byte_context_type (current_target_type, context_type)
				last_expression := l_temp_expression
				safe_process (a_node.message)

					-- Restore `Current' reference
--				if attached {CL_TYPE_A} current_target_type as l_cl_type then
--					if context.is_class_type_changed then
--						context.restore_class_type_context
--					else
--						-- TODO: should never happen, but does
--					end
--				end
				current_target := l_target
				current_target_type := l_target_type
				helper.set_up_byte_context (Void, current_target_type)
--				helper.set_up_byte_context_type (current_target_type, context_type)
			end
		end

	process_object_test_b (a_node: OBJECT_TEST_B)
			-- <Precursor>
		local
			l_type_check: IV_BINARY_OPERATION
			l_expr: IV_EXPRESSION
		do
			safe_process (a_node.expression)
			l_expr := last_expression
			if a_node.is_void_check then
				last_expression := factory.not_equal (l_expr, factory.void_)
			else
				check attached a_node.info end
				l_type_check := factory.sub_type (factory.type_of (l_expr), factory.type_value (a_node.info.type_to_create))
				last_expression := factory.and_ (factory.not_equal (l_expr, factory.void_), l_type_check)
			end
			if attached a_node.target then
				locals_map.force (l_expr, a_node.target.position)
			end
		end

	process_object_test_local_b (a_node: OBJECT_TEST_LOCAL_B)
			-- <Precursor>
		do
			if locals_map.has_key (a_node.position) then
				last_expression := locals_map.item (a_node.position)
			else
				check False end
				last_expression := dummy_node (a_node.type)
			end
		end

	process_parameter_b (a_node: PARAMETER_B)
			-- <Precursor>
		local
			l_context_type: CL_TYPE_A
		do
			l_context_type := context.context_cl_type
			helper.set_up_byte_context (Void, context_type)
			safe_process (a_node.expression)
			helper.set_up_byte_context (Void, l_context_type)
		end

	process_paran_b (a_node: PARAN_B)
			-- <Precursor>
		do
			safe_process (a_node.expr)
		end

	process_result_b (a_node: RESULT_B)
			-- <Precursor>
		local
			l_name: STRING
			l_type: IV_TYPE
		do
			last_expression := entity_mapping.result_expression
		end

	process_routine_creation_b (a_node: ROUTINE_CREATION_B)
			-- <Precursor>
		do
			last_expression := dummy_node (a_node.type)
		end

	process_string_b (a_node: STRING_B)
			-- <Precursor>
		do
			last_expression := dummy_node (a_node.type)
		end

	process_tuple_access_b (a_node: TUPLE_ACCESS_B)
			-- <Precursor>
		do
			last_expression := dummy_node (a_node.type)
		end

	process_tuple_const_b (a_node: TUPLE_CONST_B)
			-- <Precursor>
		do
			last_expression := dummy_node (a_node.type)
		end

	process_type_expr_b (a_node: TYPE_EXPR_B)
			-- <Precursor>
		local
			l_type: TYPE_A
		do
			l_type := a_node.type_type.deep_actual_type
			translation_pool.add_type (l_type)
			last_expression := factory.type_value (l_type)
		end

	process_un_free_b (a_node: UN_FREE_B)
			-- <Precursor>
		do
			-- TODO: implement
		end

	process_un_minus_b (a_node: UN_MINUS_B)
			-- <Precursor>
		do
			safe_process (a_node.expr)
			create {IV_UNARY_OPERATION} last_expression.make ("-", last_expression, types.for_type_a (a_node.type))
		end

	process_un_not_b (a_node: UN_NOT_B)
			-- <Precursor>
		do
			safe_process (a_node.expr)
			create {IV_UNARY_OPERATION} last_expression.make ("!", last_expression, types.for_type_a (a_node.type))
		end

	process_un_old_b (a_node: UN_OLD_B)
			-- <Precursor>
		do
			check False end
			last_expression := dummy_node (a_node.type)
		end

	process_void_b (a_node: VOID_B)
			-- <Precursor>
		do
			last_expression := factory.void_
		end

feature -- Translation

	process_attribute_call (a_feature: FEATURE_I)
			-- Process call to attribute `a_feature'.
		require
			is_attribute: a_feature.is_attribute
		local
			l_current: IV_ENTITY
			l_field: IV_ENTITY
			l_heap_access: IV_HEAP_ACCESS
		do
			translation_pool.add_referenced_feature (a_feature, current_target_type)

			check current_target /= Void end
			create l_field.make (
				name_translator.boogie_name_for_feature (a_feature, current_target_type),
				types.field (types.for_type_in_context (a_feature.type, current_target_type))
			)
			create l_heap_access.make (entity_mapping.heap.name, current_target, l_field)
			last_expression := l_heap_access
		end

	process_constant_call (a_feature: CONSTANT_I)
			-- Process call to constant `a_feature'.
		do
			if a_feature.value.is_string then
				last_expression := dummy_node (a_feature.type)
			elseif a_feature.value.is_boolean then
				create {IV_VALUE} last_expression.make (a_feature.value.string_value.as_lower, types.bool)
			elseif a_feature.value.is_integer then
				create {IV_VALUE} last_expression.make (a_feature.value.string_value, types.int)
			elseif a_feature.value.is_character then
				last_expression := dummy_node (a_feature.type)
			else
				last_expression := dummy_node (a_feature.type)
			end
		end

	process_routine_call (a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- Process feature call.
		require
			not_attribute: a_feature.is_routine
		deferred
		end

	add_safety_check (a_expression: IV_EXPRESSION; a_name: STRING)
			-- Add safety check `a_expression' of type `a_name'.
		require
			boolean_expression: a_expression.type.is_boolean
		deferred
		end

	safety_check_condition: LINKED_STACK [IV_EXPRESSION]
			-- Stack of safety check conditions.

	implies_safety_expression (a_expr: IV_EXPRESSION): IV_EXPRESSION
		do
			if safety_check_condition.is_empty then
				Result := a_expr
			else
				create {IV_BINARY_OPERATION} Result.make (safety_check_condition.item, "==>", a_expr, types.bool)
			end
		end

feature -- Special mapping

	special_mapping: HASH_TABLE [PROCEDURE [ANY, TUPLE], TUPLE [STRING, STRING]]
			-- Special mapping for translating certain feature calls.

	add_special_mapping (a_agent: PROCEDURE [ANY, TUPLE []]; a_type: TYPE_A; a_feature: FEATURE_I)
			-- Add special mapping for translating feature `a_feature' of type `a_type'.
		local
			l_tuple: TUPLE [STRING, STRING]
		do
			if attached a_feature then
				l_tuple := [a_type.associated_class.name_in_upper, a_feature.feature_name.as_lower]
			else
				l_tuple := [a_type.associated_class.name_in_upper, ""]
			end
			l_tuple.compare_objects
			special_mapping.extend (a_agent, l_tuple)
		end

	add_special_mapping_by_name (a_agent: PROCEDURE [ANY, TUPLE []]; a_type: STRING; a_feature: STRING)
			-- Add special mapping for translating feature `a_feature' of type `a_type'.
		local
			l_tuple: TUPLE [STRING, STRING]
		do
			l_tuple := [a_type, a_feature]
			l_tuple.compare_objects
			special_mapping.extend (a_agent, l_tuple)
		end

	has_special_mapping (a_feature: FEATURE_I; a_type: TYPE_A): BOOLEAN
			-- Does a special mapping exist for feature `a_feature' of type `a_type'?
		local
			l_tuple: TUPLE [STRING, STRING]
		do
			l_tuple := [a_type.associated_class.name_in_upper, a_feature.feature_name.as_lower]
			l_tuple.compare_objects
			Result := special_mapping.has_key (l_tuple)
			if not Result then
				l_tuple := [a_type.associated_class.name_in_upper, ""]
				l_tuple.compare_objects
				Result := special_mapping.has_key (l_tuple)
			end
		end

	process_special_mapping_call (a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- Process feature call with special mapping.
		require
			has_special_mapping: has_special_mapping (a_feature, current_target_type)
		local
			l_tuple: TUPLE [STRING, STRING]
			l_agent: PROCEDURE [ANY, TUPLE]
		do
			l_tuple := [current_target_type.associated_class.name_in_upper, a_feature.feature_name.as_lower]
			l_tuple.compare_objects
			l_agent := special_mapping.item (l_tuple)
			if l_agent = Void then
				l_tuple := [current_target_type.associated_class.name_in_upper, ""]
				l_tuple.compare_objects
				l_agent := special_mapping.item (l_tuple)
			end
			check l_agent /= Void end
			l_agent.call ([Current, current_target_type, a_feature, a_parameters])
		end

feature {NONE} -- Implementation

	last_local: IV_ENTITY
			-- Last created local.

	create_iterator (a_type: IV_TYPE)
			-- Create new unbound iterator.
		local
			l_name: STRING
		do
			create last_local.make (helper.unique_identifier ("i"), a_type)
		end

	dummy_node (a_type: TYPE_A): IV_EXPRESSION
			-- Dummy node for type `a_type'.
		local
			l_type: TYPE_A
		do
			l_type := a_type.deep_actual_type
			if l_type.is_integer or l_type.is_natural or l_type.is_character or l_type.is_character_32 then
				create {IV_VALUE} Result.make ("0", types.int)
			elseif l_type.is_boolean then
				create {IV_VALUE} Result.make ("false", types.bool)
			elseif l_type.is_expanded then
				create {IV_VALUE} Result.make ("Unknown", types.generic_type)
			else
				create {IV_VALUE} Result.make ("Void", types.ref)
			end
		end

feature {NONE} -- Special mapping: ARRAY

	process_array_routine (a_translator: E2B_EXPRESSION_TRANSLATOR; a_type: TYPE_A; a_feature: FEATURE_I; a_params: BYTE_LIST [PARAMETER_B])
			-- Processing for array routines.
		local
			l_name: STRING
		do
			l_name := a_feature.feature_name
			if l_name ~ "make" then

			elseif l_name ~ "put" then

			elseif l_name ~ "item" then

			elseif l_name ~ "count" then

			elseif l_name ~ "is_empty" then

			end
		end

end
