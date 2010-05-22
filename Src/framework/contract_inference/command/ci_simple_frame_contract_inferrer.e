note
	description: "Contract inferrer to propose simple frame conditions"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_SIMPLE_FRAME_CONTRACT_INFERRER

inherit
	CI_INFERRER

	EPA_SHARED_EQUALITY_TESTERS

	SHARED_WORKBENCH

	SHARED_TEXT_ITEMS

	SHARED_TYPES

feature -- Basic operations

	infer (a_data: LINKED_LIST [CI_TRANSITION_INFO])
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		do
			transition_data := a_data.twin
			setup_data_strutures
			find_suitable_funcions
		end

feature{NONE} -- Implementation

	transition_data: LINKED_LIST [CI_TRANSITION_INFO]
			-- Transition data from which contracts are inferred

	feature_under_test: FEATURE_I
			-- Feature under test

	class_under_test: CLASS_C
			-- Class where `feature_under_test' comes

	is_creation: BOOLEAN
			-- Is `featue_under_test' tested as a creation procedure?

	is_query: BOOLEAN
			-- Is `feature_under_test' a query?

feature{NONE} -- Implementation

	find_suitable_funcions
			-- Search `transition_data' to find suitable functions on which
			-- frame condition can be built.
			-- For a function whose target is an operand of the feature under test, if there are more than one object which are
			-- used as argument of that function in at least test case, that function is a candidate for frame condition.
		local
			l_operand_lower: INTEGER
			l_operand_upper: INTEGER
			l_operand_index: INTEGER
			l_suitable_functions: like suitable_functions_for_operand
		do
				-- Calculate indexes of the first and the last operand on which frame conditions can be inferred.
			if is_creation then
				l_operand_lower := 1
			else
				l_operand_lower := 0
			end
			l_operand_upper := feature_under_test.argument_count
			if is_query then
				l_operand_upper := l_operand_upper + 1
			end

				-- Iterate through all valid operands to see if frame conditions can be build on queries of that operand.
			create l_suitable_functions.make
			from
				l_operand_index := l_operand_lower
			until
				l_operand_index > l_operand_upper
			loop
				l_suitable_functions.append (suitable_functions_for_operand (l_operand_index))
				l_operand_index := l_operand_index + 1
			end

			from
				l_suitable_functions.start
			until
				l_suitable_functions.after
			loop
				io.put_string (l_suitable_functions.item_for_iteration.target_variable + ": ")
				io.put_string (l_suitable_functions.item_for_iteration.function.body + "%N")
				l_suitable_functions.forth
			end
		end

	suitable_functions_for_operand (a_operand_index: INTEGER): LINKED_LIST [TUPLE [function: EPA_FUNCTION; target_variable: STRING]]
			-- Search `transition_data' to find suitable functions on which
			-- frame condition can be built for operand with `a_operand_index'.
		local
			l_transitions: like transition_data
			l_data: CI_TRANSITION_INFO
			l_cursor: CURSOR
			l_operand_name: STRING
			l_tc_info: CI_TEST_CASE_INFO
			l_pre_valuation: DS_HASH_TABLE [EPA_FUNCTION_VALUATIONS, EPA_FUNCTION]
			l_func_cursor: DS_HASH_TABLE_CURSOR [EPA_FUNCTION_VALUATIONS, EPA_FUNCTION]
			l_done: BOOLEAN
			l_func_valuations: EPA_FUNCTION_VALUATIONS
			l_function: EPA_FUNCTION
		do
			create Result.make
			l_transitions := transition_data
			l_cursor := l_transitions.cursor
			from
				l_transitions.start
			until
				l_transitions.after
			loop
				l_data := l_transitions.item_for_iteration
				l_tc_info := l_data.test_case_info
				l_operand_name := l_tc_info.operand_map.item (a_operand_index)
				l_pre_valuation := l_data.pre_state_valuations

					-- Iterate through all pre-state functions to see if there is a query,
					-- whose target is `l_operand_name' and which has more than one object as
					-- argument.
				from
					l_func_cursor := l_pre_valuation.new_cursor
					l_func_cursor.start
				until
					l_func_cursor.after
				loop
						-- We are only interested in boolean queries with one argument,
						-- together with the target, the arity of that function
						-- should be 2.
					l_function := l_func_cursor.key
					if l_function.arity = 2 and then l_function.result_type.is_boolean then
						l_func_valuations := l_func_cursor.item.projected (1, value_set_for_variable (l_operand_name, l_data.transition))
						l_func_valuations := l_func_valuations.projected (l_func_valuations.function.arity + 1, true_value_set (l_data.transition))

						if l_func_valuations.map.count > 1 then
							Result.extend ([l_function, l_operand_name])
						end
					end
					l_func_cursor.forth
				end
				l_transitions.forth
			end
			l_transitions.go_to (l_cursor)
		end

	function_for_variable (a_variable_name: STRING; a_transition: SEM_TRANSITION): EPA_FUNCTION
			-- Function for variable named `a_variable_name' in the context of `a_transition'
		do
			create Result.make_from_expression (a_transition.variable_by_name (a_variable_name), a_transition.context)
		end

	value_set_for_variable (a_variable_name: STRING; a_transition: SEM_TRANSITION): DS_HASH_SET [EPA_FUNCTION]
			-- Value set containing the function for variable named `a_variable_name' in the context of `a_transition'
		do
			create Result.make (1)
			Result.set_equality_tester (function_equality_tester)
			Result.force_last (function_for_variable (a_variable_name, a_transition))
		end

	true_value_set (a_transition: SEM_TRANSITION): DS_HASH_SET [EPA_FUNCTION]
			-- Value set which only contains a True value
		local
			l_true_expr: EPA_AST_EXPRESSION
		do
			create Result.make (1)
			Result.set_equality_tester (function_equality_tester)
			create l_true_expr.make_with_text_and_type (a_transition.context.class_, a_transition.context.feature_, ti_true_keyword, a_transition.context.class_, boolean_type)
			Result.force_last (create {EPA_FUNCTION}.make_from_expression (l_true_expr, a_transition.context))
		end


	setup_data_strutures
			-- Setup data structures
		local
			l_tc_info: CI_TEST_CASE_INFO
		do
			l_tc_info := transition_data.first.test_case_info
			feature_under_test := l_tc_info.feature_under_test
			class_under_test := l_tc_info.class_under_test
			is_creation := l_tc_info.is_feature_under_test_creation
			is_query := l_tc_info.is_feature_under_test_query
		end

end
