indexing
	description: "Summary description for {JS_SOOT_EXPRESSION_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

-- Important: Every expression must be computed into a single variable or literal!

class
	JS_JIMPLE_EXPRESSION_GENERATOR

inherit
	JS_VISITOR
		redefine
			process_agent_call_b,
			process_attribute_b,
			process_argument_b,
			process_array_const_b,
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
			process_bin_xor_b,
			process_bit_const_b,
			process_bool_const_b,
			process_char_const_b,
			process_constant_b,
			process_current_b,
			process_creation_expr_b,
			process_external_b,
			process_feature_b,
			process_int_val_b,
			process_int64_val_b,
			process_integer_constant,
			process_local_b,
			process_nat64_val_b,
			process_nat_val_b,
			process_nested_b,
			process_object_test_b,
			process_object_test_local_b,
			process_paran_b,
			process_parameter_b,
			process_result_b,
			process_routine_creation_b,
			process_string_b,
			process_un_free_b,
			process_un_minus_b,
			process_un_not_b,
			process_un_old_b,
			process_void_b
		end

	SHARED_BYTE_CONTEXT
		export {NONE} all end

create
	make

feature

	make (ig: JS_JIMPLE_INSTRUCTION_GENERATOR)
		do
			instruction_generator := ig
			expression := ""
			create side_effect.make
			create {LINKED_LIST [TUPLE [name: STRING; type: STRING]]} temporaries.make
			reset_target
		end

	reset
			-- NB: Does not reset the temp number!
		do
			expression := ""
			side_effect.reset
			temporaries.wipe_out
			reset_target
		end

	reset_expression_and_target_and_new_side_effect
		do
			create side_effect.make
			reset_target
			expression := ""
		end

	reset_temporary_number
		do
			current_temporary_number := 0
		end

feature -- Processing

	process_agent_call_b (a_node: AGENT_CALL_B)
			-- Process `a_node'.
		do
			unsupported ("Agent calls")
		end

	process_attribute_b (a_node: ATTRIBUTE_B)
			-- Process `a_node'.
		local
			temporary: STRING
		do
			check a_node /= Void end

			create_new_temporary
			temporary := last_temporary
			temporaries.extend ([temporary, type_string (a_node.type.actual_type)])

			side_effect.put_line (temporary + " = " + target + "." + attribute_designator (a_node) + ";")
			expression := temporary
			target := expression
		end

	process_argument_b (a_node: ARGUMENT_B)
		do
			check a_node /= Void end
			expression := name_for_argument (a_node)
			target := expression
		end

	process_array_const_b (a_node: ARRAY_CONST_B)
		do
			unsupported ("Array constants")
		end

	process_bin_and_b (a_node: BIN_AND_B)
		do
			process_built_in_binary_b (a_node, "&")
		end

	process_bin_and_then_b (a_node: B_AND_THEN_B)
		do
			process_built_in_binary_b (a_node, "&")
		end

	process_bin_div_b (a_node: BIN_DIV_B)
		do
			if a_node.is_built_in then
				process_built_in_binary_b (a_node, "/")
			else
--				process_binary_infix (a_node)
			end
		end

	process_bin_eq_b (a_node: BIN_EQ_B)
			-- Process `a_node'.
		do
			process_built_in_binary_b (a_node, "==")
		end

	process_bin_free_b (a_node: BIN_FREE_B)
			-- Process `a_node'.
		do
--			process_binary_infix (a_node)
		end

	process_bin_ge_b (a_node: BIN_GE_B)
			-- Process `a_node'.
		do
			if a_node.is_built_in then
				process_built_in_binary_b (a_node, ">=")
			else
--				process_binary_infix (a_node)
			end
		end

	process_bin_gt_b (a_node: BIN_GT_B)
			-- Process `a_node'.
		do
			if a_node.is_built_in then
				process_built_in_binary_b (a_node, ">")
			else
--				process_binary_infix (a_node)
			end
		end

	process_bin_implies_b (a_node: B_IMPLIES_B)
			-- Process `a_node'.
		do
			unsupported ("Implies expression")
		end

	process_bin_le_b (a_node: BIN_LE_B)
			-- Process `a_node'.
		do
			if a_node.is_built_in then
				process_built_in_binary_b (a_node, "<=")
			else
--				process_binary_infix (a_node)
			end
		end

	process_bin_lt_b (a_node: BIN_LT_B)
			-- Process `a_node'.
		do
			if a_node.is_built_in then
				process_built_in_binary_b (a_node, "<")
			else
--				process_binary_infix (a_node)
			end
		end

	process_bin_minus_b (a_node: BIN_MINUS_B)
			-- Process `a_node'.
		do
			if a_node.is_built_in then
				process_built_in_binary_b (a_node, "-")
			else
--				process_binary_infix (a_node)
			end
		end

	process_bin_mod_b (a_node: BIN_MOD_B)
			-- Process `a_node'.
		do
			process_built_in_binary_b (a_node, "%%")
		end

	process_bin_ne_b (a_node: BIN_NE_B)
			-- Process `a_node'.
		do
			process_built_in_binary_b (a_node, "!=")
		end

	process_bin_or_b (a_node: BIN_OR_B)
			-- Process `a_node'.
		do
			process_built_in_binary_b (a_node, "|")
		end

	process_bin_or_else_b (a_node: B_OR_ELSE_B)
			-- Process `a_node'.
		do
			process_built_in_binary_b (a_node, "|")
		end

	process_bin_plus_b (a_node: BIN_PLUS_B)
			-- Process `a_node'.
		do
			if a_node.is_built_in then
				process_built_in_binary_b (a_node, "+")
			else
--				process_binary_infix (a_node)
			end
		end

	process_bin_power_b (a_node: BIN_POWER_B)
			-- Process `a_node'.
		do
			unsupported ("Exponentiation")
		end

	process_bin_slash_b (a_node: BIN_SLASH_B)
			-- Process `a_node'.
		do
			if a_node.is_built_in then
				process_built_in_binary_b (a_node, "/")
			else
--				process_binary_infix (a_node)
			end
		end

	process_bin_star_b (a_node: BIN_STAR_B)
			-- Process `a_node'.
		do
			if a_node.is_built_in then
				process_built_in_binary_b (a_node, "*")
			else
--				process_binary_infix (a_node)
			end
		end

	process_bin_xor_b (a_node: BIN_XOR_B)
			-- Process `a_node'.
		do
			process_built_in_binary_b (a_node, "!=")
		end

	process_bit_const_b (a_node: BIT_CONST_B)
			-- Process `a_node'.
		do
			unsupported ("Array constants")
		end

	process_bool_const_b (a_node: BOOL_CONST_B)
			-- Process `a_node'.
		do
			if a_node.value then
				expression := "1"
			else
				expression := "0"
			end
			target := expression
		end

	process_char_const_b (a_node: CHAR_CONST_B)
			-- Process `a_node'.
		do
			expression := a_node.value.out
			target := expression
		end

	process_constant_b (a_node: CONSTANT_B)
			-- Process `a_node'.
		do
			if a_node.value.is_boolean then
				expression := a_node.value.string_value.as_lower
			else
				expression := a_node.value.string_value
			end
			target := expression
		end

	process_current_b (a_node: CURRENT_B)
		do
			expression := name_for_current
			target := expression
		end

	process_creation_expr_b (a_node: CREATION_EXPR_B)
		local
			l_type: TYPE_A
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
			temporary: STRING
			arguments: STRING
		do
			l_class := a_node.type.associated_class
			l_feature := l_class.feature_of_feature_id (a_node.call.feature_id)
			check l_feature /= Void end
			l_attached_feature := l_feature
			l_type := l_class.actual_type

			-- Process the arguments
			process_parameter_list (a_node.call.parameters)
			arguments := expression

			create_new_temporary
			temporary := last_temporary
			temporaries.extend ([temporary, type_string (l_type.actual_type)])

			side_effect.put_line (temporary + " = new " + l_class.name_in_upper + ";")

			side_effect.put_line ("specialinvoke " + temporary + "." + name_for_routine_in_call (True, l_attached_feature) + arguments + ";")

			expression := temporary
			target := expression
		end

	process_external_b (a_node: EXTERNAL_B)
		do
			unsupported ("External calls")
		end

	process_feature_b (a_node: FEATURE_B)
			-- Process `a_node'.
		local
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
			feat_target: STRING
			arguments: STRING
			temporary: STRING
			call_type: STRING
			l_is_creation_routine: BOOLEAN
		do
			l_feature := system.class_of_id (a_node.written_in).feature_of_body_index(a_node.body_index)
--			l_feature := system.class_of_id (a_node.written_in).feature_of_feature_id (a_node.feature_id)
			check l_feature /= Void end
			l_attached_feature := l_feature

			if l_attached_feature.is_attribute then
				create_new_temporary
				temporary := last_temporary
				temporaries.extend ([temporary, type_string (l_attached_feature.type)])

				side_effect.put_line (temporary + " = " + target + "." + attr_designator (l_attached_feature) + ";")
				expression := temporary
			else
				feat_target := target

				-- Process the arguments
				process_parameter_list (a_node.parameters)
				arguments := expression

				if a_node.precursor_type /= Void then
					call_type := "specialinvoke"
						-- This is a bit hacky.
					if l_attached_feature.feature_name.is_equal("init") then
						l_is_creation_routine := True
							-- Swallow the right attributes
						swallow_ancestor_attributes (a_node.precursor_type.associated_class)
					end
				else
					call_type := "virtualinvoke"
				end

				if l_attached_feature.has_return_value then
					create_new_temporary
					temporary := last_temporary
					temporaries.extend ([temporary, type_string (l_attached_feature.type)])

					side_effect.put_line (temporary + " = " + call_type + " " + feat_target + "." + name_for_routine_in_call (l_is_creation_routine, l_attached_feature) + arguments + ";")

					expression := temporary
				else
					side_effect.put_line (call_type + " " + feat_target + "." + name_for_routine_in_call (l_is_creation_routine, l_attached_feature) + arguments + ";")

					expression := "Nothing!!!"
				end
			end

			-- This deals with generics.
			if not equal (a_node.type.name, l_attached_feature.type.name) then
				create_new_temporary
				temporary := last_temporary
				temporaries.extend ([temporary, type_string (a_node.type)])

				side_effect.put_line (temporary + " = (" + type_string (a_node.type) + ") " + expression + ";")
			end

			target := expression
		end

	swallow_ancestor_attributes (a_class: CLASS_C)
		local
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
			pointstos: STRING
		do
			pointstos := ""
			from
				a_class.feature_table.start
			until
				a_class.feature_table.after
			loop
				l_feature := a_class.feature_table.item_for_iteration
				check l_feature /= Void end
				l_attached_feature := l_feature

					-- Only write attributes
				if l_attached_feature.is_attribute then
					if not equal ("", pointstos) then
						pointstos := pointstos + " * "
					end
					pointstos := pointstos + "Current." + attr_designator (l_attached_feature) + " |-> _"
				end

				a_class.feature_table.forth
			end
			side_effect.put_line ("{} : {" + pointstos + "} {};")
		end

	process_int_val_b (a_node: INT_VAL_B)
			-- Process `a_node'.
		do
			expression := a_node.value.out
			target := expression
		end

	process_int64_val_b (a_node: INT64_VAL_B)
			-- Process `a_node'.
		do
			expression := a_node.value.out
			target := expression
		end

	process_integer_constant (a_node: INTEGER_CONSTANT)
			-- Process `a_node'.
		do
			expression := a_node.integer_64_value.out
			target := expression
		end

	process_local_b (a_node: LOCAL_B)
			-- Process `a_node'.
		do
			check a_node /= Void end
			expression := name_for_local (a_node)
			target := expression
		end

	process_nat64_val_b (a_node: NAT64_VAL_B)
			-- Process `a_node'.
		do
			expression := a_node.value.out
			target := expression
		end

	process_nat_val_b (a_node: NAT_VAL_B)
			-- Process `a_node'.
		do
			expression := a_node.value.out
			target := expression
		end

	process_nested_b (a_node: NESTED_B)
		do
			-- The same as in JS_VISITOR.
			safe_process (a_node.target)
			safe_process (a_node.message)
		end

	process_object_test_b (a_node: OBJECT_TEST_B)
			-- Process `a_node'.
		do
				-- TODO: implement
			unsupported ("Object test")
		end

	process_object_test_local_b (a_node: OBJECT_TEST_LOCAL_B)
			-- Process `a_node'.
		do
				-- TODO: implement
			unsupported ("Object test local")
		end

	process_paran_b (a_node: PARAN_B)
			-- Process `a_node'.
		do
			-- Same as in JS_VISITOR
			safe_process (a_node.expr)
		end

	process_parameter_b (a_node: PARAMETER_B)
			-- Process `a_node'.
		do
			-- Same as in JS_VISITOR
			safe_process (a_node.expression)
		end

	process_result_b (a_node: RESULT_B)
			-- Process `a_node'.
		do
			expression := name_for_result
			target := expression
		end

	process_routine_creation_b (a_node: ROUTINE_CREATION_B)
		do
			unsupported ("Agent creation")
		end

	process_string_b (a_node: STRING_B)
			-- Process `a_node'.
		do
			unsupported ("Strings")
		end

	process_un_free_b (a_node: UN_FREE_B)
			-- Process `a_node'.
		do
			-- TODO: implement
			unsupported ("UN_FREE_B")
		end

	process_un_minus_b (a_node: UN_MINUS_B)
			-- Process `a_node'.
		local
			inner_expression: STRING
			temporary: STRING
		do
			safe_process (a_node.expr)

			inner_expression := expression

			create_new_temporary
			temporary := last_temporary
			temporaries.extend ([temporary, type_string (a_node.type)])

			side_effect.put_line (temporary + " = neg " + inner_expression + ";")

			expression := temporary
			target := temporary
		end

	process_un_not_b (a_node: UN_NOT_B)
			-- Process `a_node'.
		local
			false_label: STRING
			end_label: STRING
			inner_expression: STRING
			temporary: STRING
		do
			instruction_generator.create_new_label ("false")
			false_label := instruction_generator.last_label
			instruction_generator.create_new_label ("end")
			end_label := instruction_generator.last_label

			safe_process (a_node.expr)
			inner_expression := expression

			create_new_temporary
			temporary := last_temporary
			temporaries.extend ([temporary, "int"])

			side_effect.put_line ("if " + inner_expression + " == 1 goto " + false_label + ";")
			side_effect.put_line (temporary.twin + " = 1;")
			side_effect.put_line ("goto " + end_label + ";")

			side_effect.put_line (false_label + ":")
			side_effect.put_line (temporary.twin + " = 0;")

			side_effect.put_line (end_label + ":")

			expression := temporary
			target := temporary
		end

	process_un_old_b (a_node: UN_OLD_B)
			-- Process `a_node'.
		do
			unsupported ("Old expressions")
		end

	process_void_b (a_node: VOID_B)
			-- Process `a_node'.
		do
			expression := name_for_void
			target := expression
		end

feature {NONE} -- Helpers

feature -- Queries

	expression_string: STRING
		do
			Result := expression
		end

	side_effect_string: STRING
		do
			Result := side_effect.string
		end

	temporaries: LINKED_LIST [TUPLE [name: STRING; type: STRING]]

	side_effect: !JS_OUTPUT_BUFFER

feature {NONE} -- Implementation

	expression: STRING
			-- The single variable or literal denoting the result of the expression.

	target: STRING
			-- The target (a variable or literal) of attribute lookups or routine calls.

	reset_target
		do
			target := name_for_current
		end

	process_built_in_binary_b (a_node: BINARY_B; operator: STRING)
		local
			temporary: STRING
			l_exp_left, l_exp_right: STRING
		do
			check a_node /= Void end

			reset_target
			safe_process (a_node.left)
			l_exp_left := expression

			reset_target
			safe_process (a_node.right)
			l_exp_right := expression

			create_new_temporary
			temporary := last_temporary
			temporaries.extend ([temporary, type_string (a_node.type)])
			side_effect.put_line (temporary + " = " + l_exp_left + " " + operator + " " + l_exp_right + ";")
			expression := temporary
			target := expression
		end

	process_parameter_list (a_param_list: BYTE_LIST [PARAMETER_B])
		local
			i: INTEGER
			output: STRING
		do
			output := "("
			if a_param_list /= Void then
				from
					a_param_list.start
					i := 1
				until
					a_param_list.off
				loop
					if i /= 1 then
						output := output + ", "
					end

					reset_target
					safe_process (a_param_list.item)
					output := output + expression

					a_param_list.forth
					i := i + 1
				end
			end
			output := output + ")"

			expression := output
			target := "Nothing!!!"
		end

	name_for_routine_in_call (as_creation_procedure: BOOLEAN; a_feature: FEATURE_I): STRING
		do
			Result := "<"

			Result := Result + type_string (a_feature.written_class.actual_type)

			Result := Result + ": "

			Result := Result + routine_signature (as_creation_procedure, a_feature)

			Result := Result + ">"
		end

feature {NONE}

	instruction_generator: JS_JIMPLE_INSTRUCTION_GENERATOR

feature {NONE} -- Numbering of temporaries

	current_temporary_number: INTEGER
			-- Current temporary number

feature {JS_JIMPLE_GENERATOR}

	create_new_temporary
			-- Create a new temporary name.
		do
			current_temporary_number := current_temporary_number + 1
			last_temporary := "t" + current_temporary_number.out
		end

	last_temporary: STRING
			-- Last created temporary

end
