note
	description: "Class which infers contracts from given data"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CI_INFERRER

inherit
	EPA_SHARED_EQUALITY_TESTERS

	SHARED_WORKBENCH

	SHARED_TEXT_ITEMS

	SHARED_TYPES

	CI_SHARED_EQUALITY_TESTERS

	KL_SHARED_STRING_EQUALITY_TESTER

	EPA_UTILITY

	EPA_CONTRACT_EXTRACTOR

	EPA_STRING_UTILITY

feature -- Access

	logger: EPA_LOG_MANAGER
			-- Logger

	config: CI_CONFIG
			-- Configuration

feature -- Basic operations

	infer (a_data: LINKED_LIST [CI_TEST_CASE_TRANSITION_INFO])
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		deferred
		end

feature -- Setting

	set_logger (a_logger: like logger)
			-- Set `logger' with `a_logger'.
		do
			logger := a_logger
		ensure
			logger_set: logger = a_logger
		end

	set_config (a_config: like config)
			-- Set `config' with `a_config'.
		do
			config := a_config
		ensure
			config_set: config = a_config
		end

feature{NONE} -- Implementation

	function_for_variable (a_variable_name: STRING; a_transition: SEM_TRANSITION): EPA_FUNCTION
			-- Function representation of variable named `a_variable_name' in the context of `a_transition'
			-- The result function has 0-arity.
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

feature{NONE} -- Function selection

	suitable_functions (a_pre_state: BOOLEAN; a_suitable_function_agent: FUNCTION [ANY, TUPLE [a_function: EPA_FUNCTION; a_valuations: EPA_FUNCTION_VALUATIONS; a_target_variable_index: INTEGER; a_transition: SEM_TRANSITION], BOOLEAN]): DS_HASH_SET [TUPLE [function: EPA_FUNCTION; target_variable_index: INTEGER]]
			-- Functions that are suitable as frame condition building blocks.
			-- suitable functions must satisfy `a_suitable_function_agent'.
			-- `a_pre_state' indicates if the functions are selected from pre-state evaluations or post-state evaluations.
			-- in Result, `function' is that function, `target_variable_index' is the 0-based operand index (0 for qualified target, 1 for the first argument, and so on)
			--  for the target of that function.
			-- For a function whose target is an operand of the feature under test, if there are more than one object which are
			-- used as argument of that function in at least test case, that function is a candidate for frame condition.
			-- Store result in `suitable_functions'.
		do
			create Result.make (10)
			Result.set_equality_tester (function_candidate_equality_tester)

				-- Iterate through all valid operands to see if frame conditions can be build on queries of that operand.
			across operand_index_set (feature_under_test, is_creation implies not a_pre_state, is_query and not a_pre_state) as l_cursor loop
				suitable_functions_for_operand (l_cursor.item, a_pre_state, a_suitable_function_agent).do_all (agent Result.force_last)
			end
		end

	suitable_functions_for_operand (
		a_operand_index: INTEGER; a_pre_state: BOOLEAN;
		a_suitable_function_agent: FUNCTION [ANY, TUPLE [a_function: EPA_FUNCTION; a_valuations: EPA_FUNCTION_VALUATIONS; a_target_variable_index: INTEGER; a_transition: SEM_TRANSITION], BOOLEAN]): like suitable_functions
			-- Search `transition_data' to find suitable functions on which
			-- frame condition can be built for operand with `a_operand_index'.
			-- Result is a list of functions which are candidates for frame conditions.
			-- `function' is that function, `target_variable_index' is the 0-based operand index (0 for qualified target, 1 for the first argument, and so on)
			--  for the target of that function.
			-- `a_suitable_function_agent' is a function which decides if a function will be selected as suitable.
		local
			l_transition: SEM_TRANSITION
			l_valuations: DS_HASH_TABLE [EPA_FUNCTION_VALUATIONS, EPA_FUNCTION]
			l_func_cursor: DS_HASH_TABLE_CURSOR [EPA_FUNCTION_VALUATIONS, EPA_FUNCTION]
		do
			create Result.make (10)
			Result.set_equality_tester (function_candidate_equality_tester)

			across transition_data as l_cursor loop
				l_valuations := l_cursor.item.valuations [a_pre_state]
				l_transition := l_cursor.item.transition
					-- Iterate through all pre-state functions to see if there is a query,
					-- whose target is `l_operand_name' and which has more than one object as argument.
				from
					l_func_cursor := l_valuations.new_cursor
					l_func_cursor.start
				until
					l_func_cursor.after
				loop
					if a_suitable_function_agent.item ([l_func_cursor.key, l_func_cursor.item, a_operand_index, l_transition]) then
						Result.force_last ([l_func_cursor.key, a_operand_index])
					end
					l_func_cursor.forth
				end
			end
		end

	is_function_candidate_equal (a_candidate, b_candidate: TUPLE [function: EPA_FUNCTION; target_variable_index: INTEGER]): BOOLEAN
			-- Is `a_candidate' and `b_candidate' equal?
		do
			Result :=
				a_candidate.target_variable_index = b_candidate.target_variable_index and then
				a_candidate.function.body ~ b_candidate.function.body
--				function_equality_tester.test (a_candidate.function, b_candidate.function)
		end

	function_candidate_equality_tester: AGENT_BASED_EQUALITY_TESTER [TUPLE [function: EPA_FUNCTION; target_variable_index: INTEGER]]
			-- Equality tester for function candidates
		once
			create Result.make (agent is_function_candidate_equal)
		end

feature{NONE} -- Implementation

	transition_data: LINKED_LIST [CI_TEST_CASE_TRANSITION_INFO]
			-- Transition data from which contracts are inferred

	feature_under_test: FEATURE_I
			-- Feature under test

	class_under_test: CLASS_C
			-- Class where `feature_under_test' comes

	is_creation: BOOLEAN
			-- Is `featue_under_test' tested as a creation procedure?

	is_query: BOOLEAN
			-- Is `feature_under_test' a query?

	data_by_test_case_class_name (a_class_name: STRING): CI_TEST_CASE_TRANSITION_INFO
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

	setup_data_structures
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

end
