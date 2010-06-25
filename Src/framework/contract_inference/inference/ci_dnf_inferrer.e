note
	description: "Inferrer to infer properties in DNF format."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_DNF_INFERRER

inherit
	CI_INFERRER

feature -- Basic operations

	infer (a_data: LINKED_LIST [CI_TEST_CASE_TRANSITION_INFO])
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		do
				-- We only select boolean typed expression in pre- and post-states.
			set_assertion_selection_fuction (
				agent (a_equation: EPA_EQUATION): BOOLEAN
					do
						Result := a_equation.expression.type.is_boolean
					end)

			transition_data := a_data
			setup_data_structures
			setup_operand_string_table
			logger.put_line_with_time_at_info_level ("Start inferring properties in DNF format.")

			setup_transition_table
			remove_missing_expressions_in_transition_table
			remove_duplications_in_anonymous_postconditions
			remove_invariant_expressions_in_transition_table
			log_found_component_expressions

			generate_candidate_properties
			log_candidate_properties ("Found the following candidate properties:")

			validate_candiate_properties
			log_candidate_properties ("Valid properties:")

				-- Setup results.
			create last_preconditions.make (10)
			last_preconditions.set_equality_tester (expression_equality_tester)
			create last_postconditions.make (10)
			last_postconditions.set_equality_tester (expression_equality_tester)
			generate_inferred_contracts
			setup_last_contracts
		end

feature{NONE} -- Implementation

	transition_table: DS_HASH_TABLE [SEM_FEATURE_CALL_TRANSITION, CI_TEST_CASE_TRANSITION_INFO]
			-- Table of interface transtions
			-- Key is test case, value is the interface transition adapted from the transition in that test case.
			-- The pre- and post-conditions of the interface transition only mentions operands in the feature.

	assertion_selection_fuction: FUNCTION [ANY, TUPLE [EPA_EQUATION], BOOLEAN]
			-- Action to select expressions in preconditions and postcondtions in transitions
			-- If this function returns True when applied with an equation, that equation will be selected.
			-- If this function is Void, all the expressions will be selected.

	anonymous_postconditions: EPA_HASH_SET [STRING]
			-- Anonymous forms of expressions that appear in postcondition in all test cases in transitions in `transition_table'.

	candidate_properties: EPA_HASH_SET [EPA_FUNCTION]
			-- Candidate properties

	operand_map_table: DS_HASH_TABLE [HASH_TABLE [INTEGER, INTEGER], EPA_FUNCTION]
			-- Operand map of properties in `candidate_properties'
			-- Key of the outer table is a candidate property in `candidate_properties'.
			-- Key of the inner table is 1-based argument index of the function,
			-- value of the inner table is the 0-based operand index in `feature_under_test'.

	operand_string_table: HASH_TABLE [STRING, INTEGER]
			-- Table from 0-based operand index to curly brace surrounded indexes for `feature_under_test'						

feature{NONE} -- Implementation

	set_assertion_selection_fuction (a_function: like assertion_selection_fuction)
			-- Set `assertion_selection_fuction' with `a_function'.
		do
			assertion_selection_fuction := a_function
		ensure
			assertion_selection_fuction_set: assertion_selection_fuction = a_function
		end

	setup_transition_table
			-- Setup `transition_table'.
		local
			l_transitions: like transition_table.new_cursor
			l_transition: SEM_FEATURE_CALL_TRANSITION
			l_selection_func: like assertion_selection_fuction
			l_assert_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_state: EPA_STATE
		do
			transition_table := interface_transitions_from_test_cases (transition_data)

				-- Iterate through all transitions, and keep only expressions of boolean type.			
			l_selection_func := assertion_selection_fuction
			from
				l_transitions := transition_table.new_cursor
				l_transitions.start
			until
				l_transitions.after
			loop
				l_transition := l_transitions.item
				across <<True, False>> as l_assertion_types loop
					from
						l_state := l_transition.assertions (l_assertion_types.item)
						l_assert_cursor := l_state.new_cursor
						l_assert_cursor.start
					until
						l_assert_cursor.after
					loop
						if l_selection_func = Void or else l_selection_func.item ([l_assert_cursor.item]) then
							l_assert_cursor.forth
						else
							l_state.remove (l_assert_cursor.item)
						end
					end
				end
				l_transitions.forth
			end
		end

	remove_missing_expressions_in_transition_table
			-- Remove expressions that are missing in some test cases from transitions in `transition_table'.
		local
			l_transition: SEM_FEATURE_CALL_TRANSITION
			l_post_state: EPA_STATE
			l_anony_post_asserts: EPA_HASH_SET [STRING]
			l_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_anony_expr: STRING
			l_tran_cursor: like transition_table.new_cursor
		do
			create l_anony_post_asserts.make (100)
			l_anony_post_asserts.set_equality_tester (string_equality_tester)
			l_transition := transition_table.first
			l_post_state := l_transition.postconditions

				-- Collect expressions that appear in postconditions of all test cases,
				-- store the anonymous form of those expressions in `l_anony_post_asserts'.
			from
				l_cursor := l_post_state.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_anony_expr := l_transition.anonymous_expression_text (l_cursor.item.expression)
				if transition_table.for_all (
					agent (a_tran: SEM_FEATURE_CALL_TRANSITION; a_anony_expr: STRING): BOOLEAN
						do
							Result := a_tran.assertion_by_anonymouse_expression_text (a_anony_expr, False) /= Void
						end (?, l_anony_expr))
				then
					l_anony_post_asserts.force_last (l_anony_expr)
				end
				l_cursor.forth
			end
			anonymous_postconditions := l_anony_post_asserts

				-- Remove post-state expressions which do not appear in all test cases.
			from
				l_tran_cursor := transition_table.new_cursor
				l_tran_cursor.start
			until
				l_tran_cursor.after
			loop
				l_transition := l_tran_cursor.item
				l_post_state := l_tran_cursor.item.postconditions
				from
					l_cursor := l_post_state.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					l_anony_expr := l_transition.anonymous_expression_text (l_cursor.item.expression)
					if not l_anony_post_asserts.has (l_anony_expr) then
						l_post_state.remove (l_cursor.item)
					else
						l_cursor.forth
					end
				end
				l_tran_cursor.forth
			end
		end

	remove_invariant_expressions_in_transition_table
			-- Remove expressions that are invariant in post-state in transitions in `transition_table'.
		local
			l_exprs: like anonymous_postconditions.new_cursor
			l_is_invariant: BOOLEAN
			l_value: detachable EPA_EXPRESSION_VALUE
			l_transitions: like transition_table.new_cursor
			l_anony_expr: STRING
			l_equation: EPA_EQUATION
		do
				-- Iterate through all expressions in `anonymous_postconditions' and check
				-- if it is an invariant in all transitions from `transition_table'.
				-- Remove all invariant expression from `anonymous_postconditions'.
			from
				l_exprs := anonymous_postconditions.new_cursor
				l_exprs.start
			until
				l_exprs.after
			loop
				l_anony_expr := l_exprs.item
				l_is_invariant := True
				from
					l_transitions := transition_table.new_cursor
					l_transitions.start
					l_value := l_transitions.item.postcondition_by_anonymous_expression_text (l_anony_expr).value
					l_transitions.forth
				until
					l_transitions.after or else not l_is_invariant
				loop
					l_equation := l_transitions.item.postcondition_by_anonymous_expression_text (l_anony_expr)
					l_is_invariant := l_value ~ l_equation.value
					if l_is_invariant then
						l_transitions.forth
					end
				end
				if transition_table.count > 1 and l_is_invariant then
					anonymous_postconditions.remove (l_anony_expr)
					from
						l_transitions := transition_table.new_cursor
						l_transitions.start
					until
						l_transitions.after
					loop
						l_equation := l_transitions.item.postcondition_by_anonymous_expression_text (l_anony_expr)
						l_transitions.item.postconditions.remove (l_equation)
						l_transitions.forth
					end
				else
					l_exprs.forth
				end
			end
		end

	remove_duplications_in_anonymous_postconditions
			-- Remove duplications in `anonymous_postconditions'
			-- If there is already an expression "a = b", then the expression "b = a" is duplicated, hence,
			-- it will be removed.
		local
			l_duplications: DS_HASH_SET [STRING]
			l_cursor: like anonymous_postconditions.new_cursor
			l_expr: STRING
			l_connector: STRING
			l_parts: LIST [STRING]
			l_new_expr: STRING
		do
			create l_duplications.make (anonymous_postconditions.count)
			l_duplications.set_equality_tester (string_equality_tester)

			from
				l_cursor := anonymous_postconditions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_expr := l_cursor.item

				fixme ("We removed expressions containing %"~%" to avoid too many uninteresting cases. 23.6.2010 Jasonw")
				if l_expr.has ('~') then
					l_duplications.force_last (l_expr)
				end
				if not l_duplications.has (l_expr) then
					across <<once " = ", once " ~ ", once " /= ", once " /~ ">> as l_connectors loop
						l_connector := l_connectors.item
						if l_expr.has_substring (l_connector) then
							l_parts := string_slices (l_expr, l_connector)
							if l_parts.count = 2 and then l_parts.first /~ l_parts.last then
								create l_new_expr.make (l_expr.count)
								l_new_expr.append (l_parts.last)
								l_new_expr.append (l_connector)
								l_new_expr.append (l_parts.first)
								l_duplications.force_last (l_new_expr)
							end
						end
					end
				end
				l_cursor.forth
			end
			l_duplications.do_all (agent anonymous_postconditions.remove)
		end

	generate_candidate_properties
			-- Generate candidate properties and store result in `candidate_properties'.
		local
			l_candidates: LINKED_LIST [EPA_HASH_SET [STRING]]
			l_property: like candidate_property
		do
			create candidate_properties.make (1000)
			candidate_properties.set_equality_tester (function_equality_tester)
			create operand_map_table.make (1000)
			operand_map_table.set_key_equality_tester (function_equality_tester)

			create l_candidates.make

				-- Generate all combinations.
			across 2 |..| config.max_dnf_clause as ks loop
				l_candidates.append (anonymous_postconditions.combinations (ks.item))
			end

				-- Generate a candicate for each combination.
			across l_candidates as l_cands loop
				l_property := candidate_property (l_cands.item, operand_string_table)
				candidate_properties.force_last (l_property.function)
				operand_map_table.force_last (l_property.operand_map, l_property.function)
			end
		end

	candidate_property (a_clauses: DS_HASH_SET [STRING]; a_operand_string_table: HASH_TABLE [STRING, INTEGER]): TUPLE [function: EPA_FUNCTION; operand_map: HASH_TABLE [INTEGER, INTEGER]]
			-- Candidate property cosisting all clauses in `a_clauses'
			-- `a_operand_string_table' is a table from 0-based operand index to curly brace surrounded indexes, for example 0 -> {0}.
			-- `function' is the function representation for the returned candidate property.
			-- `operand_map' is 1-based argument index in the function to 0-based operand index in the feature call.
		local
			l_func_text: STRING
			l_cursor: DS_HASH_SET_CURSOR [STRING]
			i, l_count: INTEGER
			l_opd_count: INTEGER
			l_opd_index: INTEGER
			l_arg_type_list: LINKED_LIST [TYPE_A]
			l_arg_types: ARRAY [TYPE_A]
			l_arg_domains: ARRAY [EPA_FUNCTION_DOMAIN]
			l_opd_types: like operand_types_with_feature
			l_operand_map: HASH_TABLE [INTEGER, INTEGER]
			l_arg_func: EPA_FUNCTION
			l_place_holder_tbl: HASH_TABLE [STRING, STRING]
			l_new_holder: STRING
			l_old_holder: STRING
			l_arg_index_holder: STRING
		do
				-- Construct text of the result property.
			create l_func_text.make (64)
			from
				i := 1
				l_count := a_clauses.count
				l_cursor := a_clauses.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_func_text.append_character ('(')
				l_func_text.append (l_cursor.item)
				l_func_text.append_character (')')
				if i < l_count then
					l_func_text.append (once " or ")
				end
				l_cursor.forth
				i := i + 1
			end

				-- Calculate the number of arguments of the result property.
			l_opd_types := operand_types_with_feature (feature_under_test, class_under_test)
			create l_operand_map.make (l_opd_types.count)
			create l_arg_type_list.make
			create l_place_holder_tbl.make (a_operand_string_table.count)
			l_place_holder_tbl.compare_objects
			i := 1
			across  0 |..|  (a_operand_string_table.count - 1) as l_operands loop
				l_opd_index := l_operands.item
				l_old_holder := a_operand_string_table.item (l_opd_index)
				if l_func_text.has_substring (l_old_holder) then
					l_arg_type_list.extend (l_opd_types.item (l_opd_index))
					l_operand_map.put (l_opd_index, i)
					l_arg_index_holder := curly_brace_surrounded_integer (i)
					l_new_holder := double_square_surrounded_integer (i)
					l_place_holder_tbl.extend (l_arg_index_holder, l_new_holder)
					l_func_text.replace_substring_all (l_old_holder, l_new_holder)
					i := i + 1
				end
			end

			across l_place_holder_tbl as l_holders loop
				l_func_text.replace_substring_all (l_holders.key, l_holders.item)
			end

				-- Construct the result function.
			create l_arg_types.make (1, l_arg_type_list.count)
			create l_arg_domains.make (1, l_arg_type_list.count)
			i := 1
			across l_arg_type_list as l_argument_types loop
				l_arg_types.put (l_argument_types.item, i)
				l_arg_domains.put (create {EPA_UNSPECIFIED_DOMAIN}, i)
				i := i + 1
			end
			Result := [create {EPA_FUNCTION}.make (l_arg_types, l_arg_domains, boolean_type, l_func_text), l_operand_map]
		end

	setup_operand_string_table
			-- Setup `operand_string_table'.
		local
			l_opd_count: INTEGER
		do
			l_opd_count := operand_count_of_feature (feature_under_test)
			create operand_string_table.make (l_opd_count)
			across 0 |..| (l_opd_count - 1) as l_operands loop
				operand_string_table.put (curly_brace_surrounded_integer (l_operands.item), l_operands.item)
			end
		end

	validate_candiate_properties
			-- Validate `candidate_properties', and remove all invaild ones.
		local
			l_test_case: CI_TEST_CASE_TRANSITION_INFO
			l_candidates: like candidate_properties.new_cursor
			l_candidate: EPA_FUNCTION
			l_evaluator: CI_EXPRESSION_EVALUATOR
			l_operand_map_tables: like operand_map_table
			l_operand_map: HASH_TABLE [INTEGER, INTEGER]
			l_resolved_function: EPA_FUNCTION
			l_is_valid: BOOLEAN
			l_candidate_properties: like candidate_properties
		do
			logger.put_line_with_time ("Start validating DNF properties.")
			logger.push_fine_level

				-- Iterate through all test cases, and validate all properties in `candidate_properties'
				-- in the context text of each test case.
			l_operand_map_tables := operand_map_table
			l_candidate_properties := candidate_properties
			create l_evaluator
			l_evaluator.set_is_ternary_logic_enabled (True)
			across transition_data as l_test_cases loop
				l_test_case := l_test_cases.item
				logger.put_line ("%TTest case " + l_test_case.test_case_info.test_case_class.name_in_upper)
				l_evaluator.set_transition_context (l_test_case)

					-- Iterate through all candidate properties and validate them
					-- one by one in the context of `l_test_case'.
				from
					l_candidates := candidate_properties.new_cursor
					l_candidates.start
				until
					l_candidates.after
				loop
					l_candidate := l_candidates.item
					l_operand_map := l_operand_map_tables.item (l_candidate)
					l_resolved_function := l_candidate.partially_evaluated_with_arguments (operand_function_table (l_operand_map, l_test_case))

					l_evaluator.evaluate (ast_from_expression_text (l_resolved_function.body))
					l_is_valid := not l_evaluator.has_error and then l_evaluator.last_value.is_boolean and then l_evaluator.last_value.as_boolean.is_true
					if l_is_valid then
						l_candidates.forth
					else
						l_candidate_properties.remove (l_candidate)
						l_operand_map_tables.remove (l_candidate)
					end

						-- Logging.					
					if logger.level_threshold >= {EPA_LOG_MANAGER}.fine_level then
						logger.put_string (once "%T%T")
						logger.put_string (l_resolved_function.body)
						logger.put_string (once " == ")
						if l_evaluator.has_error then
							logger.put_line (l_evaluator.error_reason)
						else
							logger.put_line (l_evaluator.last_value.out)
						end
					end
				end
			end

			logger.pop_level
		end

	generate_inferred_contracts
			-- Generate final inferred contracts from `candidate_properties' and
			-- store result in `last_postconditions'.
		local
			l_candidates: like candidate_properties.new_cursor
			l_operand_map_tables: like operand_map_table
			l_postconditions: like last_postconditions
			l_class: CLASS_C
			l_feature: FEATURE_I
		do
			l_operand_map_tables := operand_map_table
			l_postconditions := last_postconditions
			l_class := class_under_test
			l_feature := feature_under_test
			from
				l_candidates := candidate_properties.new_cursor
				l_candidates.start
			until
				l_candidates.after
			loop
				l_postconditions.force_last (expression_from_function (l_candidates.item, Void, l_operand_map_tables.item (l_candidates.item), l_class, l_feature))
				l_candidates.forth
			end
		end

feature{NONE} -- Logging

	log_found_component_expressions
			-- Log `anonymous_postconditions'.
		local
			l_cursor: like anonymous_postconditions.new_cursor
		do
			if logger.level_threshold >= {EPA_LOG_MANAGER}.fine_level then
				logger.push_fine_level
				logger.put_line_with_time ("Found the following component expressions:")
				from
					l_cursor := anonymous_postconditions.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					logger.put_line (once "%T" + l_cursor.item)
					l_cursor.forth
				end
				logger.pop_level
			end
		end

	log_candidate_properties (a_message: STRING)
			-- Log `candidate_properties' with staring message `a_message'.
		local
			l_cursor: like candidate_properties.new_cursor
		do
			if logger.level_threshold <= {EPA_LOG_MANAGER}.fine_level then
				logger.push_fine_level
				logger.put_line_with_time (a_message)
				from
					l_cursor := candidate_properties.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					logger.put_line (once "%T" + l_cursor.item.body)
					l_cursor.forth
				end
				logger.pop_level
			end
		end

end

