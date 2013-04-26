note
	description : "Translate an expression to JavaScript."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	JSC_EXPRESSION_WRITER

inherit
	JSC_VISITOR
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
			process_real_const_b,
			process_result_b,
			process_routine_creation_b,
			process_string_b,
			process_tuple_const_b,
			process_un_free_b,
			process_un_minus_b,
			process_un_not_b,
			process_un_old_b,
			process_void_b
		end

	SHARED_BYTE_CONTEXT
		export {NONE} all end

	SHARED_JSC_CONTEXT
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize object.
		do
			create output.make
			create {LINKED_LIST[attached JSC_BUFFER_DATA]}output_parameters.make
			reset ("")
		end

feature -- Access

	this_used_in_closure: BOOLEAN
			-- Has an inline closure been defined and Current referred from it?

	output: attached JSC_SMART_BUFFER
			-- Generated JavaScript

	dependencies1: attached SET[INTEGER]
			-- Level 1 dependencies

	dependencies2: attached SET[INTEGER]
			-- Level 2 dependencies

	invariant_checks: attached LIST[attached JSC_BUFFER_DATA]
			-- Generated invariant checks related to the expression

feature -- Basic Operation

	reset (a_indentation: attached STRING)
			-- Reset state
		do
			output.reset (a_indentation)
			this_used_in_closure := false
			show_tuple_brackets := true
			create {LINKED_SET[INTEGER]}dependencies1.make
			create {LINKED_SET[INTEGER]}dependencies2.make
			create {LINKED_LIST[attached JSC_BUFFER_DATA]}invariant_checks.make
		end

	process_object_test (l_source: attached EXPR_B; l_target_type, l_source_type: attached TYPE_A; use_reverse: BOOLEAN): attached STRING
		local
			l_expression: JSC_BUFFER_DATA
			local_name: STRING
		do
			output.push ("")
				safe_process (l_source)
				l_expression := output.data
			output.pop

			if use_reverse then
				local_name := jsc_context.add_reverse_local
			else
				local_name := jsc_context.add_object_test_local
			end

			output.put ("(")
			output.put (local_name)
			output.put ("=")
			output.put_data (l_expression)
			output.put (")");

			if not types_are_equal(l_target_type, l_source_type, false) then
				if attached l_target_type.associated_class as safe_class
				and then jsc_context.informer.is_native_stub (safe_class.class_id) then
					output.put (" && (")
					output.put (local_name)
					output.put (" instanceof ")
					output.put (jsc_context.informer.get_native_stub (safe_class.class_id))
					output.put (")")
				else
					output.put (" && runtime.inherits(")
					output.put (local_name)
					output.put (",")
					output.put_data (process_type (l_target_type))
					output.put (")")
				end
			end

			Result := local_name
		end

feature {BYTE_NODE} -- Visitors

	process_agent_call_b (a_node: AGENT_CALL_B)
			-- Process `a_node'.
		local
			l_old_show_tuple_brackets: BOOLEAN
			l_params: attached LIST[attached JSC_BUFFER_DATA]
		do
				-- Hide tuple brackets
			l_old_show_tuple_brackets := show_tuple_brackets
			show_tuple_brackets := false
				l_params := process_parameters (a_node.parameters)
			show_tuple_brackets := l_old_show_tuple_brackets

				-- Emit agent call
			output.put_data (jsc_context.name_mapper.target_name)
			output.put ("(")
			output.put_data_list (l_params, ", ")
			output.put (")")
		end

	process_argument_b (a_node: ARGUMENT_B)
			-- Process `a_node'.
		do
			output.put (jsc_context.name_mapper.argument_name (a_node))
		end

	process_array_const_b (a_node: ARRAY_CONST_B)
			-- Process `a_node'.
		local
			l_expr: LINKED_LIST[attached JSC_BUFFER_DATA]
			expressions: BYTE_LIST [BYTE_NODE]
		do
			expressions := a_node.expressions
			check expressions /= Void end

			from
				create l_expr.make
				expressions.start
			until
				expressions.after
			loop

				output.push ("")
					safe_process (expressions.item)
					l_expr.extend (output.data)
				output.pop

				expressions.forth
			end

				-- Print array. The 1 comes from the consensus that array[0] holds the lower bound
			output.put ("[1, ")
			output.put_data_list (l_expr, ", ")
			output.put ("]")
		end

	process_attribute_b (a_node: ATTRIBUTE_B)
			-- Process `a_node'.
		do
			static_dispatch_feature_call (get_feature (a_node), a_node.parameters, a_node.precursor_type /= Void)
		end

	process_bin_and_b (a_node: BIN_AND_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			output.put (" && ")
			safe_process (a_node.right)
		end

	process_bin_and_then_b (a_node: B_AND_THEN_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			output.put (" && ")
			safe_process (a_node.right)
		end

	process_bin_div_b (a_node: BIN_DIV_B)
			-- Process `a_node'.
		do
			if a_node.is_built_in then
				output.put ("Math.floor(")
				safe_process (a_node.left)
				output.put (" / ")
				safe_process (a_node.right)
				output.put (")")
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_eq_b (a_node: BIN_EQ_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			output.put (" === ")
			safe_process (a_node.right)
		end

	process_bin_free_b (a_node: BIN_FREE_B)
			-- Process `a_node'.
		do
			process_binary_infix (a_node)
		end

	process_bin_ge_b (a_node: BIN_GE_B)
			-- Process `a_node'.
		do
			if a_node.is_built_in then
				safe_process (a_node.left)
				output.put (" >= ")
				safe_process (a_node.right)
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_gt_b (a_node: BIN_GT_B)
			-- Process `a_node'.
		do
			if a_node.is_built_in then
				safe_process (a_node.left)
				output.put (" > ")
				safe_process (a_node.right)
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_implies_b (a_node: B_IMPLIES_B)
			-- Process `a_node'.
		do
			output.put ("( !(")
				safe_process (a_node.left)
			output.put (") || (")
				safe_process (a_node.right)
			output.put (") )")
		end

	process_bin_le_b (a_node: BIN_LE_B)
			-- Process `a_node'.
		do
			if a_node.is_built_in then
				safe_process (a_node.left)
				output.put (" <= ")
				safe_process (a_node.right)
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_lt_b (a_node: BIN_LT_B)
			-- Process `a_node'.
		do
			if a_node.is_built_in then
				safe_process (a_node.left)
				output.put (" < ")
				safe_process (a_node.right)
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_minus_b (a_node: BIN_MINUS_B)
			-- Process `a_node'.
		do
			if a_node.is_built_in then
				safe_process (a_node.left)
				output.put (" - ")
				safe_process (a_node.right)
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_mod_b (a_node: BIN_MOD_B)
			-- Process `a_node'.
		do
			if a_node.is_built_in then
				safe_process (a_node.left)
				output.put (" %% ")
				safe_process (a_node.right)
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_ne_b (a_node: BIN_NE_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			output.put (" !== ")
			safe_process (a_node.right)
		end

	process_bin_or_b (a_node: BIN_OR_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			output.put (" || ")
			safe_process (a_node.right)
		end

	process_bin_or_else_b (a_node: B_OR_ELSE_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			output.put (" || ")
			safe_process (a_node.right)
		end

	process_bin_plus_b (a_node: BIN_PLUS_B)
			-- Process `a_node'.
		do
			if a_node.is_built_in then
				safe_process (a_node.left)
				output.put (" + ")
				safe_process (a_node.right)
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_power_b (a_node: BIN_POWER_B)
			-- Process `a_node'.
		do
			output.put ("Math.pow(")
			safe_process (a_node.left)
			output.put (", ")
			safe_process (a_node.right)
			output.put (")")
		end

	process_bin_slash_b (a_node: BIN_SLASH_B)
			-- Process `a_node'.
		do
			if a_node.is_built_in then
				safe_process (a_node.left)
				output.put (" / ")
				safe_process (a_node.right)
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_star_b (a_node: BIN_STAR_B)
			-- Process `a_node'.
		do
			if a_node.is_built_in then
				safe_process (a_node.left)
				output.put (" * ")
				safe_process (a_node.right)
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_xor_b (a_node: BIN_XOR_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			output.put (" ^ ")
			safe_process (a_node.right)
		end

	process_bool_const_b (a_node: BOOL_CONST_B)
			-- Process `a_node'.
		do
			if a_node.value then
				output.put ("true")
			else
				output.put ("false")
			end
		end

	process_char_const_b (a_node: CHAR_CONST_B)
			-- Process `a_node'.
		local
			l_constant_writer: JSC_CONSTANT_WRITER
		do
			create l_constant_writer.make
			output.put (l_constant_writer.process_string (a_node.value.to_character_8.out))
		end

	process_constant_b (a_node: CONSTANT_B)
			-- Process `a_node'.
		local
			l_node_value: VALUE_I
			l_constant_writer: JSC_CONSTANT_WRITER
		do
			l_node_value := a_node.value
			check l_node_value /= Void end

			create l_constant_writer.make
			output.put (l_constant_writer.process (l_node_value))
		end

	process_creation_expr_b (a_node: CREATION_EXPR_B)
			-- Process `a_node'.
		local
			l_call_access: CALL_ACCESS_B
			l_class: CLASS_C
			l_class_name: STRING
			l_feature: attached FEATURE_I
			l_feature_external_name: STRING
			l_type: TYPE_A
			l_type_name: attached STRING
		do
			l_type ?= a_node.type
			check l_type /= Void end

			l_type := l_type.actual_type
			check l_type /= Void end

			l_call_access := a_node.call
			check l_call_access /= Void end

			l_class := l_type.associated_class
			check l_class /= Void end

			l_feature := get_feature (l_call_access)
			l_feature := jsc_context.informer.redirect_feature (l_class, l_feature)
			l_class := jsc_context.informer.redirect_class (l_class)

			l_class_name := l_class.name_in_upper
			check l_class_name /= Void end
			create l_type_name.make_from_string (l_class_name)

			if not jsc_context.informer.is_fictive_stub (l_class.class_id) then
				dependencies2.put (l_class.class_id)
			end

			if l_feature.is_external then
				l_feature_external_name := l_feature.external_name
				check l_feature_external_name /= Void end

				process_external_procedure_call (true, l_feature_external_name, l_feature.arguments, l_call_access.parameters)
			else
				output.put ("new ")
				output.put (l_type_name)
				output.put ("(")

				if l_type.has_generics then
					output.put_data (process_generics(l_type))
					output.put (", ")
				end

				l_class := l_feature.written_class
				check l_class /= Void end

				l_class_name := l_class.name_in_upper
				check l_class_name /= Void end

				if l_class_name.is_equal ("ANY") = false then
					output.put ("%"")
					output.put (jsc_context.name_mapper.feature_name (l_feature, false))
					output.put ("%"")
				end

				if attached l_call_access.parameters as safe_params and then safe_params.count > 0 then
					output.put (", ")
					output.put_data_list (process_parameters(safe_params), ", ")
				end

				output.put (")")
			end
		end

	process_current_b (a_node: CURRENT_B)
			-- Process `a_node'.
		do
			output.put_data (jsc_context.name_mapper.target_name)
		end

	process_external_b (a_node: EXTERNAL_B)
			-- Process `a_node'.
		local
		do
			static_dispatch_feature_call (get_feature (a_node), a_node.parameters, a_node.precursor_type /= Void)
		end

	process_feature_b (a_node: FEATURE_B)
			-- Process `a_node'.
		do
			static_dispatch_feature_call (get_feature (a_node), a_node.parameters, a_node.precursor_type /= Void)
		end

	process_int64_val_b (a_node: INT64_VAL_B)
			-- Process `a_node'.
		do
			output.put (a_node.value.out)
		end

	process_int_val_b (a_node: INT_VAL_B)
			-- Process `a_node'.
		do
			output.put (a_node.value.out)
		end

	process_integer_constant (a_node: INTEGER_CONSTANT)
			-- Process `a_node'.
		do
			output.put (a_node.integer_64_value.out)
		end

	process_local_b (a_node: LOCAL_B)
			-- Process `a_node'.
		do
			output.put (jsc_context.name_mapper.local_name (a_node.position))
		end

	process_nat64_val_b (a_node: NAT64_VAL_B)
			-- Process `a_node'.
		do
			output.put (a_node.value.out)
		end

	process_nat_val_b (a_node: NAT_VAL_B)
			-- Process `a_node'.
		do
			output.put (a_node.value.out)
		end

	process_nested_b (a_node: NESTED_B)
			-- Process `a_node'.
		local
			l_node_target: ACCESS_B
			l_node_target_type: TYPE_A
			l_target_name: attached JSC_BUFFER_DATA
			l_class: CLASS_C
		do
			output.push ("")
				safe_process (a_node.target)
				l_target_name := output.data
			output.pop

			l_node_target := a_node.target
			check l_node_target /= Void end

			l_node_target_type := l_node_target.type
			check l_node_target_type /= Void end

			if not l_node_target_type.is_formal then
					-- TODO: shouldn't invariants be checked on formals as well?
				if l_node_target_type.is_like_current then
					l_class := jsc_context.current_class
				else
					l_class := l_node_target_type.associated_class
				end
				check l_class /= Void end

				l_class := jsc_context.informer.redirect_class (l_class)

				if not jsc_context.informer.is_fictive_stub (l_class.class_id)
					and l_class.assertion_level.is_invariant then
					invariant_checks.extend (l_target_name)
				end
			end

			jsc_context.name_mapper.push_target (l_node_target_type, l_target_name)
				safe_process (a_node.message)
			jsc_context.name_mapper.pop_target
		end

	process_object_test_b (a_node: OBJECT_TEST_B)
			-- Process `a_node'.
		local
			l_context: BYTE_CONTEXT
			l_node_target: OBJECT_TEST_LOCAL_B
			l_node_expression: EXPR_B
			l_target_type, l_source_type: TYPE_A
			local_name: STRING
		do
			l_context := context
			check l_context /= Void end

			l_node_target := a_node.target
			check l_node_target /= Void end

			l_node_expression := a_node.expression
			check l_node_expression /= Void end

			l_target_type := l_context.real_type (l_node_target.type)
			check l_target_type /= Void end

			l_source_type := l_context.real_type (l_node_expression.type)
			check l_source_type /= Void end

			local_name := process_object_test (l_node_expression, l_target_type, l_source_type, false)

		end

	process_object_test_local_b (a_node: OBJECT_TEST_LOCAL_B)
			-- Process `a_node'.
		do
			output.put (jsc_context.object_test_local_name (a_node.position))
		end

	process_paran_b (a_node: PARAN_B)
			-- Process `a_node'.
		do
			output.put ("(")
			safe_process (a_node.expr)
			output.put (")")
		end

	process_parameter_b (a_node: PARAMETER_B)
			-- Process `a_node'.
		do
				-- Gather up processed parameters in `output_parameters'.
			output.push (output.indentation)
				safe_process (a_node.expression)
				output_parameters.extend (output.data)
			output.pop
		end

	process_real_const_b (a_node: REAL_CONST_B)
			-- Process `a_node'.
		local
			l_value: STRING
		do
			l_value := a_node.value
			check l_value /= Void end

			output.put (l_value)
		end

	process_result_b (a_node: RESULT_B)
			-- Process `a_node'.
		do
			output.put (jsc_context.name_mapper.result_name)
		end

	write_inline_feature (a_feature: attached FEATURE_I)
		local
			l_body_writer: JSC_BODY_WRITER
			l_signature_writer: JSC_SIGNATURE_WRITER
		do
			create l_signature_writer.make
			create l_body_writer.make

			jsc_context.push_feature (a_feature)

				l_signature_writer.reset (output.indentation)
				l_signature_writer.write_feature_signature (a_feature)
				output.put_data (l_signature_writer.output.data)
				output.put (" {")
				output.put_new_line

				output.indent

					l_body_writer.reset (output.indentation)
					l_body_writer.write_feature_body (a_feature)
					output.put_data (l_body_writer.output.data)

				output.unindent

				output.put_indentation
				output.put ("}")

				dependencies1.fill (l_body_writer.dependencies1)
				dependencies2.fill (l_body_writer.dependencies2)

			jsc_context.pop_feature
			l_body_writer.set_proper_context (jsc_context.current_feature)
		end

	do_routine_arguments (	l_feature: attached FEATURE_I;
							omap: ARRAYED_LIST[INTEGER];
							arguments: attached TUPLE_CONST_B
							l_inner_arguments, l_outer_arguments, l_closed_evaled_arguments: attached LIST[attached STRING];
							l_closed_arguments: attached LIST[attached JSC_BUFFER_DATA]
							)
		local
			l_arguments_expressions: BYTE_LIST [BYTE_NODE]
			l_expression: BYTE_NODE
			l_open_argument_count, l_closed_argument_count: INTEGER
			i, j, k: INTEGER
			old_is_inside_agent: BOOLEAN
		do
			if attached omap as safe_omap then
				l_open_argument_count := safe_omap.count
			else
				l_open_argument_count := 0
			end

			l_arguments_expressions := arguments.expressions
			check l_arguments_expressions /= Void end

			l_closed_argument_count := l_arguments_expressions.count
			check l_feature.argument_count + 1 = l_open_argument_count + l_closed_argument_count end

			old_is_inside_agent := jsc_context.name_mapper.is_inside_agent
			jsc_context.name_mapper.is_inside_agent := true
			jsc_context.name_mapper.push_target_current

				from
					i := 1 -- Argument position
					j := 1 -- Open Argument index
					k := 1 -- Closed Argument index
				until
					i > l_feature.argument_count + 1
				loop
					if j <= l_open_argument_count
						and then attached omap as safe_omap
						and then safe_omap.i_th (j) = i then
							-- Next is an open argument
						check j <= safe_omap.count end
						if i /= 1 then
							l_outer_arguments.extend ("arg" + j.out)
							l_inner_arguments.extend ("arg" + j.out)
						end
						j := j + 1
					else
							-- Next is a closed argument
						check k <= l_arguments_expressions.count end
						if i /= 1 then
							output.push("")
								l_expression := l_arguments_expressions.i_th (k)
								check l_expression /= Void end

								l_expression.process (Current)
								l_closed_arguments.extend (output.data)
							output.pop

							l_inner_arguments.extend ("$closed" + jsc_context.feature_nesting_level.out + "_" + k.out)
							l_closed_evaled_arguments.extend ("$closed" + jsc_context.feature_nesting_level.out + "_" + k.out)
						end
						k := k + 1
					end
					i := i + 1
				end

			jsc_context.name_mapper.pop_target
			jsc_context.name_mapper.is_inside_agent := old_is_inside_agent
		end

	process_routine_creation_b (a_node: ROUTINE_CREATION_B)
			-- Process `a_node'.
		local
			l_system: SYSTEM_I
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_outer_arguments, l_inner_arguments: attached LIST[attached STRING]
			l_closed_evaled_arguments: attached LIST[attached STRING]
			l_closed_arguments: attached LIST[attached JSC_BUFFER_DATA]

			--l_evaled_inner_arguments
			l_arguments: TUPLE_CONST_B
			l_expressions: BYTE_LIST [BYTE_NODE]
			l_desired_target: attached STRING
			old_is_inside_agent: BOOLEAN
		do
			l_system := system
			check l_system /= Void end

			l_class := l_system.class_of_id (a_node.class_id)
			check l_class /= Void end

			l_feature := l_class.feature_of_feature_id (a_node.feature_id)
			check l_feature /= Void end

			if attached l_class.feature_named (l_feature.feature_name) as safe_feature then
				l_feature := safe_feature
			end

			this_used_in_closure := true

			create {LINKED_LIST[attached STRING]}l_outer_arguments.make
			create {LINKED_LIST[attached STRING]}l_inner_arguments.make
			create {LINKED_LIST[attached STRING]}l_closed_evaled_arguments.make
			create {LINKED_LIST[attached JSC_BUFFER_DATA]}l_closed_arguments.make

			l_arguments := a_node.arguments
			check l_arguments /= Void end

			do_routine_arguments (l_feature, a_node.omap, l_arguments, l_inner_arguments, l_outer_arguments, l_closed_evaled_arguments, l_closed_arguments)

			output.put ("(function (")
			output.put_list (l_closed_evaled_arguments, ", ")
			output.put (") {")
			output.put_new_line
			output.indent
				output.put_indentation
				output.put ("return ")

				if a_node.is_inline_agent then
					output.put ("function (")
					output.put_list (l_outer_arguments, ", ")
					output.put (") {")
					output.put_new_line

					output.indent
						output.put_indentation
						output.put ("return (")
						old_is_inside_agent := jsc_context.name_mapper.is_inside_agent
						jsc_context.name_mapper.is_inside_agent := true
						jsc_context.name_mapper.push_target_current
							write_inline_feature (l_feature)
						jsc_context.name_mapper.pop_target
						jsc_context.name_mapper.is_inside_agent := old_is_inside_agent

						output.put ("(")
						output.put_list (l_inner_arguments, ", ")
						output.put (")")
					output.unindent

					output.put (");")
					output.put_new_line
					output.put_line ("};")
				else
					output.put ("function (")
					output.put_list (l_outer_arguments, ", ")
					output.put (") { return ")

					output.push ("")
						l_expressions := l_arguments.expressions
						check l_expressions /= Void end

						safe_process (l_expressions[1])
						l_desired_target := output.force_string
					output.pop

					if l_desired_target.starts_with ("this") then
						l_desired_target := "$" + l_desired_target
					end

					output.put (l_desired_target)
					output.put (".")
					output.put (jsc_context.name_mapper.feature_name (l_feature, false))
					output.put ("(")
					output.put_list (l_inner_arguments, ", ")
					output.put (");")
					output.put_new_line
					output.put_line ("};")
				end
			output.unindent

				-- Just make sure we don't forget it
			this_used_in_closure := true

			output.put_indentation
			output.put ("}(")
			output.put_data_list (l_closed_arguments, ", ")
			output.put ("))")
		end

	process_string_b (a_node: STRING_B)
			-- Process `a_node'.
		local
			l_value: STRING
			l_constant_writer: JSC_CONSTANT_WRITER
		do
			l_value := a_node.value
			check l_value /= Void end

			create l_constant_writer.make
			output.put (l_constant_writer.process_string (l_value))
		end

	process_tuple_const_b (a_node: TUPLE_CONST_B)
			-- Process `a_node'.
		local
			l_expr: attached LINKED_LIST[attached JSC_BUFFER_DATA]
			expressions: BYTE_LIST [BYTE_NODE]
		do
			expressions := a_node.expressions
			check expressions /= Void end
			from
				create l_expr.make
				expressions.start
			until
				expressions.after
			loop
				output.push ("")
					safe_process (expressions.item)
					l_expr.extend (output.data)
				output.pop

				expressions.forth
			end

			if show_tuple_brackets then
				output.put ("[")
			end

			output.put_data_list (l_expr, ", ")

			if show_tuple_brackets then
				output.put ("]")
			end
		end

	process_un_free_b (a_node: UN_FREE_B)
			-- Process `a_node'.
		do
				-- TODO: raise exception
			io.put_string ("JSC_EXPRESSION_WRITER:: process_un_free_b not implemented. %N")
		end

	process_un_minus_b (a_node: UN_MINUS_B)
			-- Process `a_node'.
		do
			output.put ("( -(")
			safe_process (a_node.expr)
			output.put ("))")
		end

	process_un_not_b (a_node: UN_NOT_B)
			-- Process `a_node'.
		do
			output.put ("( !(")
			safe_process (a_node.expr)
			output.put ("))")
		end

	process_un_old_b (a_node: UN_OLD_B)
			-- Process `a_node'.
		local
			l_expr_data: attached JSC_BUFFER_DATA
		do
			output.push ("")
				safe_process(a_node.expr)
				l_expr_data := output.data
			output.pop

			jsc_context.add_old_local (l_expr_data)
			output.put (jsc_context.last_old_local)
		end

	process_void_b (a_node: VOID_B)
			-- Process `a_node'.
		do
			output.put ("null")
		end

feature {NONE} -- Base classes feature redirection



feature {NONE} -- Static dispatch

	static_dispatch_feature_call (a_feature: attached FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B]; is_precursor_call: BOOLEAN)
			-- Process feature call of feature `a_feature' with parameters `a_parameters'.
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_external_name: STRING
		do
			if jsc_context.name_mapper.target_type.is_like_current then
				l_class := jsc_context.current_class
				check l_class /= Void end

			else
				l_class := a_feature.written_class
				check l_class /= Void end

				if jsc_context.informer.is_eiffel_base_class (l_class) then
					if attached jsc_context.name_mapper.target_type.associated_class as safe_target_class
						and then jsc_context.informer.is_eiffel_base_class (safe_target_class) then
						l_class := safe_target_class
					end
				end
			end

				-- Redirect feature if needed
			l_feature := jsc_context.informer.redirect_feature (l_class, a_feature)

			if jsc_context.informer.is_ancestor_of_native_type (l_class.class_id) then
					-- This class is a parent of a native type => must do special dispatching
				dynamic_dispatch_feature_call (l_feature, a_parameters)
			else
				if l_feature.is_external then
					l_external_name := l_feature.external_name
					check l_external_name /= Void end

					process_external_procedure_call (false, l_external_name, l_feature.arguments, a_parameters)
				else
					process_normal_feature_call (l_feature, a_parameters, is_precursor_call)
				end
			end
		end

feature {NONE} -- External calls

	process_template_replace (a_template: attached STRING; a_keys: attached LIST[attached STRING]; a_values: attached LIST[attached JSC_BUFFER_DATA])
			-- Replace `a_keys' with `a_values' in `a_template'.
		local
			l_result: attached STRING
		do
			from
				create l_result.make_from_string (a_template)
				a_keys.start
				a_values.start
			until
				a_keys.after
			loop
				l_result.replace_substring_all (a_keys.item, a_values.item.force_string)
				a_keys.forth
				a_values.forth
			end

			output.put (l_result)
		end

	process_external_procedure_call (a_is_static: BOOLEAN; a_template: attached STRING; a_feature_arguments: FEAT_ARG; a_parameters: BYTE_LIST [PARAMETER_B])
			-- Process an external call
		local
			is_static: BOOLEAN
			l_template: attached STRING
			l_feature_arguments: LIST[attached STRING]
			l_argument: STRING
			i: INTEGER
		do
			is_static := a_is_static
			create l_template.make_from_string (a_template)

				-- If the template starts with #, a static call should be made
			if l_template.starts_with ("#") then
				l_template := l_template.substring (2, l_template.count)
				is_static := true
			end

				-- If the template contains the $TARGET, a static call should be made
			if l_template.substring_index ("$TARGET", 1) > 0 then
				l_template.replace_substring_all ("$TARGET", jsc_context.name_mapper.target_name.force_string)
				is_static := true
			end

			if not is_static then
				output.put_data (jsc_context.name_mapper.target_name)
				if not l_template.starts_with ("[") then
					output.put (".")
				end
			end

			if a_feature_arguments /= Void and a_parameters /= Void then
					-- Fill in the argument names
				from
					create {LINKED_LIST[attached STRING]}l_feature_arguments.make
					i := a_feature_arguments.lower
				until
					i > a_feature_arguments.upper
				loop
					l_argument := a_feature_arguments.item_name (i)
					check l_argument /= Void end

					l_feature_arguments.extend ("$" + l_argument)
					i := i + 1
				end

				process_template_replace (l_template, l_feature_arguments, process_parameters(a_parameters))
			else
					-- No replacing is needed
				output.put (l_template)
			end
		end

feature {NONE} -- Normal calls

	process_normal_feature_call (a_feature: attached FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B]; is_precursor_call: BOOLEAN)
			-- Process feature call of feature `a_feature' with parameters `a_parameters'.
		do
			output.put_data (jsc_context.name_mapper.target_name)
			output.put (".")
			if is_precursor_call then
				output.put ("$")
			end
			output.put (jsc_context.name_mapper.feature_name (a_feature, true))
			if not a_feature.is_attribute then
				output.put ("(")
				output.put_data_list (process_parameters(a_parameters), ", ")
				output.put (")")
			end
		end

feature {NONE} -- Dynamic dispatch

	dynamic_dispatch_feature_call (a_feature: attached FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- Process feature call of feature `a_feature' with parameters `a_parameters'.
		local
			l_feature_name: STRING
		do
			if a_feature.is_attribute then
				io.put_string ("JSC_EXPRESSION_WRITER:: TODO_process_special_dispatching_feature_call")
				io.put_new_line
			else
				output.put ("runtime.special_dispatch(")
				output.put_data (jsc_context.name_mapper.target_name)
				output.put (", %"")
				output.put (jsc_context.name_mapper.feature_name (a_feature, false))
				output.put ("%"")
				output.put (", %"")

				l_feature_name := a_feature.feature_name
				check l_feature_name /= Void end

				output.put (l_feature_name)
				output.put ("%"")
				if a_parameters /= Void and then a_parameters.count > 0 then
					output.put (", ")
					output.put_data_list (process_parameters(a_parameters), ", ")
				end
				output.put (")")
			end
		end

feature {NONE} -- Implementation

	show_tuple_brackets: BOOLEAN
			-- Should translate tuples to arrays or not

	output_parameters: attached LIST[attached JSC_BUFFER_DATA]
			-- The current list of parameters (from calls)

	get_feature (a_node: attached CALL_ACCESS_B) : attached FEATURE_I
			-- Fetch feature corresponding to `a_node'
		local
			l_system: SYSTEM_I
			l_feature: FEATURE_I
			written_class: CLASS_C
		do
			l_system := system
			check l_system /= Void end

			written_class := l_system.class_of_id (a_node.written_in)
			check written_class /= Void end

			l_feature := written_class.feature_of_rout_id (a_node.routine_id)

			if l_feature = Void then
				-- Still not sure why this happens
				l_feature := written_class.feature_of_feature_id (a_node.feature_id)
			end
			if l_feature = Void then
				-- Still not sure why this happens
				l_feature := written_class.feature_of_name_id (a_node.feature_name_id)
			end
			check l_feature /= Void end

			Result := l_feature
		end

feature -- Processing helpers

	types_are_equal (a_type1: attached TYPE_A; a_type2: attached TYPE_A; check_attached: BOOLEAN): BOOLEAN
			-- Compare that `a_type1' and `a_type2' are completely equivalent.
		local
			l_generic1, l_generic2: TYPE_A
			class1, class2, i1, i2: INTEGER
		do
			class1 := -1
			if attached a_type1.associated_class as safe_class then
				class1 := safe_class.class_id
			end

			class2 := -2
			if attached a_type2.associated_class as safe_class then
				class2 := safe_class.class_id
			end


			if check_attached and then a_type1.is_attached /= a_type2.is_attached then
				Result := false
			elseif class1 /= class2 then
				Result := false
			else
				if not a_type1.has_generics or not a_type2.has_generics then
					Result := not a_type1.has_generics and not a_type2.has_generics
				else
					if attached a_type1.generics as safe_generics1 and then attached a_type2.generics as safe_generics2 then
						from
							Result := true
							i1 := safe_generics1.lower
							i2 := safe_generics2.lower
						until
							i1 > safe_generics1.upper or i2 > safe_generics2.upper or Result = false
						loop
							l_generic1 := safe_generics1[i1]
							check l_generic1 /= Void end

							l_generic2 := safe_generics2[i2]
							check l_generic2 /= Void end

							Result := Result and types_are_equal (l_generic1, l_generic2, true)
							i1 := i1 + 1
							i2 := i2 + 1
						end
					else
						Result := false
					end
				end
			end
		end

	process_type (a_type: attached TYPE_A): attached JSC_BUFFER_DATA
			-- Generate the JavaScript object for a type (attached?, name, generics).
		local
			l_class: CLASS_C
			l_class_name: STRING
			l_type: TYPE_A
		do
			l_type := a_type.actual_type
			check l_type /= void end

			output.push ("")
				if attached{FORMAL_A}l_type as formal_type then
					output.put (jsc_context.name_mapper.current_class_target)
					output.put (".$generics[")
					output.put ((formal_type.position-1).out)
					output.put ("]")
				else
					output.put ("{attached:")
					if a_type.is_attached then
						output.put ("true")
					else
						output.put ("false")
					end
					output.put (", name:%"")

					l_class := l_type.associated_class
					check l_class /= Void end

					l_class_name := jsc_context.informer.redirect_class (l_class).name_in_upper
					check l_class_name /= Void end

					output.put (l_class_name)
					output.put ("%"")
					output.put (", generics:")
					output.put_data (process_generics(a_type))
					output.put ("}")
				end
				Result := output.data
			output.pop
		end

	process_generics (a_type: attached TYPE_A): attached JSC_BUFFER_DATA
			-- Generate the JavaScript object for a type's generics -- It is a list of types.
		local
			l_generics: ARRAYED_LIST [TYPE_A]
			l_generic: TYPE_A
			generics: LINKED_LIST[attached JSC_BUFFER_DATA]
			i: INTEGER
		do
			create generics.make
			if a_type.has_generics then
				l_generics := a_type.generics
				check l_generics /= Void end

				from
					i := l_generics.lower
				until
					i > l_generics.upper
				loop
					l_generic := l_generics[i]
					check l_generic /= Void end

					generics.extend (process_type (l_generic))
					i := i + 1
				end
			end

			output.push ("")
				output.put ("[")
				output.put_data_list (generics, ", ")
				output.put ("]")
				Result := output.data
			output.pop
		end

	process_parameters (a_parameters: BYTE_LIST [PARAMETER_B]): attached LIST[attached JSC_BUFFER_DATA]
			-- Process `a_parameters' and return them as a nice list.
		local
			l_current_output_parameters: LIST[attached JSC_BUFFER_DATA]
		do
			l_current_output_parameters := output_parameters
			create {LINKED_LIST[attached JSC_BUFFER_DATA]}output_parameters.make
				jsc_context.name_mapper.push_target_current
					safe_process (a_parameters)
				jsc_context.name_mapper.pop_target
			Result := output_parameters
			output_parameters := l_current_output_parameters
		end

	process_binary_infix (a_node: attached BINARY_B)
			-- Process `a_node'.
		local
			l_access: CALL_ACCESS_B
			l_parameters: attached BYTE_LIST [attached PARAMETER_B]
			l_parameter: attached PARAMETER_B
			l_feature: attached FEATURE_I
			l_target_name: attached JSC_BUFFER_DATA
			l_left: EXPR_B
			l_left_type: TYPE_A
		do
			l_access := a_node.access
			check l_access /= Void end

			l_feature := get_feature (l_access)

				-- Create a fake list of parameters
			create l_parameters.make (1)
			create l_parameter
			l_parameter.set_expression (a_node.right)
			l_parameters.extend (l_parameter)

				-- Process the left node (it is the target)
			output.push ("")
				safe_process (a_node.left)
				l_target_name := output.data
			output.pop

			l_left := a_node.left
			check l_left /= Void end

			l_left_type := l_left.type
			check l_left_type /= Void end

				-- Make the actual call
			jsc_context.name_mapper.push_target (l_left_type, l_target_name)
				static_dispatch_feature_call (l_feature, l_parameters, false)
			jsc_context.name_mapper.pop_target
		end

end
