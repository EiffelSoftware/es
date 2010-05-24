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

	CI_SHARED_EQUALITY_TESTERS

	KL_SHARED_STRING_EQUALITY_TESTER

	EPA_UTILITY

feature -- Access

	logger: EPA_LOG_MANAGER
			-- Logger

feature -- Basic operations

	infer (a_data: LINKED_LIST [CI_TRANSITION_INFO])
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		local
			l_suitable_functions: like suitable_functions
			l_quantified_expressions: like quantified_expressions
			l_quantifier_free_exressions: like quantifier_free_expressions
			l_valid_frame_properties: like valid_frame_properties
		do
				-- Initialize.
			transition_data := a_data.twin
			setup_data_strutures

				-- Find building blocks for frame conditions.
			l_suitable_functions := suitable_functions
			l_quantified_expressions := quantified_expressions (l_suitable_functions, True)
			l_quantifier_free_exressions := quantifier_free_expressions (l_quantified_expressions)
			l_valid_frame_properties := valid_frame_properties (l_quantifier_free_exressions)
		end

	set_logger (a_logger: like logger)
			-- Set `logger' with `a_logger'.
		do
			logger := a_logger
		ensure
			logger_set: logger = a_logger
		end

	quantifier_free_expressions (a_quantifier_expressions: like quantified_expressions): DS_HASH_TABLE [DS_HASH_TABLE [DS_HASH_SET [EPA_FUNCTION], CI_QUANTIFIED_EXPRESSION], STRING]
			-- Quantifier expressions from `a_quantifier_expressions'
			-- Result is hash table, key is test case name, value is a table of quantifier-free expression resolved in that test case.	
			-- Key of the inner hash table is a quantified-expression, value is a set of quantifier-free expression resovled in the test case.
		local
			l_cursor: DS_HASH_SET_CURSOR [CI_QUANTIFIED_EXPRESSION]
			l_test_cases: like transition_data
			l_tc_cursor: CURSOR
			l_qf_exprs: DS_HASH_SET [EPA_FUNCTION]
			l_qf_tbl: DS_HASH_TABLE [DS_HASH_SET [EPA_FUNCTION], CI_QUANTIFIED_EXPRESSION]
		do
			create Result.make (10)
			Result.set_key_equality_tester (string_equality_tester)

			l_test_cases := transition_data
			l_tc_cursor := l_test_cases.cursor
			from
				l_test_cases.start
			until
				l_test_cases.after
			loop
				create l_qf_tbl.make (10)
				l_qf_tbl.set_key_equality_tester (ci_quantified_expression_equality_tester)
				Result.force_last (l_qf_tbl, l_test_cases.item_for_iteration.test_case_info.test_case_class.name_in_upper)

				from
					l_cursor := a_quantifier_expressions.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					l_qf_exprs := l_cursor.item.quantifier_free_functions (l_test_cases.item_for_iteration)
					l_qf_tbl.force_last (l_qf_exprs, l_cursor.item)
					l_cursor.forth
				end
				l_test_cases.forth
			end
			l_test_cases.go_to (l_tc_cursor)

				-- Logging.
			logger.push_level ({EPA_LOG_MANAGER}.fine_level)
			logger.put_line_with_time (once "Quantifier-free expressions for candidate frame properties:")
			from
				Result.start
			until
				Result.after
			loop
				logger.put_string (once "Test case: ")
				logger.put_line (Result.key_for_iteration)
				l_qf_tbl := Result.item_for_iteration
				from
					l_qf_tbl.start
				until
					l_qf_tbl.after
				loop
					logger.put_string (once "%T")
					logger.put_line (l_qf_tbl.key_for_iteration.debug_output)
					from
						l_qf_tbl.item_for_iteration.start
					until
						l_qf_tbl.item_for_iteration.after
					loop
						logger.put_string (once "%T%T")
						logger.put_line (l_qf_tbl.item_for_iteration.item_for_iteration.body)
						l_qf_tbl.item_for_iteration.forth
					end
					l_qf_tbl.forth
				end
				logger.put_line (once "")
				Result.forth
			end
			logger.pop_level
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

	data_by_test_case_class_name (a_class_name: STRING): CI_TRANSITION_INFO
			-- Transition information from test case whose class name is `a_class_name'
		local
			l_transitions: like transition_data
			l_cursor: CURSOR
		do
			l_transitions := transition_data
			l_cursor := l_transitions.cursor
			from
				l_transitions.start
			until
				l_transitions.after or else Result /= Void
			loop
				if l_transitions.item_for_iteration.test_case_info.test_case_class.name_in_upper ~ a_class_name then
					Result := l_transitions.item_for_iteration
				else
					l_transitions.forth
				end
			end
			l_transitions.go_to (l_cursor)
		end

feature{NONE} -- Implementation

	suitable_functions: DS_HASH_SET [TUPLE [function: EPA_FUNCTION; target_variable_index: INTEGER]]
			-- Functions that are suitable as frame condition building blocks found by last `find_suitable_functions'.
			-- `function' is that function, `target_variable_index' is the 0-based operand index (0 for qualified target, 1 for the first argument, and so on)
			--  for the target of that function.
			-- For a function whose target is an operand of the feature under test, if there are more than one object which are
			-- used as argument of that function in at least test case, that function is a candidate for frame condition.
			-- Store result in `suitable_functions'
		local
			l_operand_lower: INTEGER
			l_operand_upper: INTEGER
			l_operand_index: INTEGER
			l_suitable_functions: like suitable_functions
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
			create Result.make (10)
			Result.set_equality_tester (function_candidate_equality_tester)

			from
				l_operand_index := l_operand_lower
			until
				l_operand_index > l_operand_upper
			loop
				suitable_functions_for_operand (l_operand_index).do_all (agent Result.force_last)
				l_operand_index := l_operand_index + 1
			end
		end

	suitable_functions_for_operand (a_operand_index: INTEGER): like suitable_functions
			-- Search `transition_data' to find suitable functions on which
			-- frame condition can be built for operand with `a_operand_index'.
			-- Result is a list of functions which are candidates for frame conditions.
			-- `function' is that function, `target_variable_index' is the 0-based operand index (0 for qualified target, 1 for the first argument, and so on)
			--  for the target of that function.
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
			create Result.make (10)
			Result.set_equality_tester (function_candidate_equality_tester)

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
					if
						l_function.arity = 2 and then 						 -- Function should have one argument.
						not l_function.argument_type (1).is_integer and then -- Function argument shoult not of type integer, because we handle integer argument differently.
						l_function.result_type.is_boolean  					 -- Function should return Boolean value.
					then
						l_func_valuations := l_func_cursor.item.projected (1, value_set_for_variable (l_operand_name, l_data.transition))
						l_func_valuations := l_func_valuations.projected (l_func_valuations.function.arity + 1, true_value_set (l_data.transition))

						if l_func_valuations.map.count > 1 then
							Result.force_last ([l_function, a_operand_index])
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
			create Result.make_from_expression (a_transition.variable_by_name (a_variable_name))
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
			Result.force_last (create {EPA_FUNCTION}.make_from_expression (l_true_expr))
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

	quantified_expressions (a_suitable_functions: like suitable_functions; a_pre_state: BOOLEAN): DS_HASH_SET [CI_QUANTIFIED_EXPRESSION]
			-- Quantified expression representing simple frame properties from `a_suitable_functions'
		local
			l_cursor: DS_HASH_SET_CURSOR [TUPLE [function: EPA_FUNCTION; target_variable_index: INTEGER]]
			l_scope: CI_FUNCTION_DOMAIN_QUANTIFIED_SCOPE
			l_predicate_body: STRING
			l_function: EPA_FUNCTION
			l_target_index: INTEGER
			l_quantified_expr: CI_QUANTIFIED_EXPRESSION
			l_operand_map: HASH_TABLE [INTEGER, INTEGER]
			l_predicate: EPA_FUNCTION
		do
			create Result.make (10)
			Result.set_equality_tester (ci_quantified_expression_equality_tester)

			from
				l_cursor := a_suitable_functions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_function := l_cursor.item.function
				l_target_index := l_cursor.item.target_variable_index
				create l_scope.make (l_function, 2, a_pre_state)
				create l_predicate_body.make (64)

				l_predicate_body.append (once "old ")
				l_predicate_body.append (l_function.body)
				l_predicate_body.append (once " implies ")
				l_predicate_body.append (l_function.body)

				create l_operand_map.make (1)
				l_operand_map.put (l_target_index, 1)
				l_predicate := quantified_function (l_function.argument_types, l_predicate_body)
				create l_quantified_expr.make (2, l_predicate, l_scope, True, l_operand_map)
				Result.force_last (l_quantified_expr)
				l_cursor.forth
			end

				-- Logging.
			logger.push_level ({EPA_LOG_MANAGER}.fine_level)
			logger.put_line_with_time (once "Candidate frame properties:")
			from
				Result.start
			until
				Result.after
			loop
				logger.put_line (Result.item_for_iteration.debug_output)
				logger.put_line (once "")
				Result.forth
			end
			logger.pop_level
		end

	quantified_function (a_argument_types: ARRAY [TYPE_A]; a_body: STRING): EPA_FUNCTION
			-- Quantified function
		local
			l_arg_domain: ARRAY [EPA_FUNCTION_DOMAIN]
			i: INTEGER
			c: INTEGER
		do
			c := a_argument_types.count
			create l_arg_domain.make (1, c)
			from
				i := 1
			until
				i > c
			loop
				l_arg_domain.put (create {EPA_UNSPECIFIED_DOMAIN}, i)
				i := i + 1
			end

			create Result.make (a_argument_types, l_arg_domain, boolean_type, a_body)
		end

	fake_nullary_function (a_result_type: TYPE_A; a_body: STRING): EPA_FUNCTION
			-- Fake nullary function of type `a_result_type' and body `a_body'
		do
			create Result.make (<<>>, <<>>, a_result_type, a_body)
		end

	valid_frame_properties (a_expressions: like quantifier_free_expressions): DS_HASH_SET [CI_QUANTIFIED_EXPRESSION]
			-- Set of valid frame properties from `a_expressions'
			-- A frame property is valid if it evaluates to True in all test cases.
		local
			l_tc_cursor: DS_HASH_TABLE_CURSOR [DS_HASH_TABLE [DS_HASH_SET [EPA_FUNCTION], CI_QUANTIFIED_EXPRESSION], STRING_8]
			l_transition_info: CI_TRANSITION_INFO
			l_qexpr_cursor: DS_HASH_TABLE_CURSOR [DS_HASH_SET [EPA_FUNCTION], CI_QUANTIFIED_EXPRESSION]
			l_expr_cursor: DS_HASH_SET_CURSOR [EPA_FUNCTION]
			l_evaluator: CI_EXPRESSION_EVALUATOR
			l_function: EPA_FUNCTION
			l_quantified_function: CI_QUANTIFIED_EXPRESSION
			l_arguments: HASH_TABLE [EPA_FUNCTION, INTEGER]
			l_valid_candidate_frame_properties: DS_HASH_SET [CI_QUANTIFIED_EXPRESSION]
			l_all_qfree_true: BOOLEAN
			l_valid_status: DS_HASH_TABLE [BOOLEAN, CI_QUANTIFIED_EXPRESSION]
		do
			create l_valid_status.make (10)
			l_valid_status.set_key_equality_tester (ci_quantified_expression_equality_tester)

			create Result.make (5)
			Result.set_equality_tester (ci_quantified_expression_equality_tester)

			create l_evaluator

				-- Logging.
			logger.push_level ({EPA_LOG_MANAGER}.fine_level)
			logger.put_line_with_time ("Start evaluating quantifier-free expressions.")

				-- Iterate through all test cases.
			from
				l_tc_cursor := a_expressions.new_cursor
				l_tc_cursor.start
			until
				l_tc_cursor.after
			loop
				logger.put_string ("Test case: ")
				logger.put_line (l_tc_cursor.key)

					-- Iterate through all quantified expressions in a test case.
				l_transition_info := data_by_test_case_class_name (l_tc_cursor.key)
				from
					l_qexpr_cursor := l_tc_cursor.item.new_cursor
					l_qexpr_cursor.start
				until
					l_qexpr_cursor.after
				loop
						-- Iterate through all quantifier-free expressions for a quantified expression.
					l_quantified_function := l_qexpr_cursor.key
						-- We only process new quantified expressions or quantified expressions that are valid so far.
						-- Quantified expressions that are known to be invalid are ingored immediately.
					if not l_valid_status.has (l_quantified_function) or else l_valid_status.item (l_quantified_function) then
							-- Assume a quantified expression is valid.
						if not l_valid_status.has (l_quantified_function) then
							l_valid_status.force_last (True, l_quantified_function)
							Result.force_last (l_quantified_function)
						end

						from
						l_all_qfree_true := True
							l_expr_cursor := l_qexpr_cursor.item.new_cursor
							l_expr_cursor.start
						until
							l_expr_cursor.after or else not l_all_qfree_true
						loop
							l_function := l_expr_cursor.item.partially_evaluated_with_arguments (operand_function_table (l_quantified_function, l_transition_info))
							l_evaluator.evaluate (ast_from_expression_text (l_function.body), l_transition_info)
							l_all_qfree_true := not l_evaluator.has_error and then l_evaluator.last_value.is_boolean and then l_evaluator.last_value.as_boolean.is_true
								-- A quantified expression is evaluated to False or there is an error during evaluation, remove it from candidate set.
							if not l_all_qfree_true then
								l_valid_status.replace (False, l_quantified_function)
								Result.remove (l_quantified_function)
							end

								-- Logging.
							logger.put_string (once "%T")
							logger.put_string (l_function.body)
							logger.put_string (once " == ")
							if l_evaluator.has_error then
								logger.put_line (l_evaluator.error_reason)
							else
								logger.put_line (l_evaluator.last_value.out)
							end

							l_expr_cursor.forth
						end
						logger.put_line (once "")
					end
					l_qexpr_cursor.forth
				end
				l_tc_cursor.forth
			end

				-- Logging.
			logger.pop_level
			logger.put_line (once "Valid frame properties:")
			from
				Result.start
			until
				Result.after
			loop
				logger.put_string (once "%T")
				logger.put_line (Result.item_for_iteration.debug_output)
				Result.forth
			end
		end

	operand_function_table (a_quantified_expression: CI_QUANTIFIED_EXPRESSION; a_transition_data: CI_TRANSITION_INFO): HASH_TABLE [EPA_FUNCTION, INTEGER]
			-- A table from function operand index to expressions representing that operand in the context of `a_transition_data'
		local
			l_cursor: CURSOR
			l_operand_map: HASH_TABLE [INTEGER, INTEGER]
			l_transition: SEM_TRANSITION
			l_arg_func: EPA_FUNCTION
		do
			create Result.make (5)
			l_transition := a_transition_data.transition
			l_operand_map := a_quantified_expression.operand_map
			l_cursor := l_operand_map.cursor
			from
				l_operand_map.start
			until
				l_operand_map.after
			loop
				create l_arg_func.make_from_expression (l_transition.reversed_variable_position.item (l_operand_map.item_for_iteration))
				Result.put (l_arg_func, l_operand_map.key_for_iteration)
				l_operand_map.forth
			end
			l_operand_map.go_to (l_cursor)
		end

feature{NONE} -- Implementation

	is_function_candidate_equal (a_candidate, b_candidate: TUPLE [function: EPA_FUNCTION; target_variable_index: INTEGER]): BOOLEAN
			-- Is `a_candidate' and `b_candidate' equal?
		do
			Result :=
				a_candidate.target_variable_index = b_candidate.target_variable_index and then
				function_equality_tester.test (a_candidate.function, b_candidate.function)
		end

	function_candidate_equality_tester: AGENT_BASED_EQUALITY_TESTER [TUPLE [function: EPA_FUNCTION; target_variable_index: INTEGER]]
			-- Equality tester for function candidates
		once
			create Result.make (agent is_function_candidate_equal)
		end

end
