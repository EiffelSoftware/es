note
	description: "Utilities for contract inference"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_UTILITY

inherit
	CI_SHARED_EQUALITY_TESTERS

	KL_SHARED_STRING_EQUALITY_TESTER

	SEM_FIELD_NAMES

	EPA_UTILITY

feature -- Access

	interface_transitions_from_test_cases (a_test_cases: LINKED_LIST [CI_TEST_CASE_TRANSITION_INFO]): DS_HASH_TABLE [SEM_FEATURE_CALL_TRANSITION, CI_TEST_CASE_TRANSITION_INFO]
			-- Build interface transitions from `a_test_cases'.
			-- Result is a table of interface transtions
			-- Key is test case, value is the interface transition adapted from the transition in that test case.
			-- The pre- and post-conditions of the interface transition only mentions operands in the feature.
		local
			l_transition: SEM_FEATURE_CALL_TRANSITION
			l_test_case: CI_TEST_CASE_TRANSITION_INFO
			l_original_transition: SEM_FEATURE_CALL_TRANSITION
		do
			create Result.make (a_test_cases.count)
			Result.set_key_equality_tester (ci_test_case_transition_info_equality_tester)

				-- Iterate through all test cases in `transition_data',
				-- for each test case, build the corresponding interface transition.
			across a_test_cases as l_test_cases loop
				l_test_case := l_test_cases.item
				l_original_transition := l_test_case.transition
				create l_transition.make (
					l_test_case.test_case_info.class_under_test,
					l_test_case.test_case_info.feature_under_test,
					l_test_case.test_case_info.operand_map,
					l_test_case.transition.context,
					l_test_case.transition.is_creation)
				l_transition.set_uuid (l_original_transition.uuid)
				l_transition.set_preconditions_unsafe (l_original_transition.interface_preconditions.subtraction (l_original_transition.written_preconditions))
				l_transition.set_postconditions_unsafe (l_original_transition.interface_postconditions.subtraction (l_original_transition.written_postconditions))
				Result.force_last (l_transition, l_test_case)
			end
		end

	field_for_integer_bounded_functions (a_functions: DS_HASH_SET [CI_FUNCTION_WITH_INTEGER_DOMAIN]; a_pre_state: BOOLEAN): IR_FIELD
			-- Field for `a_function'
			-- `a_pre_state' inidcates prestate or poststate.
		local
			l_field_name: STRING
			l_cursor: DS_HASH_SET_CURSOR [CI_FUNCTION_WITH_INTEGER_DOMAIN]
			l_value: STRING
			l_func: CI_FUNCTION_WITH_INTEGER_DOMAIN
		do
			if a_pre_state then
				l_field_name := prestate_bounded_functions_field
			else
				l_field_name := poststate_bounded_functions_field
			end

			create l_value.make (256)
			from
				l_cursor := a_functions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_func := l_cursor.item
				l_value.append (l_func.target_operand_index.out)
				l_value.append_character (';')
				l_value.append (l_func.target_variable_name)
				l_value.append_character (';')
				l_value.append (l_func.function_name)
				l_value.append_character (';')
				l_value.append (l_func.lower_bound.out)
				l_value.append_character (';')
				l_value.append (l_func.upper_bound.out)
				l_value.append_character (';')
				l_value.append (l_func.lower_bound_expression)
				l_value.append_character (';')
				l_value.append (l_func.upper_bound_expression)

				if not l_cursor.is_last then
					l_value.append (triple_field_value_separator)
				end
				l_cursor.forth
			end
			create Result.make_as_string (l_field_name, l_value, default_boost_value)
		end

	bounded_functions_from_fields (a_transition: SEM_FEATURE_CALL_TRANSITION; a_fields: HASH_TABLE [IR_FIELD, STRING]): HASH_TABLE [DS_HASH_SET [CI_FUNCTION_WITH_INTEGER_DOMAIN], BOOLEAN]
			-- Bounded functions from `a_fields'
		local
			l_field_name: STRING
			l_parts: LIST [STRING]
			l_context: EPA_CONTEXT
			l_target_operand_index: INTEGER
			l_target_variable_name: STRING
			l_function_name: STRING
			l_lower_bound: INTEGER
			l_upper_bound: INTEGER
			l_lower_bound_expr: STRING
			l_upper_bound_expr: STRING
			l_func: CI_FUNCTION_WITH_INTEGER_DOMAIN
			l_func_set: DS_HASH_SET [CI_FUNCTION_WITH_INTEGER_DOMAIN]
		do
			l_context := a_transition.context

			create Result.make (2)
			create l_func_set.make (10)
			l_func_set.set_equality_tester (ci_function_with_integer_domain_partial_equality_tester)
			Result.force (l_func_set, True)
			create l_func_set.make (10)
			l_func_set.set_equality_tester (ci_function_with_integer_domain_partial_equality_tester)
			Result.force (l_func_set, False)

			across <<True, False>> as l_states loop
				l_func_set := Result.item (l_states.item)
				if l_states.item then
					l_field_name := prestate_bounded_functions_field
				else
					l_field_name := poststate_bounded_functions_field
				end

				a_fields.search (l_field_name)
				if a_fields.found then
					across string_slices (a_fields.found_item.value.text, triple_field_value_separator) as l_functions loop
						l_parts := l_functions.item.split (';')
						l_target_operand_index := l_parts.i_th (1).to_integer
						l_target_variable_name := l_parts.i_th (2)
						l_function_name := l_parts.i_th (3)
						l_lower_bound := l_parts.i_th (4).to_integer
						l_upper_bound := l_parts.i_th (5).to_integer
						l_lower_bound_expr := l_parts.i_th (6)
						l_upper_bound_expr := l_parts.i_th (7)
						create l_func.make (l_target_operand_index, l_target_variable_name, l_function_name, l_lower_bound, l_upper_bound, l_context, l_lower_bound_expr, l_upper_bound_expr)
						l_func_set.force_last (l_func)
					end
				end
			end
		end

end
