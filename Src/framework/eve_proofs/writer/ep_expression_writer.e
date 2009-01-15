indexing
	description:
		"[
			Boogie code writer to generate expressions.
			This class is used to process descendants of EXPR_B.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_EXPRESSION_WRITER

inherit

	EP_VISITOR
		redefine
			process_agent_call_b,
			process_attribute_b,
			process_argument_b,
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

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

	SHARED_EP_CONTEXT
		export {NONE} all end

	SHARED_BYTE_CONTEXT
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make (a_name_mapper: !EP_NAME_MAPPER; a_old_handler: !EP_OLD_HANDLER)
			-- Initialize expression writer.
		do
			name_mapper := a_name_mapper
			old_handler := a_old_handler
			create expression.make
			create side_effect.make
			create {LINKED_LIST [TUPLE [name: STRING; type: STRING]]} locals.make
			create {LINKED_LIST [STRING]}modified_objects.make
			modified_objects.compare_objects
			create {LINKED_LIST [STRING]}agents_called.make
		ensure
			name_mapper_set: name_mapper = a_name_mapper
			old_handler_set: old_handler = a_old_handler
		end

feature -- Access

	name_mapper: !EP_NAME_MAPPER
			-- Name mapper used to create Boogie code names

	old_handler: !EP_OLD_HANDLER
			-- Handler for old expressions

	expression: !EP_OUTPUT_BUFFER
			-- Output produced from expression

	side_effect: !EP_OUTPUT_BUFFER
			-- Side effect instructions

	locals: LIST [TUPLE [name: STRING; type: STRING]]
			-- List of locals needed for side effects

	modified_objects: !LIST [STRING]
			-- TODO: should this be done in a more generic way?

	agents_called: !LIST [STRING]
			-- TODO: should this be done in a more generic way?

feature -- Element change

	set_name_mapper (a_mapper: like name_mapper)
			-- Set `name_mapper' to `a_name_mapper'.
		do
			name_mapper := a_mapper
		ensure
			name_mapper_set: name_mapper = a_mapper
		end

	reset
			-- Reset expression writer for a new expression.
		do
			expression.reset
			side_effect.reset
			side_effect.set_indentation ("    ")
			locals.wipe_out
			agents_called.wipe_out
			modified_objects.wipe_out
			last_target_type := Void
		end

feature {BYTE_NODE} -- Visitors

	process_agent_call_b (a_node: AGENT_CALL_B)
			-- Process `a_node'.
		do
			process_feature_b (a_node)
		end

	process_argument_b (a_node: ARGUMENT_B)
			-- Process `a_node'.
		do
			expression.put (name_mapper.argument_name (a_node))
				-- TODO: ?
			if not modified_objects.has (name_mapper.argument_name (a_node)) then
				modified_objects.extend (name_mapper.argument_name (a_node))
			end
		end

	process_attribute_b (a_node: ATTRIBUTE_B)
			-- Process `a_node'.
		local
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
--			l_field_name: STRING
			l_function_name: STRING
		do
				-- TODO: why go over feature name and not feature id?
			l_feature := system.class_of_id (a_node.written_in).feature_of_name_id (a_node.attribute_name_id)
			check l_feature /= Void end
			l_attached_feature := l_feature

			feature_list.record_feature_needed (l_attached_feature)

				-- TODO: ?
			if not modified_objects.has (name_mapper.target_name) then
				modified_objects.extend (name_mapper.target_name)
			end

--			l_field_name := name_generator.attribute_name (l_feature)
--			expression.put (name_mapper.heap_name + "[" + name_mapper.target_name + ", " + l_field_name + "]")

				-- TODO: compute side effect?
			l_function_name := name_generator.functional_feature_name (l_feature)
			expression.put (l_function_name + "(" + name_mapper.heap_name + ", " + name_mapper.target_name + ")")
		end

	process_bin_and_b (a_node: BIN_AND_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" && ")
			safe_process (a_node.right)
		end

	process_bin_and_then_b (a_node: B_AND_THEN_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" && ")
			safe_process (a_node.right)
		end

	process_bin_div_b (a_node: BIN_DIV_B)
			-- Process `a_node'.
		do
			if a_node.is_built_in then
				safe_process (a_node.left)
				expression.put (" / ")
				safe_process (a_node.right)
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_eq_b (a_node: BIN_EQ_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" == ")
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
				expression.put (" >= ")
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
				expression.put (" > ")
				safe_process (a_node.right)
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_implies_b (a_node: B_IMPLIES_B)
			-- Process `a_node'.
		do
			expression.put ("(")
			safe_process (a_node.left)
			expression.put (") ==> (")
			safe_process (a_node.right)
			expression.put (")")
		end

	process_bin_le_b (a_node: BIN_LE_B)
			-- Process `a_node'.
		do
			if a_node.is_built_in then
				safe_process (a_node.left)
				expression.put (" <= ")
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
				expression.put (" < ")
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
				expression.put (" - ")
				safe_process (a_node.right)
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_mod_b (a_node: BIN_MOD_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" %% ")
			safe_process (a_node.right)
		end

	process_bin_ne_b (a_node: BIN_NE_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" != ")
			safe_process (a_node.right)
		end

	process_bin_or_b (a_node: BIN_OR_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" || ")
			safe_process (a_node.right)
		end

	process_bin_or_else_b (a_node: B_OR_ELSE_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" || ")
			safe_process (a_node.right)
		end

	process_bin_plus_b (a_node: BIN_PLUS_B)
			-- Process `a_node'.
		do
			if a_node.is_built_in then
				safe_process (a_node.left)
				expression.put (" + ")
				safe_process (a_node.right)
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_power_b (a_node: BIN_POWER_B)
			-- Process `a_node'.
		do
			expression.put ("power(")
			safe_process (a_node.left)
			expression.put (", ")
			safe_process (a_node.right)
			expression.put (")")
		end

	process_bin_slash_b (a_node: BIN_SLASH_B)
			-- Process `a_node'.
		do
			if a_node.is_built_in then
				safe_process (a_node.left)
				expression.put (" / ")
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
				expression.put (" * ")
				safe_process (a_node.right)
			else
				process_binary_infix (a_node)
			end
		end

	process_bin_xor_b (a_node: BIN_XOR_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" != ")
			safe_process (a_node.right)
		end

	process_bit_const_b (a_node: BIT_CONST_B)
			-- Process `a_node'.
		do
			-- TODO: add error
		end

	process_bool_const_b (a_node: BOOL_CONST_B)
			-- Process `a_node'.
		do
			if a_node.value then
				expression.put ("true")
			else
				expression.put ("false")
			end
		end

	process_char_const_b (a_node: CHAR_CONST_B)
			-- Process `a_node'.
		do
			expression.put (a_node.value.code.out)
		end

	process_constant_b (a_node: CONSTANT_B)
			-- Process `a_node'.
		do
			expression.put (a_node.value.string_value)
		end

	process_creation_expr_b (a_node: CREATION_EXPR_B)
			-- Process `a_node'.
		local
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
			l_creation_routine_name: STRING
			l_local_name: STRING
			l_temp_expression, l_arguments: STRING
			l_type: CL_TYPE_A
		do
			l_type ?= a_node.type
			l_feature := system.class_of_id (l_type.class_id).feature_of_feature_id (a_node.call.feature_id)
			check l_feature /= Void end
			l_attached_feature := l_feature

			feature_list.record_creation_routine_needed (l_attached_feature)
			l_creation_routine_name := name_generator.creation_routine_name (l_attached_feature)

				-- TODO: create new local, register local
			create_new_local (l_type)
			l_local_name := last_local;

				-- Store expression
			l_temp_expression := expression.string
				-- Evaluate parameters with fresh expression
			expression.reset
			expression.put (l_local_name)
			safe_process (a_node.call.parameters)
			l_arguments := expression.string
				-- Restore original expression
			expression.reset
			expression.put (l_temp_expression)

			side_effect.put_comment_line ("Object creation")
			side_effect.put_line ("havoc " + l_local_name + ";")
			side_effect.put_line ("assume !" + name_mapper.heap_name + "[" + l_local_name + ", $allocated] && " + l_local_name + " != null;")
			side_effect.put_line ("call " + l_creation_routine_name + "(" + l_arguments + ");")

			expression.put (l_local_name)
		end

	process_current_b (a_node: CURRENT_B)
			-- Process `a_node'.
		do
			expression.put (name_mapper.current_name)
				-- TODO: ?
			if not modified_objects.has (name_mapper.current_name) then
				modified_objects.extend (name_mapper.current_name)
			end
		end

	process_external_b (a_node: EXTERNAL_B)
			-- Process `a_node'.
		local
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
		do
				-- TODO: why go over feature name and not feature id?
			l_feature := system.class_of_id (a_node.written_in).feature_of_name_id (a_node.feature_name_id)
			check l_feature /= Void end
			l_attached_feature := l_feature

			process_feature_call (l_attached_feature, a_node.parameters)
		end

	process_feature_b (a_node: FEATURE_B)
			-- Process `a_node'.
		local
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
		do
				-- TODO: why go over feature name and not feature id?
			l_feature := system.class_of_id (a_node.written_in).feature_of_name_id (a_node.feature_name_id)
			check l_feature /= Void end
			l_attached_feature := l_feature

			process_feature_call (l_attached_feature, a_node.parameters)
		end

	process_int64_val_b (a_node: INT64_VAL_B)
			-- Process `a_node'.
		do
			expression.put (a_node.value.out)
		end

	process_int_val_b (a_node: INT_VAL_B)
			-- Process `a_node'.
		do
			expression.put (a_node.value.out)
		end

	process_integer_constant (a_node: INTEGER_CONSTANT)
			-- Process `a_node'.
		do
			expression.put (a_node.integer_64_value.out)
		end

	process_local_b (a_node: LOCAL_B)
			-- Process `a_node'.
		do
			expression.put (name_generator.local_name (a_node.position))
		end

	process_nat64_val_b (a_node: NAT64_VAL_B)
			-- Process `a_node'.
		do
			expression.put (a_node.value.out)
		end

	process_nat_val_b (a_node: NAT_VAL_B)
			-- Process `a_node'.
		do
			expression.put (a_node.value.out)
		end

	process_nested_b (a_node: NESTED_B)
			-- Process `a_node'.
		local
			l_temp_expression: STRING
			l_target_name: STRING
		do
			last_target_type := a_node.target.type

				-- Store expression
			l_temp_expression := expression.string
				-- Evaluate target with fresh expression
			expression.reset
			safe_process (a_node.target)
				-- Use target as new `Current' reference
			l_target_name := name_mapper.target_name
			name_mapper.set_target_name (expression.string)

				-- Test if target is valid
			side_effect.put_line ("assert IsAllocatedAndNotVoid(" + name_mapper.heap_name + ", " + name_mapper.target_name + "); // " + ep_context.assert_location ("attached"))

				-- Evaluate message with original expression
			expression.reset
			expression.put (l_temp_expression)
			safe_process (a_node.message)
				-- Restore `Current' reference
			name_mapper.set_target_name (l_target_name)

			last_target_type := Void
		end

	process_object_test_b (a_node: OBJECT_TEST_B)
			-- Process `a_node'.
		local
			l_position: INTEGER
			l_name, l_type: STRING
		do
			l_position := context.object_test_local_position (a_node.target)
			l_name := name_generator.local_name (l_position)
			-- TODO: this doesnt work as the context is not initialized for locals
			l_type := type_mapper.boogie_type_for_type (a_node.target.type)
			--l_type := "any"
			locals.extend ([l_name, l_type])
				-- TODO: generate code for object test
			expression.put ("true")
		end

	process_object_test_local_b (a_node: OBJECT_TEST_LOCAL_B)
			-- Process `a_node'.
		local
			l_position: INTEGER
		do
			l_position := context.object_test_local_position (a_node)
			expression.put (name_generator.local_name (l_position))
		end

	process_paran_b (a_node: PARAN_B)
			-- Process `a_node'.
		do
			expression.put ("(")
			safe_process (a_node.expr)
			expression.put (")")
		end

	process_parameter_b (a_node: PARAMETER_B)
			-- Process `a_node'.
		do
			expression.put (", ")
			safe_process (a_node.expression)
		end

	process_result_b (a_node: RESULT_B)
			-- Process `a_node'.
		do
			expression.put (name_mapper.result_name)
		end

	process_routine_creation_b (a_node: ROUTINE_CREATION_B)
			-- Process `a_node'.
		local
			l_agent_variable: STRING
			l_agent_class: CLASS_C
			l_agent_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
			l_contract_writer: !EP_CONTRACT_WRITER
			l_expression_writer: !EP_EXPRESSION_WRITER
			l_name_mapper: !EP_AGENT_NAME_MAPPER
			l_open_argument_count, l_closed_argument_count: INTEGER
			l_arguments, l_typed_arguments: STRING
			l_temp_expression: STRING
			i, j, k: INTEGER
		do
			l_agent_class := system.class_of_id (a_node.origin_class_id)
			l_agent_feature := l_agent_class.feature_of_feature_id (a_node.feature_id)
			check l_agent_feature /= Void end
			l_attached_feature := l_agent_feature

			create_new_reference_local
			l_agent_variable := last_local

				-- Initialize agent variable
			side_effect.put_comment_line ("Create agent")
			side_effect.put_line ("havoc " + l_agent_variable + ";")
			side_effect.put_line ("assume Heap[" + l_agent_variable + ", $allocated] == false && " + l_agent_variable + " != null;")
			side_effect.put_line ("call routine.create (" + l_agent_variable + ");")

				-- Create arguments
			create l_name_mapper.make

			l_open_argument_count := a_node.omap.count
			l_closed_argument_count := a_node.arguments.expressions.count
			check l_attached_feature.argument_count + 1 = l_open_argument_count + l_closed_argument_count end

			create l_arguments.make_from_string (", " + l_agent_variable)
			create l_typed_arguments.make_empty

			from
				i := 1
				j := 1
				k := 1
				l_temp_expression := expression.string
			until
				i > l_attached_feature.argument_count + 1
			loop
				if j <= a_node.omap.count and then a_node.omap.i_th (j) = i then
						-- Next is an open argument
					check j <= a_node.omap.count end
					if i = 1 then
						check not a_node.is_target_closed end
						l_name_mapper.set_current_name ("a1")
						l_name_mapper.set_target_name ("a1")
					else
						l_name_mapper.argument_mappings.put ("a" + j.out, i - 1)
					end

					l_arguments.append (", a" + j.out)
						-- TODO: use correct type
					l_typed_arguments.append (", a" + j.out + ": ref")

					j := j + 1
				else
						-- Next is a closed argument
					check k <= a_node.arguments.expressions.count end

					expression.reset
					a_node.arguments.expressions.i_th (k).process (Current)

					if i = 1 then
						check a_node.is_target_closed end
						l_name_mapper.set_current_name (expression.string)
						l_name_mapper.set_target_name (expression.string)
					else
						l_name_mapper.argument_mappings.put (expression.string, i - 1)
					end
					k := k + 1
				end
				i := i + 1
			end
			expression.reset
			expression.put (l_temp_expression)

			if a_node.is_target_closed then
					-- Test if target is valid
				side_effect.put_line ("assert IsAllocatedAndNotVoid(" + name_mapper.heap_name + ", " + l_name_mapper.target_name + "); // " + ep_context.assert_location ("attached"))
			end

			create l_expression_writer.make (l_name_mapper, create {EP_OLD_HEAP_HANDLER}.make ("old_heap"))
			create l_contract_writer.make
			l_contract_writer.set_expression_writer (l_expression_writer)
			l_contract_writer.set_feature (l_attached_feature)
			l_contract_writer.generate_contracts

			side_effect.put_comment_line ("Agent properties")
			side_effect.put_line ("assume (forall heap: HeapType" + l_typed_arguments + " :: ")
			side_effect.put_line ("            { routine.precondition_" + l_open_argument_count.out + "(heap" + l_arguments + ") } // Trigger")
			side_effect.put_line ("        routine.precondition_" + l_open_argument_count.out + "(heap" + l_arguments + ") <==> " + l_contract_writer.full_precondition + ");")
-- TODO: fix for demo
--			side_effect.put_line ("assume (forall $o: ref, $f: name :: ")
--			side_effect.put_line ("            { agent.modifies(" + l_agent_variable + ", $o, $f) } // Trigger")
--			side_effect.put_line ("        agent.modifies(" + l_agent_variable + ", $o, $f) <==> ($o == arg.a_paragraph));")
			side_effect.put_line ("assume (forall<alpha> $o: ref, $f: Field alpha :: ")
			side_effect.put_line ("            { agent.modifies(" + l_agent_variable + ", $o, $f) } // Trigger")
			side_effect.put_line ("        agent.modifies(" + l_agent_variable + ", $o, $f) <==> (true));")
			if l_attached_feature.has_return_value then
				side_effect.put_line ("assume (forall heap: HeapType, old_heap: HeapType" + l_typed_arguments + ", result:any :: ")
				side_effect.put_line ("            { function.postcondition_" + l_open_argument_count.out + "(heap, old_heap" + l_arguments + ", result) } // Trigger")
				side_effect.put_line ("        function.postcondition_" + l_open_argument_count.out + "(heap, old_heap" + l_arguments + ", result) <==> " + l_contract_writer.full_postcondition + ");")
			else
				side_effect.put_line ("assume (forall heap: HeapType, old_heap: HeapType" + l_typed_arguments + " :: ")
				side_effect.put_line ("            { routine.postcondition_" + l_open_argument_count.out + "(heap, old_heap" + l_arguments + ") } // Trigger")
				side_effect.put_line ("        routine.postcondition_" + l_open_argument_count.out + "(heap, old_heap" + l_arguments + ") <==> " + l_contract_writer.full_postcondition + ");")
			end

				-- Store expression which is assigned in here
			expression.put (l_agent_variable)
		end

	process_string_b (a_node: STRING_B)
			-- Process `a_node'.
		do
			create_new_reference_local
			side_effect.put_line ("havoc " + last_local + ";")
			side_effect.put_line ("assume " + last_local + " != null && Heap[" + last_local + ", $allocated];")
			expression.put (last_local)
		end

	process_un_free_b (a_node: UN_FREE_B)
			-- Process `a_node'.
		do
			-- TODO: implement
			check false end
		end

	process_un_minus_b (a_node: UN_MINUS_B)
			-- Process `a_node'.
		do
			expression.put ("( -")
			safe_process (a_node.expr)
			expression.put (")")
		end

	process_un_not_b (a_node: UN_NOT_B)
			-- Process `a_node'.
		do
			expression.put ("(!")
			safe_process (a_node.expr)
			expression.put (")")
		end

	process_un_old_b (a_node: UN_OLD_B)
			-- Process `a_node'.
		do
			check a_node.expr /= Void end
			old_handler.set_expression_writer (Current)
			old_handler.process_un_old_b (a_node)
		end

	process_void_b (a_node: VOID_B)
			-- Process `a_node'.
		do
			expression.put ("null")
		end

feature {NONE} -- Implementation

	last_target_type: TYPE_A
			-- Type of last target in a nested node

	last_local: STRING
			-- Last created local

	current_local_number: INTEGER
			-- Number of current temporary variable

	create_new_local (a_type: TYPE_A)
			-- Create new unused local.
		do
			current_local_number := current_local_number + 1
			last_local := "temp_" + current_local_number.out
			locals.extend ([last_local, type_mapper.boogie_type_for_type (a_type)])
		end

	create_new_reference_local
			-- Create new unused local.
		do
			current_local_number := current_local_number + 1
			last_local := "temp_" + current_local_number.out
			locals.extend ([last_local, "ref"])
		end

	process_feature_call (a_feature: !FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- Process feature call of feature `a_feature' with parameters `a_parameters'.
		do
			if has_special_mapping (a_feature) then
				process_special_feature_call (a_feature, a_parameters)
			else
				process_normal_feature_call (a_feature, a_parameters)
			end
		end

	process_special_feature_call (a_feature: !FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- Process feature call of feature `a_feature' with parameters `a_parameters'.
		local
			l_feature_name, l_function_name, l_procedure_name: STRING
			l_temp_expression, l_arguments, l_arguments_suffix: STRING
			l_tuple_argument: TUPLE_CONST_B
			l_tuple_content: BYTE_LIST [BYTE_NODE]
			l_boogie_function: STRING
			l_open_argument_count: INTEGER
			l_is_function: BOOLEAN
		do
			l_feature_name := a_feature.feature_name

			l_is_function := last_target_type.associated_class.name_in_upper.is_equal ("FUNCTION")

			check a_parameters.count = 1 end
			l_tuple_argument ?= a_parameters [1].expression
			check l_tuple_argument /= Void end
			l_tuple_content := l_tuple_argument.expressions
			l_open_argument_count := l_tuple_content.count

				-- Construct arguments
			l_arguments := ""
			if l_feature_name.is_equal ("precondition") then
				l_arguments := "Heap, "
				l_arguments_suffix := ""
				l_boogie_function := "routine.precondition_" + l_open_argument_count.out
			elseif l_feature_name.is_equal ("postcondition") then
				l_arguments := "Heap, old(Heap), "
				if l_is_function then
					l_arguments_suffix := ", Result"
					l_boogie_function := "function.postcondition_" + l_open_argument_count.out
				else
					l_arguments_suffix := ""
					l_boogie_function := "routine.postcondition_" + l_open_argument_count.out
				end
					-- TODO: this needs actually a code analysis
				agents_called.extend (name_mapper.target_name)
			elseif l_feature_name.is_equal ("call") then
				l_arguments := ""
				l_arguments_suffix := ""
				l_boogie_function := "routine.call_" + l_open_argument_count.out
			elseif l_feature_name.is_equal ("item") then
				l_arguments := ""
				l_arguments_suffix := ""
				l_boogie_function := "function.item_" + l_open_argument_count.out
			else
				check false end
			end

				-- Store expression
			l_temp_expression := expression.string
				-- Evaluate parameters with fresh expression
			expression.reset
			expression.put (l_arguments)
			expression.put (name_mapper.target_name)

			from
				l_tuple_content.start
			until
				l_tuple_content.after
			loop
				expression.put (", ")
				safe_process (l_tuple_content.item_for_iteration)

				l_tuple_content.forth
			end

			l_arguments := expression.string + l_arguments_suffix
				-- Restore original expression
			expression.reset
			expression.put (l_temp_expression)

				-- TODO: this is not correct!

			if a_feature.has_return_value then
				create_new_local (a_feature.type)
				side_effect.put_line ("call " + last_local + " := " + l_boogie_function + "(" + l_arguments + ");")
			else
				side_effect.put_line ("call " + l_boogie_function + "(" + l_arguments + ");")
			end
			expression.put (l_boogie_function + "(" + l_arguments + ")")

		end

	process_normal_feature_call (a_feature: !FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- Process feature call of feature `a_feature' with parameters `a_parameters'.
		local
			l_function_name, l_procedure_name: STRING
			l_temp_expression, l_arguments: STRING
		do
			feature_list.record_feature_needed (a_feature)

			l_function_name := name_generator.functional_feature_name (a_feature)
			l_procedure_name := name_generator.procedural_feature_name (a_feature)

				-- Store expression
			l_temp_expression := expression.string
				-- Evaluate parameters with fresh expression
			expression.reset
			expression.put (name_mapper.target_name)
			safe_process (a_parameters)
			l_arguments := expression.string
				-- Restore original expression
			expression.reset
			expression.put (l_temp_expression)

			if a_feature.has_return_value then
				create_new_local (a_feature.type)
				side_effect.put_line ("call " + last_local + " := " + l_procedure_name + "(" + l_arguments + ");")
			else
				side_effect.put_line ("call " + l_procedure_name + "(" + l_arguments + ");")
			end
			expression.put (l_function_name + "(" + name_mapper.heap_name + ", " + l_arguments + ")")
		end

	process_binary_infix (a_node: BINARY_B)
			-- Process `a_node'.
		require
			a_node_not_void: a_node /= Void
		local
			l_parameters: BYTE_LIST [PARAMETER_B]
			l_parameter: PARAMETER_B
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
			l_temp_expression, l_target_name: STRING
		do
				-- TODO: why go over feature name and not feature id?
			l_feature := system.class_of_id (a_node.access.written_in).feature_of_name_id (a_node.access.feature_name_id)
			check l_feature /= Void end
			l_attached_feature := l_feature

			create l_parameters.make (1)
			create l_parameter
			l_parameter.set_expression (a_node.right)
			l_parameters.extend (l_parameter)

				-- Store expression
			l_temp_expression := expression.string
				-- Evaluate target with fresh expression
			expression.reset
			safe_process (a_node.left)
				-- Use target as new `Current' reference
			l_target_name := name_mapper.target_name
			name_mapper.set_target_name (expression.string)
				-- Evaluate message with original expression
			expression.reset
			expression.put (l_temp_expression)
			process_feature_call (l_attached_feature, l_parameters)
				-- Restore `Current' reference
			name_mapper.set_target_name (l_target_name)
		end

	has_special_mapping (a_feature: FEATURE_I): BOOLEAN
			-- TODO: refactor
		local
			l_class: STRING
		do
			l_class := a_feature.written_class.name_in_upper
			Result := l_class.is_equal ("ROUTINE") or l_class.is_equal ("FUNCTION") or l_class.is_equal ("PROCEDURE")
		end

end
