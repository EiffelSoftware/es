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
			process_real_const_b,
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

	across_handler_map: HASH_TABLE [E2B_ACROSS_HANDLER, INTEGER]
			-- Mapping of object test locals from across loops to across handlers.

feature -- Element change

	set_last_expression (a_expression: IV_EXPRESSION)
			-- Set `last_expression' to `a_expression'.
		do
			last_expression := a_expression
		end

feature -- Basic operations

	set_context (a_feature: FEATURE_I; a_type: TYPE_A)
			-- Set context of expression to `a_feature' in type `a_type'.
		require
--			a_feature_attached: attached a_feature
			a_type_attached: attached a_type
		do
			context_feature := a_feature
			context_type := a_type
			current_target_type := a_type
			current_target := entity_mapping.current_entity
			if a_feature /= Void and then a_feature.has_return_value then
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
			create across_handler_map.make (10)
			create safety_check_condition.make
			create parameters_stack.make
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

				-- TODO: REFACTOR
			if l_left.type.is_set then
				check l_right.type.is_set end
				last_expression := factory.function_call ("Set#Equal", << l_left, l_right >>, l_type)
			else
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
			if a_node.type.is_real_32 or a_node.type.is_real_64 then
				process_binary (a_node, "/")
			elseif a_node.is_built_in then
				process_binary (a_node, "div")
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
			process_binary (a_node, "mod")
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
			if a_node.is_built_in then
				process_binary (a_node, "**")
			else
				process_binary_infix (a_node)
			end
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
			l_handler: E2B_CUSTOM_CALL_HANDLER
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
				l_handler := translation_mapping.handler_for_call (current_target_type, l_feature)
				if l_handler /= Void then
					process_special_routine_call (l_handler, l_feature, a_node.parameters)
				else
					process_routine_call (l_feature, a_node.parameters)
				end
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
			l_assign: ASSIGN_B
			l_object_test_local: OBJECT_TEST_LOCAL_B
			l_nested: NESTED_B
			l_access: ACCESS_EXPR_B
			l_bin_free: BIN_FREE_B
			l_name: STRING
			l_across_handler: E2B_ACROSS_HANDLER
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
				create {E2B_ARRAY_ACROSS_HANDLER} l_across_handler.make (Current, a_node, l_nested.target, l_object_test_local)
			elseif l_name ~ "INTEGER_INTERVAL" then
				l_bin_free ?= l_access.expr
				check l_bin_free /= Void end
				create {E2B_INTERVAL_ACROSS_HANDLER} l_across_handler.make (Current, a_node, l_bin_free, l_object_test_local)
			else
				last_expression := dummy_node (a_node.type)
			end

			if attached l_across_handler then
				across_handler_map.put (l_across_handler, l_object_test_local.position)
				l_across_handler.handle_across_expression (a_node)
				across_handler_map.remove (l_object_test_local.position)
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
			l_across_handler: E2B_ACROSS_HANDLER
			l_feature: FEATURE_B
			l_call: IV_FUNCTION_CALL
			l_info: IV_ASSERTION_INFORMATION
			l_handler: E2B_CUSTOM_NESTED_HANDLER
		do
			l_handler := translation_mapping.handler_for_nested (a_node)
			l_object_test_local ?= a_node.target
			if l_object_test_local /= Void and then across_handler_map.has (l_object_test_local.position) then
					-- Special mapping of object test local in across loop
				l_across_handler := across_handler_map.item (l_object_test_local.position)
				l_feature ?= a_node.message
				if l_feature.feature_name.is_case_insensitive_equal ("item") then
					l_across_handler.handle_call_item (Void)
				elseif l_feature.feature_name.is_case_insensitive_equal ("index") or l_feature.feature_name.is_case_insensitive_equal ("cursor_index") then
					l_across_handler.handle_call_cursor_index (Void)
				elseif l_feature.feature_name.is_case_insensitive_equal ("after") then
					l_across_handler.handle_call_after (Void)
				else
					last_expression := dummy_node (a_node.type)
				end
			elseif l_handler /= Void then
				if attached {E2B_BODY_EXPRESSION_TRANSLATOR} Current as t then
					l_handler.handle_nested_in_body (t, a_node)
				elseif attached {E2B_CONTRACT_EXPRESSION_TRANSLATOR} Current as t then
					l_handler.handle_nested_in_contract (t, a_node)
				else
					check False end
				end
				if last_expression = Void then
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
				if not current_target_type.is_expanded then
					translation_pool.add_type (current_target_type)
					create l_call.make ("attached", types.bool)
					l_call.add_argument (entity_mapping.heap)
					l_call.add_argument (current_target)
					l_call.add_argument (create {IV_VALUE}.make (name_translator.boogie_name_for_type (current_target_type), types.type))
					add_safety_check (l_call, "attached")
				end

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
					-- Normalize integer types
				if a_node.info.type_to_create.is_integer or a_node.info.type_to_create.is_natural then
					l_type_check := factory.sub_type (factory.type_of (l_expr), create {IV_ENTITY}.make ("INTEGER", types.type))
				else
					l_type_check := factory.sub_type (factory.type_of (l_expr), factory.type_value (a_node.info.type_to_create))
				end
				last_expression := factory.and_ (factory.not_equal (l_expr, factory.void_), l_type_check)
			end
			if attached a_node.target then
					-- Check for possible unboxing of basic types
				if a_node.expression.type.is_reference then
					if a_node.target.type.is_boolean then
						l_expr := factory.function_call ("unboxed_bool", << l_expr >>, types.bool)
					elseif a_node.target.type.is_integer or a_node.target.type.is_natural then
						l_expr := factory.function_call ("unboxed_int", << l_expr >>, types.int)
					end
				end
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
			l_target: IV_EXPRESSION
			l_target_type: TYPE_A
			l_last_expression: IV_EXPRESSION
		do
			check not parameters_stack.is_empty end

				-- Process arguments in context of feature
			l_target := current_target
			l_target_type := current_target_type
			l_last_expression := last_expression

			current_target := entity_mapping.current_entity
			current_target_type := context_type
			last_expression := Void

			safe_process (a_node.expression)
			parameters_stack.item.extend (last_expression)

			last_expression := l_last_expression
			current_target := l_target
			current_target_type := l_target_type
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

	process_real_const_b (a_node: REAL_CONST_B)
			-- <Precursor>
		do
			create {IV_VALUE} last_expression.make (a_node.value, types.real)
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
		local
			l_call: IV_FUNCTION_CALL
		do
			create l_call.make ("$TUPLE.item", types.generic_type)
			l_call.add_argument (entity_mapping.heap)
			l_call.add_argument (current_target)
			l_call.add_argument (create {IV_VALUE}.make (a_node.position.out, types.int))
			last_expression := l_call
		end

	process_tuple_const_b (a_node: TUPLE_CONST_B)
			-- <Precursor>
		do
			-- body: create tuple ref
			-- loop through `expressions' and put elements
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

	process_special_routine_call (a_handler: E2B_CUSTOM_CALL_HANDLER; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- Process feature call with custom handler.
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

	process_parameters (a_parameters: BYTE_LIST [PARAMETER_B])
			-- Process parameter list `a_parameters'.
		local
			l_list: LINKED_LIST [IV_EXPRESSION]
		do
			create l_list.make
			parameters_stack.extend (l_list)
			safe_process (a_parameters)
			last_parameters := parameters_stack.item
			parameters_stack.remove
		end

feature {E2B_ACROSS_HANDLER, E2B_CUSTOM_CALL_HANDLER, E2B_CUSTOM_NESTED_HANDLER} -- Implementation

	parameters_stack: LINKED_STACK [LINKED_LIST [IV_EXPRESSION]]
			-- Stack of procedure calls.

	last_parameters: LINKED_LIST [IV_EXPRESSION]
			-- List of last processed parameters.

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

end
