note
	description: "Pre-state input invariant breaker by calling some features"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_STATE_CHANGING_FEATURE_PRECONDITION_BREAKER

inherit

	AUT_TASK

	AUT_SHARED_CONSTANTS
		export {NONE} all end

	ERL_G_TYPE_ROUTINES

	REFACTORING_HELPER

	EQA_TEST_CASE_SERIALIZATION_UTILITY

	SHARED_TYPES

	EPA_UTILITY
		undefine
			system
		end

	EPA_SHARED_EQUALITY_TESTERS
		undefine
			system
		end

create
	make

feature{NONE} -- Implementation

	make (a_system: like system; a_interpreter: like interpreter; a_error_handler: like error_handler; a_invariant: like current_invariant; a_retriever: AUT_QUERYABLE_QUERYABLE_RETRIEVER)
			-- Initialization.			
		require
			invariant_attached: a_invariant /= Void
		do
			system := a_system
			interpreter := a_interpreter
			error_handler := a_error_handler
			current_invariant := a_invariant
			create object_combinations.make
			queryable_retriever := a_retriever
--			a_combinations.do_all (agent object_combinations.force_last)
		end

feature -- Access

	system: SYSTEM_I
			-- System

	interpreter: AUT_INTERPRETER_PROXY
			-- Proxy to the interpreter.

	error_handler: AUT_ERROR_HANDLER
			-- Error handler.

	current_invariant: AUT_STATE_INVARIANT
			-- Pre-state invariant that we would like to SATISFY
			-- Assume that this invariant is already in CNF form.

	object_combinations: DS_LINKED_LIST [SEMQ_RESULT]
			-- Objects combinations that might break the state invariant.

	queryable_retriever: AUT_QUERYABLE_QUERYABLE_RETRIEVER
			-- Queryable retriever

	class_: CLASS_C
			-- Class of `current_invariant'.
		do
			Result := current_invariant.context_class
		end

	feature_: FEATURE_I
			-- Feature of `current_invariant'.
		do
			Result := current_invariant.feature_
		end

feature -- Status

	has_next_step: BOOLEAN
			-- Is there a next step to execute?
		do
			Result := not should_quit and then not object_combinations.is_empty and then (value_of_current_invariant_before_test = True)
		end

	value_of_current_invariant_before_test: BOOLEAN
			-- The value of `current_invariant' before executing any test

	is_last_test_case_executed: BOOLEAN
			-- Is last test case executed (either successfuly or resulted in an exception)?

feature -- Execute

	start
		do
			value_of_current_invariant_before_test := True
			should_quit := false
		end

	step
		local
			l_queryables: LINKED_LIST [SEM_QUERYABLE]
			l_result: DS_ARRAYED_LIST [TUPLE [var_index: INTEGER; var_type: TYPE_A]]
			l_variable_mapping: HASH_TABLE [SEM_VARIABLE_WITH_UUID, STRING]
			l_nbr_variables: INTEGER
			l_exprs: LINKED_LIST [EPA_EXPRESSION]
			l_opds: like operand_expressions_with_feature
			l_opd_expr: EPA_AST_EXPRESSION
			l_types: like resolved_operand_types_with_feature
			l_should_test: BOOLEAN
		do
			current_combination := object_combinations.first
			object_combinations.remove_first

			if not should_quit and then attached current_combination as lv_combination and then not lv_combination.queryables.is_empty then
				has_error := False
				collect_provided_operands

				if interpreter.is_executing and then interpreter.is_ready and then not has_error then
					batch_assign_provided_operands_to_variables
				end

				if interpreter.is_executing and then interpreter.is_ready and then not has_error
						and then is_missing_operand
				then
					prepare_missing_operand_objects
				end

				if interpreter.is_executing and then interpreter.is_ready and then not has_error then
						-- Evaluate pre-state invariants to see if they are indeed broken.
					create l_exprs.make
					l_types := resolved_operand_types_with_feature (feature_, class_, class_.constraint_actual_type)
					l_exprs.extend (current_invariant.expression)
					l_opds := operand_expressions_with_feature (class_, feature_)
					l_should_test := True
					across operand_for_invocation as l_operands until not l_should_test loop
							-- Note: Check if the the loaded objects conform to the static type
							-- of the operands from the feature under test.
							-- This is needed because the semantic database contains some error data,
							-- meaning that sometimes the deserialized objects have a different type.
						l_should_test := l_operands.item.type.conform_to (class_, l_types.item (l_operands.key))
						if l_should_test then
							l_exprs.extend (l_opds.item (l_operands.key))
						end
					end
					if l_should_test then
						interpreter.evaluate_expressions (class_, feature_, operand_map, l_exprs, agent on_expressions_evaluated)
					end
				end

				if l_should_test and then interpreter.is_executing and then interpreter.is_ready and then not has_error then
					is_last_test_case_executed := False
					invoke_feature_with_operands
					is_last_test_case_executed := interpreter.is_last_test_case_executed
					should_quit := is_last_test_case_executed and (value_of_current_invariant_before_test = False)
				end
			end
		end

	on_expressions_evaluated (a_values: HASH_TABLE [STRING, STRING])
			-- Agent to call when expressions are evaluated
			-- `a_values' is a hash-table, keys are evaluated expressions,
			-- values are the values of those evaluations.
		local
			l_evaluations: like expression_evaluations_in_feature_context
			l_exprs: LINKED_LIST [EPA_EXPRESSION]
		do
			create l_exprs.make
			l_exprs.extend (current_invariant.expression)
			l_evaluations := expression_evaluations_in_feature_context (class_, feature_, a_values, operand_map, l_exprs)
			if attached {EPA_EQUATION} l_evaluations.item_with_expression (current_invariant.expression) as l_equation then
				if attached {EPA_BOOLEAN_VALUE} l_equation.value as l_bool then
					value_of_current_invariant_before_test := l_bool.item
				end
			end
		end

	cancel
		do
			should_quit := True
		end

feature{NONE} -- Access

	should_quit: BOOLEAN
			-- Should the task quit executing?

	has_error: BOOLEAN
			-- Has error happened in breaking the precondition?

	current_combination: SEMQ_RESULT
			-- Current object combination used to break `current_invariant'.

	provided_object_serializations: DS_HASH_TABLE [STRING, STRING]
			-- Serialization data containing all provided operand objects.
			-- Key: test case UUID;
			-- Val: Objects associated with the test case.

	operand_for_invocation: HASH_TABLE [TUPLE [var_with_uuid: SEM_VARIABLE_WITH_UUID; var: ITP_VARIABLE; type: TYPE_A], INTEGER]
			-- Information about the operands that are provided.
			-- Key: operand position in a call to `feature_'.
			-- Val: information about the operand at that position.

	operand_map: HASH_TABLE [INTEGER, INTEGER]
			-- Operand map from 0-based operand index to object IDs in the object pool
			-- Data comes from `operand_for_invocation'.
		do
			create Result.make (operand_for_invocation.count)
			across operand_for_invocation as l_opds loop
				Result.force (l_opds.item.var.index, l_opds.key)
			end
		end

feature{NONE} -- Implementation

	is_missing_operand: BOOLEAN
			-- Is `operand_for_invocation' not enough for invokation?
		local
			l_operand_count: INTEGER
			l_operand_index: INTEGER
		do
			l_operand_count := feature_.argument_count + 1
			from
				Result := False
				l_operand_index := 0
			until
				Result or else l_operand_index >= l_operand_count
			loop
				if not operand_for_invocation.has (l_operand_index) or else operand_for_invocation.item (l_operand_index).var = Void then
					Result := True
				end
				l_operand_index := l_operand_index + 1
			end
		end

	collect_provided_operands
			-- Collect operands that have been provided.
			-- Make the result available in `provided_object_serializations' and `operand_for_invocation'.
		require
			combination_attached: current_combination /= Void
		local
			l_queryables: LINKED_LIST [SEM_QUERYABLE]
			l_operand_position_name_mapping: DS_HASH_TABLE [STRING, INTEGER]
			l_operand_name_var_mapping: HASH_TABLE [SEM_VARIABLE_WITH_UUID, STRING]
			l_uuid_object_types_mapping: DS_HASH_TABLE [HASH_TABLE [TYPE_A, STRING], STRING]
			l_serialization_string: STRING
			l_interpreter_var: ITP_VARIABLE
			l_operand_position, l_operand_count, l_var_index: INTEGER
			l_operand_name, l_var_name, l_uuid: STRING
			l_var_with_uuid: SEM_VARIABLE_WITH_UUID
			l_var_type: TYPE_A
		do
				-- Put all serializations into a hash table, with the test case UUID as the key.
			l_operand_position_name_mapping := operands_with_feature (current_invariant.feature_)
			l_operand_name_var_mapping := current_combination.variable_mapping
			from
				l_queryables := current_combination.queryables
				create l_uuid_object_types_mapping.make_equal (l_queryables.count)
				create provided_object_serializations.make_equal (l_queryables.count)
				l_queryables.start
			until
				l_queryables.after
			loop
				check attached {SEM_OBJECTS} l_queryables.item_for_iteration as lv_objects then
					l_uuid_object_types_mapping.force (lv_objects.variable_dynamic_type_table, lv_objects.uuid)
					l_serialization_string := string_from_array (lv_objects.serialization_as_array)
					provided_object_serializations.force (l_serialization_string, lv_objects.uuid)
				end
				l_queryables.forth
			end

				-- Collect all provided operands into `operand_for_invocation'.
			l_operand_count := l_operand_position_name_mapping.count
			create operand_for_invocation.make (l_operand_count)
			from l_operand_position := 0
			until l_operand_position >= l_operand_count
			loop
				l_operand_name := l_operand_position_name_mapping.item (l_operand_position)
				if l_operand_name_var_mapping.has (l_operand_name) then
						-- Only put information about available operands into the mapping.
					l_var_with_uuid := l_operand_name_var_mapping.item (l_operand_name)
					l_uuid := l_var_with_uuid.uuid
					l_var_name := l_var_with_uuid.variable
					l_interpreter_var := interpreter.variable_table.new_variable
					l_var_type := l_uuid_object_types_mapping.item (l_uuid).item (l_var_name)
					operand_for_invocation.force ([l_var_with_uuid, l_interpreter_var, l_var_type], l_operand_position)
				end

				l_operand_position := l_operand_position + 1
			end
		end

	batch_assign_provided_operands_to_variables
			-- Assign provided operand objects to interpreter variables.
		require
			provided_object_serializations_not_empty: provided_object_serializations /= Void
						and then not provided_object_serializations.is_empty
			operand_for_invokation_not_empty: operand_for_invocation /= Void
						and then not operand_for_invocation.is_empty
		local
			l_provided_object_serializations: DS_HASH_TABLE [STRING, STRING]
			l_batch_assignment_list: DS_ARRAYED_LIST [TUPLE [var_with_uuid: SEM_VARIABLE_WITH_UUID; var: ITP_VARIABLE; type: TYPE_A]]
		do
			l_provided_object_serializations := provided_object_serializations
			create l_batch_assignment_list.make (operand_for_invocation.count)
			across operand_for_invocation as l_opds loop
				check interpreter_var_assigned: l_opds.item.var /= Void end
				l_batch_assignment_list.force_last (l_opds.item)
			end
			interpreter.batch_assign_variables (l_batch_assignment_list, l_provided_object_serializations)
		end

	prepare_missing_operand_objects
			-- Prepare missing operand objects for the invocation.
			-- Add such information into `operand_for_invocation'.
		require
			operand_for_invokation_not_empty: operand_for_invocation /= Void and then not operand_for_invocation.is_empty
			target_variable_type_available: operand_for_invocation.has (0) and then operand_for_invocation.item (0).type /= Void
			is_missing_operand: is_missing_operand
		local
			l_target_type: TYPE_A
			l_operand_types: DS_HASH_TABLE [TYPE_A, INTEGER]
			l_operand_index, l_operand_count: INTEGER
			l_operand_type: TYPE_A
			l_variable: ITP_VARIABLE
			l_input_creator: AUT_RANDOM_INPUT_CREATOR
			l_operands_to_create: DS_ARRAYED_LIST [INTEGER]
			l_receivers: DS_LIST [ITP_VARIABLE]
		do
			l_target_type := operand_for_invocation.item (0).type
			l_operand_count := feature_.argument_count + 1
			l_operand_types := resolved_operand_types_with_feature (feature_, class_, l_target_type)

				-- Prepare input creator.
			from
				create l_input_creator.make (system, interpreter, Void)
				create l_operands_to_create.make (l_operand_count)
				l_operand_index := 1
			until
				l_operand_index >= l_operand_count
			loop
				if not operand_for_invocation.has (l_operand_index) then
					l_operand_type := l_operand_types.item (l_operand_index)
					l_input_creator.add_type (l_operand_type)
					l_operands_to_create.force_last (l_operand_index)
				end
				l_operand_index := l_operand_index + 1
			end
			check missing_operands: l_input_creator.types.count > 0 end

				-- Create all missing operands.
			from l_input_creator.start
			until not interpreter.is_ready or else not l_input_creator.has_next_step or else l_input_creator.has_error
			loop
				l_input_creator.step
			end

				-- Get created objects for operands.
			if l_input_creator.receivers.count /= l_operands_to_create.count then
				has_error := True
			else
				l_receivers := l_input_creator.receivers
				from
					l_receivers.start
					l_operands_to_create.start
				until
					l_receivers.after
				loop
					l_operand_index := l_operands_to_create.item_for_iteration
					l_operand_type := l_operand_types.item (l_operand_index)
					operand_for_invocation.force ([Void, l_receivers.item_for_iteration, l_operand_type], l_operand_index)

					l_receivers.forth
					l_operands_to_create.forth
				end
			end
		ensure
			is_missing_operand_implies_has_error: is_missing_operand implies has_error
		end

	invoke_feature_with_operands
			-- Invoke `feature_' using the operands from `operand_for_invocation'.
		require
			interpreter_ready: interpreter.is_executing and then interpreter.is_ready
			not_has_error: not has_error
			operands_complete: not is_missing_operand
		local
			l_argument_variables: DS_ARRAYED_LIST [ITP_VARIABLE]
			l_argument_index, l_argument_count: INTEGER
			l_target_type: TYPE_A
			l_target_var, l_result_var: ITP_VARIABLE
		do
			print("%N%NTesting " + class_.name_in_upper + "." + feature_.feature_name + "%N")

				-- Argument variable list.
			l_argument_count := feature_.argument_count
			from
				l_argument_index := 1
				create l_argument_variables.make (l_argument_count)
			until
				l_argument_index > l_argument_count
			loop
				l_argument_variables.force_last (operand_for_invocation.item(l_argument_index).var)
				l_argument_index := l_argument_index + 1
			end

				-- Invoke feature using given objects as operands.
			l_target_type := operand_for_invocation.item (0).type
			l_target_var := operand_for_invocation.item (0).var
			if feature_.type.is_void then
				interpreter.invoke_feature (l_target_type, feature_, l_target_var, l_argument_variables, Void)
			else
				l_result_var := interpreter.variable_table.new_variable
				interpreter.invoke_and_assign_feature (l_result_var, l_target_type, feature_, l_target_var, l_argument_variables, Void)
			end
		end

	expression_evaluations_in_feature_context (a_class: CLASS_C; a_feature: FEATURE_I; a_source: HASH_TABLE [STRING, STRING]; a_operand_map: HASH_TABLE [INTEGER, INTEGER]; a_target: LINKED_LIST [EPA_EXPRESSION]): EPA_STATE
			-- Evaluations of expressions in `a_target' based on expressions in `a_source' in the context of `a_feature' from `a_class'
			-- Expressions in `a_source' mentions objects in the object pool, so the expressions will be
			-- something like "v_10.has (v_2)". `a_operand_map' is a mapping from operand indexs to object ids in the object pool.
			-- Keys are 0-based operand indexes from `a_feature', values are the IDs of objects in the object pool.
			-- The result is a state (expression-value pairs), the expressions in the result is in operand-format, for example,
			-- "Current.has (v)".
		local
			l_replacements: HASH_TABLE [STRING, STRING]
			l_opd_names: like operands_with_feature
			l_opd_name: STRING
			l_obj_id: STRING
			l_source_expr: EXPR_AS
			l_target_expr: EPA_AST_EXPRESSION
			l_target_expr_text: STRING
			l_value_text: STRING
			l_value: EPA_EXPRESSION_VALUE
			l_expr_value_pair: DS_HASH_TABLE [EPA_EXPRESSION_VALUE, EPA_EXPRESSION]
			l_source_state: EPA_STATE
			l_evaluator: EPA_EXPRESSION_EVALUATOR
			l_obj_equ_id: INTEGER
			l_obj_equ_tbl: HASH_TABLE [TUPLE [expr1: EPA_EXPRESSION; expr2: EPA_EXPRESSION], INTEGER]
			l_ref_equ_tbl: HASH_TABLE [TUPLE [expr1: EPA_EXPRESSION; expr2: EPA_EXPRESSION], INTEGER]
			l_ref_equ_id: INTEGER
			l_expr1, l_expr2: EPA_EXPRESSION
			l_equation1, l_equation2: EPA_EQUATION
			l_expr_equ_tbl: DS_HASH_TABLE [INTEGER, EPA_EXPRESSION] -- Keys are expressions, values are their object equivalent class id
		do
				-- Setup the name mapping from object ids in object pool to
				-- operand names. For example v_10 -> Current, v_2 -> v.
			create l_replacements.make (a_operand_map.count)
			l_replacements.compare_objects
			l_opd_names := operands_with_feature (a_feature)
			across a_operand_map as l_map loop
				l_opd_name := l_opd_names.item (l_map.key)
				l_obj_id := variable_name_prefix + l_map.item.out
				l_replacements.force (l_opd_name, l_obj_id)
			end

				-- Translate all expressions in `a_source', which mention object ids into
				-- operand-name format, which only mention operand names in the context of `a_feature'.
			l_obj_equ_id := 1
			l_ref_equ_id := 1
			create l_obj_equ_tbl.make (10)
			create l_ref_equ_tbl.make (10)
			create l_expr_equ_tbl.make (50)
			l_expr_equ_tbl.set_key_equality_tester (expression_equality_tester)
			create l_expr_value_pair.make (a_source.count)
			l_expr_value_pair.set_key_equality_tester (expression_equality_tester)
			across a_source as l_sources loop
				l_source_expr := ast_from_expression_text (l_sources.key)
				l_target_expr_text := expression_rewriter.ast_text (l_source_expr, l_replacements)
				create l_target_expr.make_with_text (a_class, a_feature, l_target_expr_text, a_class)
				if l_target_expr.type /= Void then
					l_value_text := l_sources.item
					l_value := expression_value_from_string (l_value_text)
					if l_value /= Void then
						l_expr_value_pair.force_last (l_value, l_target_expr)
					end
					if attached object_equality_comparison_result (l_target_expr, l_value) as l_obj_equ_result then
						if l_obj_equ_result.is_obj_equal then
							l_obj_equ_tbl.force ([l_obj_equ_result.expression1, l_obj_equ_result.expression2], l_obj_equ_id)
							l_obj_equ_id := l_obj_equ_id + 1
						end
					end
				end
			end

				-- Setup object-equality information.
			create l_source_state.make_from_expression_value_pairs (l_expr_value_pair, a_class, a_feature)
			across l_obj_equ_tbl as l_equals loop
				l_equation1 := l_source_state.item_with_expression (l_equals.item.expr1)
				if l_equation1 /= Void then
					l_equation2 := l_source_state.item_with_expression (l_equals.item.expr2)
					if l_equation2 /= Void then
						if
							attached {EPA_REFERENCE_VALUE} l_equation1.value as l_value1 and then
							attached {EPA_REFERENCE_VALUE} l_equation2.value as l_value2
						then
							l_value1.set_object_equivalent_class_id (l_equals.key)
							l_value2.set_object_equivalent_class_id (l_equals.key)
						end
					end
				end
			end

				-- Evaluate expressions from `a_target' based on `l_source_state'.
			create l_evaluator
			l_evaluator.set_context (l_source_state, l_source_state, a_class)
			create l_expr_value_pair.make (a_target.count)
			l_expr_value_pair.set_key_equality_tester (expression_equality_tester)
			across a_target as l_targets loop
				l_evaluator.evaluate (l_targets.item.ast)
				l_value := l_evaluator.last_value
				if l_value /= Void then
					l_expr_value_pair.force_last (l_value, l_targets.item)
				end
			end
			create Result.make_from_expression_value_pairs (l_expr_value_pair, a_class, a_feature)
		end

	object_equality_comparison_result (a_expr: EPA_EXPRESSION; a_value: EPA_EXPRESSION_VALUE): detachable TUPLE [expression1: EPA_EXPRESSION; expression2: EPA_EXPRESSION; is_obj_equal: BOOLEAN]
			-- If `a_expr' represents an object comparison between two expressions and `a_value' makes these
			-- two expression object-equal to each other, put those two involved expressions into
			-- `expression1' and `expression2', otherwise return Void.
		local
			l_equal_ast: BIN_TILDE_AS
			l_inequal_ast: BIN_NOT_TILDE_AS
			l_left, l_right: detachable EXPR_AS
			l_is_equal: BOOLEAN
			l_left_expr, l_right_expr: EPA_AST_EXPRESSION
		do
			if attached {BIN_TILDE_AS} a_expr.ast as l_equal then
				l_is_equal := True
				l_left := l_equal.left
				l_right := l_equal.right
			elseif attached {BIN_NOT_TILDE_AS} a_expr.ast as l_inequal then
				l_is_equal := False
				l_left := l_inequal.left
				l_right := l_inequal.right
			end
			if l_left /= Void and then l_right /= Void and then attached {EPA_BOOLEAN_VALUE} a_value as l_bool then
				if (l_is_equal and then l_bool.item) or (not l_is_equal and then not l_bool.item) then
					create l_left_expr.make_with_feature (a_expr.class_, a_expr.feature_, l_left, a_expr.written_class)
					create l_right_expr.make_with_feature (a_expr.class_, a_expr.feature_, l_right, a_expr.written_class)

					if l_is_equal and l_bool.item then
						Result := [l_left_expr, l_right_expr, True]
					elseif l_is_equal and not l_bool.item then
						Result := [l_left_expr, l_right_expr, False]
					elseif not l_is_equal and l_bool.item then
						Result := [l_left_expr, l_right_expr, False]
					else
						Result := [l_left_expr, l_right_expr, True]
					end

				end
			end
		end

	reference_equality_comparison_result (a_expr: EPA_EXPRESSION; a_value: EPA_EXPRESSION_VALUE): detachable TUPLE [expression1: EPA_EXPRESSION; expression2: EPA_EXPRESSION]
			-- If `a_expr' represents an reference comparison between two expressions and `a_value' makes these
			-- two expression reference-equal to each other, put those two involved expressions into
			-- `expression1' and `expression2', otherwise return Void.
		local
			l_equal_ast: BIN_EQ_AS
			l_inequal_ast: BIN_NE_AS
			l_left, l_right: detachable EXPR_AS
			l_is_equal: BOOLEAN
			l_left_expr, l_right_expr: EPA_AST_EXPRESSION
		do
			if attached {BIN_EQ_AS} a_expr.ast as l_equal then
				l_is_equal := True
				l_left := l_equal.left
				l_right := l_equal.right
			elseif attached {BIN_NE_AS} a_expr.ast as l_inequal then
				l_is_equal := False
				l_left := l_inequal.left
				l_right := l_inequal.right
			end
			if l_left /= Void and then l_right /= Void and then attached {EPA_BOOLEAN_VALUE} a_value as l_bool then
				if (l_is_equal and then l_bool.item) or (not l_is_equal and then not l_bool.item) then
					create l_left_expr.make_with_feature (a_expr.class_, a_expr.feature_, l_left, a_expr.written_class)
					create l_right_expr.make_with_feature (a_expr.class_, a_expr.feature_, l_right, a_expr.written_class)
					Result := [l_left_expr, l_right_expr]
				end
			end
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
