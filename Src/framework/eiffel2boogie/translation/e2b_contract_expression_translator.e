note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_CONTRACT_EXPRESSION_TRANSLATOR

inherit

	E2B_EXPRESSION_TRANSLATOR
		redefine
			reset,
			set_context,
			process_creation_expr_b,
			process_un_old_b,
			process_attribute_call
		end

create
	make

feature -- Access

	origin_class: CLASS_C
			-- Context where the expression in inherited from.

	side_effect: LINKED_LIST [TUPLE [expr: IV_EXPRESSION; info: IV_NODE_INFO]]
			-- List of side effect statements.

	field_accesses: LINKED_LIST [TUPLE [o: IV_EXPRESSION; f: IV_ENTITY]]
			-- List of field accesses.

feature -- Element change

	set_origin_class (a_class: CLASS_C)
			-- Set `origin_class' to `a_class'.
		do
			origin_class := a_class
		end

feature -- Basic operations

	set_context (a_feature: FEATURE_I; a_type: TYPE_A)
			-- Set context of expression to `a_feature' in type `a_type'.
		do
			Precursor (a_feature, a_type)
			origin_class := a_type.base_class
		end

	reset
			-- Reset expression translator.
		do
			Precursor
			origin_class := Void
			create side_effect.make
			create calls.make
			create field_accesses.make
		end

feature -- Visitors

	process_creation_expr_b (a_node: CREATION_EXPR_B)
			-- <Precursor>
		local
			l_type: CL_TYPE_A
			l_feature: FEATURE_I
		do
--			l_type ?= a_node.type.deep_actual_type
--			check l_type /= Void end
--			l_feature := a_node.type.associated_class.feature_of_rout_id (a_node.call.routine_id)
--			check feature_valid: l_feature /= Void end
--			translation_pool.add_referenced_feature (l_feature, l_type)

			last_expression := dummy_node (a_node.type)
		end

	process_un_old_b (a_node: UN_OLD_B)
			-- <Precursor>
		local
			l_call: IV_FUNCTION_CALL
			l_temp_heap: IV_ENTITY
		do
			if attached entity_mapping.old_heap then
				l_temp_heap := entity_mapping.heap
				entity_mapping.set_heap (entity_mapping.old_heap)
				safe_process (a_node.expr)
				entity_mapping.set_heap (l_temp_heap)
			else
				safe_process (a_node.expr)
				last_expression := factory.old_ (last_expression)
			end
		end

feature -- Translation

	process_attribute_call (a_feature: FEATURE_I)
			-- Process call to attribute `a_feature'.
		local
			l_current: IV_ENTITY
			l_field: IV_ENTITY
		do
			translation_pool.add_referenced_feature (a_feature, current_target_type)

			check current_target /= Void end
			create l_field.make (
				name_translator.boogie_procedure_for_feature (a_feature, current_target_type),
				types.field (types.for_type_in_context (a_feature.type, current_target_type))
			)
			last_expression := factory.heap_access (
				entity_mapping.heap.name,
				current_target,
				l_field.name,
				types.for_type_in_context (a_feature.type, current_target_type))

			field_accesses.extend ([current_target, l_field])
		end

	process_routine_call (a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B]; a_for_creator: BOOLEAN)
			-- Process feature call.
		local
			l_target: IV_EXPRESSION
			l_target_type: TYPE_A
			l_call, l_pre_call: IV_FUNCTION_CALL
			l_name: STRING
		do
			check a_feature.has_return_value end

			translation_pool.add_referenced_feature (a_feature, current_target_type)
			l_name := name_translator.boogie_function_for_feature (a_feature, current_target_type)

			create l_call.make (
				l_name,
				types.for_type_in_context (a_feature.type, current_target_type)
			)
			l_call.add_argument (entity_mapping.heap)
			l_call.add_argument (current_target)

			process_parameters (a_parameters)
			l_call.arguments.append (last_parameters)

			-- Add precondition check
			if helper.is_functional (a_feature) and a_feature.has_precondition then
				create l_pre_call.make (name_translator.precondition_predicate_name (a_feature, current_target_type), types.bool)
				l_pre_call.add_argument (entity_mapping.heap)
				l_pre_call.add_argument (current_target)
				l_pre_call.arguments.append (last_parameters)
				add_safety_check (l_pre_call, "check", "precondition_of_function_" + a_feature.feature_name, context_line_number)
			end

			-- This would check that a recursive definitional axiom for a non-functional function is well-defined;
			-- I believe this is not needed, because we have to prove anyway that this postcondition is satisfied by a terminating implementation.
--			add_termination_check (a_feature, last_parameters)

			last_expression := l_call
		end

	process_builtin_routine_call (a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B]; a_builtin_name: STRING)
			-- Process feature call.
		local
			l_target: IV_EXPRESSION
			l_target_type: TYPE_A
			l_call: IV_FUNCTION_CALL
		do
			l_target := current_target
			l_target_type := current_target_type

			create l_call.make (
				a_builtin_name,
				types.for_type_in_context (a_feature.type, current_target_type)
			)
			l_call.add_argument (entity_mapping.heap)
			l_call.add_argument (current_target)

			process_parameters (a_parameters)
			l_call.arguments.append (last_parameters)

			current_target := l_target
			current_target_type := l_target_type

			last_expression := l_call
		end

	process_special_routine_call (a_handler: E2B_CUSTOM_CALL_HANDLER; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		do
			a_handler.handle_routine_call_in_contract (Current, a_feature, a_parameters)
		end

	add_safety_check (a_expression: IV_EXPRESSION; a_name: STRING; a_tag: STRING; a_line: INTEGER)
			-- <Precursor>
		local
			l_info: IV_NODE_INFO
		do
			create l_info.make_with_type (a_name)
			l_info.set_tag (a_tag)
			l_info.set_line (a_line)
			side_effect.extend ([implies_safety_expression (a_expression), l_info])
		end

feature {NONE} -- Implementation

	calls: LINKED_STACK [IV_FUNCTION_CALL]
			-- Stack of procedure calls.

end
