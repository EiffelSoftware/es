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

	infer (a_data: like data)
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		do
				-- We only select boolean typed expression in pre- and post-states.
			set_assertion_selection_fuction (
				agent (a_equation: EPA_EQUATION): BOOLEAN
					do
						Result := a_equation.expression.type.is_boolean
					end)

			data := a_data
			setup_data_structures
			operand_string_table := operand_string_table_for_feature (feature_under_test)
			logger.put_line_with_time_and_level ("Start inferring properties in DNF format.", {ELOG_CONSTANTS}.debug_level)

			setup_transition_table
			remove_missing_expressions_in_transition_table
			remove_duplications_in_anonymous_assertions
			remove_invariant_expressions_in_transition_table
			log_found_component_expressions

			generate_candidate_properties
			log_candidate_properties (candidate_properties.item (True), "Found the following candidate properties for preconditions:")
			log_candidate_properties (candidate_properties.item (False),"Found the following candidate properties for postconditions:")

			validate_candidate_properties (True,  candidate_properties.item (True), operand_map_tables.item(True), "Start validating DNF properties for preconditions.")
			log_candidate_properties (candidate_properties.item (True), "Valid preconditions:")
			validate_candidate_properties (False, candidate_properties.item (False), operand_map_tables.item(False), "Start validating DNF properties for postconditions.")
			log_candidate_properties (candidate_properties.item (False), "Valid postconditions:")

				-- Setup results.
			create last_preconditions.make (10)
			last_preconditions.set_equality_tester (expression_equality_tester)
			create last_postconditions.make (10)
			last_postconditions.set_equality_tester (expression_equality_tester)
			setup_inferred_contracts_in_last_preconditions  (candidate_properties.item (True),  operand_map_tables.item (True),  Void)
			setup_inferred_contracts_in_last_postconditions (candidate_properties.item (False), operand_map_tables.item (False), Void)
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

	anonymous_assertions: DS_HASH_TABLE [EPA_STRING_HASH_SET, BOOLEAN]
			-- Table mapping from boolean values ("true" for precondition and "false" for postcondition)
			-- to anonymous forms of expressions that appear in pre/postconditions of all test cases in transitions from `transition_table'.

	candidate_properties: DS_HASH_TABLE [EPA_HASH_SET [EPA_FUNCTION], BOOLEAN]
			-- Table mapping from boolean values ("true" for precondition and "false" for postcondition)
			-- to set of functions as candidate invariant properties.

	operand_map_tables: DS_HASH_TABLE [DS_HASH_TABLE [HASH_TABLE [INTEGER, INTEGER], EPA_FUNCTION], BOOLEAN]
			-- Table mapping from boolean values ("true" for precondition and "false" for postcondition)
			-- to operand maps of properties in `candidate_properties'.
			-- Key of 1-st layer table is a boolean value designating pre- or postcondition;
			-- Key of 2-nd layer table is a candidate property in `candidate_properties'.
			-- Key of 3-rd layer table is 1-based argument index of the function,
			-- Val of 3-rd layer table is the 0-based operand index in `feature_under_test'.

--	anonymous_postconditions: EPA_STRING_HASH_SET
--			-- Anonymous forms of expressions that appear in postcondition in all test cases in transitions in `transition_table'.

--	candidate_properties: EPA_HASH_SET [EPA_FUNCTION]
--			-- Candidate properties

--	operand_map_table: DS_HASH_TABLE [HASH_TABLE [INTEGER, INTEGER], EPA_FUNCTION]
--			-- Operand map of properties in `candidate_properties'
--			-- Key of the outer table is a candidate property in `candidate_properties'.
--			-- Key of the inner table is 1-based argument index of the function,
--			-- value of the inner table is the 0-based operand index in `feature_under_test'.

	operand_string_table: HASH_TABLE [STRING, INTEGER]
			-- Table from 0-based operand index to curly brace surrounded indexes for `feature_under_test'	
			-- 0 -> {0}, 1 -> {1} and so on.					

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
			l_old_tran: SEM_FEATURE_CALL_TRANSITION
			l_assertion_type: BOOLEAN
			l_selection_func: like assertion_selection_fuction
			l_assert_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_state: EPA_STATE
			l_cursor: like data.interface_transitions.new_cursor
			l_tc: CI_TEST_CASE_TRANSITION_INFO
		do
			create transition_table.make (data.transition_data.count)
			transition_table.set_key_equality_tester (ci_test_case_transition_info_equality_tester)
			from
				l_cursor := data.interface_transitions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_old_tran := l_cursor.item
				l_tc := l_cursor.key
				create l_transition.make (
					l_tc.test_case_info.class_under_test,
					l_tc.test_case_info.feature_under_test,
					l_tc.test_case_info.operand_map,
					l_tc.transition.context,
					l_tc.transition.is_creation)
				l_transition.set_preconditions_unsafe (l_old_tran.preconditions)
				l_transition.set_postconditions_unsafe (l_old_tran.postconditions)
				transition_table.force_last (l_transition, l_tc)
				l_cursor.forth
			end

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
			l_state: EPA_STATE
			l_anony_asserts: EPA_STRING_HASH_SET
			l_anony_expr: STRING
			l_assertion_type: BOOLEAN

			l_post_state: EPA_STATE
			l_anony_post_asserts: EPA_STRING_HASH_SET
			l_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_tran_cursor: like transition_table.new_cursor
		do
			create anonymous_assertions.make (2)
--			create l_anony_post_asserts.make_equal (100)

			across <<True, False>> as l_assertion_type_cursor loop
				l_assertion_type := l_assertion_type_cursor.item
				create l_anony_asserts.make_equal (100)
				l_transition := transition_table.first
				l_state := l_transition.assertions (l_assertion_type)
--				l_post_state := l_transition.postconditions

					-- Collect expressions that appear in assertions of all test cases,
					-- store the anonymous form of those expressions in `l_anony_post_asserts'.
				from
					l_cursor := l_state.new_cursor
--					l_cursor := l_post_state.new_cursor
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
						l_anony_asserts.force_last (l_anony_expr)
--						l_anony_post_asserts.force_last (l_anony_expr)
					end
					l_cursor.forth
				end
				anonymous_assertions.force (l_anony_asserts, l_assertion_type)
--				anonymous_postconditions := l_anony_post_asserts

					-- Remove expressions which do not appear in all test cases.
				from
					l_tran_cursor := transition_table.new_cursor
					l_tran_cursor.start
				until
					l_tran_cursor.after
				loop
					l_transition := l_tran_cursor.item
					l_state := l_tran_cursor.item.assertions (l_assertion_type)
--					l_post_state := l_tran_cursor.item.postconditions
					from
						l_cursor := l_state.new_cursor
--						l_cursor := l_post_state.new_cursor
						l_cursor.start
					until
						l_cursor.after
					loop
						l_anony_expr := l_transition.anonymous_expression_text (l_cursor.item.expression)
						if not l_anony_asserts.has (l_anony_expr) then
--						if not l_anony_post_asserts.has (l_anony_expr) then
							l_state.remove (l_cursor.item)
--							l_post_state.remove (l_cursor.item)
						else
							l_cursor.forth
						end
					end
					l_tran_cursor.forth
				end
			end
		end

	remove_invariant_expressions_in_transition_table
			-- Remove expressions that are invariant in transitions in `transition_table'.
		local
			l_exprs: DS_HASH_SET_CURSOR [STRING]
			l_assertion_type: BOOLEAN
			l_is_invariant: BOOLEAN
			l_value: detachable EPA_EXPRESSION_VALUE
			l_transitions: like transition_table.new_cursor
			l_anony_expr: STRING
			l_equation: EPA_EQUATION
		do
			across <<True, False>> as l_assertion_type_cursor loop
				l_assertion_type := l_assertion_type_cursor.item
					-- Iterate through all expressions in `anonymous_postconditions' and check
					-- if it is an invariant in all transitions from `transition_table'.
					-- Remove all invariant expression from `anonymous_postconditions'.
				from
					l_exprs := anonymous_assertions.item (l_assertion_type).new_cursor
--					l_exprs := anonymous_postconditions.new_cursor
					l_exprs.start
				until
					l_exprs.after
				loop
					l_anony_expr := l_exprs.item
					l_is_invariant := True
					from
						l_transitions := transition_table.new_cursor
						l_transitions.start
						l_value := l_transitions.item.assertion_by_anonymouse_expression_text (l_anony_expr, l_assertion_type).value
--						l_value := l_transitions.item.postcondition_by_anonymous_expression_text (l_anony_expr).value
						l_transitions.forth
					until
						l_transitions.after or else not l_is_invariant
					loop
						l_equation := l_transitions.item.assertion_by_anonymouse_expression_text (l_anony_expr, l_assertion_type)
--						l_equation := l_transitions.item.postcondition_by_anonymous_expression_text (l_anony_expr)
						l_is_invariant := l_value ~ l_equation.value
						if l_is_invariant then
							l_transitions.forth
						end
					end
					if transition_table.count > 1 and l_is_invariant then
						anonymous_assertions.item (l_assertion_type).remove (l_anony_expr)
--						anonymous_postconditions.remove (l_anony_expr)
						from
							l_transitions := transition_table.new_cursor
							l_transitions.start
						until
							l_transitions.after
						loop
							l_equation := l_transitions.item.assertion_by_anonymouse_expression_text (l_anony_expr, l_assertion_type)
--							l_equation := l_transitions.item.postcondition_by_anonymous_expression_text (l_anony_expr)
							l_transitions.item.assertions (l_assertion_type).remove (l_equation)
--							l_transitions.item.postconditions.remove (l_equation)
							l_transitions.forth
						end
					else
						l_exprs.forth
					end
				end
			end
		end

	remove_duplications_in_anonymous_assertions
--	remove_duplications_in_anonymous_postconditions
			-- Remove duplications in `anonymous_assertions'
			-- If there is already an expression "a = b", then the expression "b = a" is duplicated, hence,
			-- it will be removed.
		local
			l_anonymous: EPA_STRING_HASH_SET
			l_duplications: DS_HASH_SET [STRING]
			l_cursor: DS_HASH_SET_CURSOR [STRING]
			l_assertion_type: BOOLEAN
			l_expr: STRING
			l_connector: STRING
			l_parts: LIST [STRING]
			l_new_expr: STRING
		do
			across <<True, False>> as l_assertion_type_cursor loop
				l_assertion_type := l_assertion_type_cursor.item
				l_anonymous := anonymous_assertions.item (l_assertion_type)
				create l_duplications.make (l_anonymous.count)
				l_duplications.set_equality_tester (string_equality_tester)

				from
					l_cursor := l_anonymous.new_cursor
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
				l_duplications.do_all (agent l_anonymous.remove)
			end
		end

	generate_candidate_properties
			-- Generate candidate properties and store result in `candidate_properties'.
		local
			l_candidates: LINKED_LIST [EPA_STRING_HASH_SET]
			l_property: like candidate_property
			l_assertion_type: BOOLEAN
			l_candidate_properties: EPA_HASH_SET [EPA_FUNCTION]
			l_operand_map_table: DS_HASH_TABLE [HASH_TABLE [INTEGER, INTEGER], EPA_FUNCTION]
		do
			create candidate_properties.make (2)
			create operand_map_tables.make (2)

			across <<True, False>> as l_assertion_type_cursor loop
				l_assertion_type := l_assertion_type_cursor.item
				create l_candidate_properties.make (1000)
				l_candidate_properties.set_equality_tester (function_equality_tester)
				candidate_properties.force (l_candidate_properties, l_assertion_type)
				create l_operand_map_table.make (1000)
				l_operand_map_table.set_key_equality_tester (function_equality_tester)
				operand_map_tables.force (l_operand_map_table, l_assertion_type)

				create l_candidates.make

					-- Generate all combinations.
				across 2 |..| config.max_dnf_clause as ks loop
					l_candidates.append (anonymous_assertions.item (l_assertion_type).combinations (ks.item))
				end

					-- Generate a candicate for each combination.
				across l_candidates as l_cands loop
					l_property := candidate_property (l_cands.item, "or", operand_string_table)
					l_candidate_properties.force_last (l_property.function)
					l_operand_map_table.force_last (l_property.operand_map, l_property.function)
				end
			end
		end

feature{NONE} -- Logging

	log_found_component_expressions
			-- Log `anonymous_postconditions'.
		local
			l_assertion_type: BOOLEAN
			l_cursor: DS_HASH_SET_CURSOR [STRING]
		do
			logger.push_level ({ELOG_CONSTANTS}.debug_level)
			logger.put_line_with_time ("Found the following component expressions:")
			across <<True, False>> as l_assertion_type_cursor loop
				l_assertion_type := l_assertion_type_cursor.item
				if l_assertion_type then
					logger.put_line ("%T=== Precondition ===")
				else
					logger.put_line ("%T=== Postcondition ===")
				end

				from
					l_cursor := anonymous_assertions.item (l_assertion_type).new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					logger.put_line (once "%T" + l_cursor.item)
					l_cursor.forth
				end
			end
			logger.pop_level
		end

end

