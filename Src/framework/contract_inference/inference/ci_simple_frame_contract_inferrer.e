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
		do
				-- Initialize.
			transition_data := a_data.twin
			setup_data_strutures

				-- Find building blocks for frame conditions.
			l_suitable_functions := suitable_functions
			l_quantified_expressions := quantified_expressions (l_suitable_functions, True)
			l_quantifier_free_exressions := quantifier_free_expressions (l_quantified_expressions)

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
				l_operand_map.put (l_target_index, 2)
				l_predicate := quantified_function (l_function.argument_types, l_predicate_body)
				create l_quantified_expr.make (2, l_predicate, l_scope, True, l_operand_map)
				Result.force_last (l_quantified_expr)
				l_cursor.forth
			end

				-- Logging.
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
