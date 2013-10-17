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

	KL_SHARED_STRING_EQUALITY_TESTER

	EPA_UTILITY

	EPA_CONTRACT_EXTRACTOR

	EPA_STRING_UTILITY

	CI_UTILITY

feature -- Access

	logger: ELOG_LOG_MANAGER
			-- Logger

	config: CI_CONFIG
			-- Configuration

	data: CI_TEST_CASE_DATA
			-- Data collected from test case execution

feature -- Access

	last_preconditions: DS_HASH_SET [EPA_EXPRESSION]
			-- Precconditions inferred by last invocation to `infer'

	last_postconditions: DS_HASH_SET [EPA_EXPRESSION]
			-- Postconditions inferred by last invocation to `infer'

	last_contracts: HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION], BOOLEAN]
			-- Contracts inferred by last invocation to `infer'.
			-- Key is a boolean indicating precondition or postcondition,
			-- value is the set of assertions of that kind.

	last_precondition_candidates: DS_HASH_SET [EPA_EXPRESSION]
			-- Set of expressions as candidates for the precondition.
		do
		ensure
			result_attached: Result /= Void
		end

feature -- Status report

	is_arff_needed: BOOLEAN
			-- Is ARFF data needed?
		do
		end

	is_expression_value_map_needed: BOOLEAN
			-- Is expression to its value set mapping needed?
		do
		end

feature -- Basic operations

	infer (a_data: like data)
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		deferred
		end

	program_states_at_entry (a_data: like data; a_abstraction: DS_HASH_SET [EPA_EXPRESSION]): HASH_TABLE [TUPLE [true_exprs, false_exprs: DS_HASH_SET [EPA_EXPRESSION]], CI_TEST_CASE_TRANSITION_INFO]
			-- Collect program states at the entry of feature under question.
			-- `a_abstraction' defines how to abstract the entry program state.
			-- `a_data' contains the list of runs of interest.
		do
			create Result.make_equal (1)
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

feature -- Precondition inference

	feature_entry_state (a_data: like data;
					a_funcs: EPA_HASH_SET [EPA_FUNCTION];
					a_operand_map_table: DS_HASH_TABLE [HASH_TABLE [INTEGER_32, INTEGER_32], EPA_FUNCTION])
				: HASH_TABLE [TUPLE[true_exprs, false_exprs: EPA_HASH_SET[EPA_EXPRESSION]], CI_TEST_CASE_TRANSITION_INFO]
			-- Program state at the entry of feature, defined on the basis of `a_funcs'.
			-- Test_case_info --> [expressions_with_true_value, expressions_with_false_value]
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_interface_transitions: DS_HASH_TABLE [SEM_FEATURE_CALL_TRANSITION, CI_TEST_CASE_TRANSITION_INFO]
			l_interface_transitions_cursor: DS_HASH_TABLE_CURSOR [SEM_FEATURE_CALL_TRANSITION, CI_TEST_CASE_TRANSITION_INFO]
			l_operand_map_tables: DS_HASH_TABLE [HASH_TABLE [INTEGER_32, INTEGER_32], EPA_FUNCTION]
			l_operand_map: HASH_TABLE [INTEGER_32, INTEGER_32]
			l_test: CI_TEST_CASE_TRANSITION_INFO
			l_transition: SEM_FEATURE_CALL_TRANSITION
			l_evaluator: CI_EXPRESSION_EVALUATOR
			l_funcs_cursor: DS_HASH_SET_CURSOR [EPA_FUNCTION]
			l_true_expressions, l_false_expressions: EPA_HASH_SET[EPA_EXPRESSION]
			l_func: EPA_FUNCTION
			l_expr: EPA_EXPRESSION
			l_evaluation: TUPLE[is_successful, val: BOOLEAN]
		do
			l_interface_transitions := a_data.interface_transitions
			l_operand_map_tables := a_operand_map_table
			create Result.make_equal (l_interface_transitions.count + 1)

			l_class := class_under_test
			l_feature := feature_under_test

			create l_evaluator
			l_evaluator.set_is_ternary_logic_enabled (True)
			l_evaluator.set_evaluating_pre_expressions (True)

			l_interface_transitions_cursor := l_interface_transitions.new_cursor
			from l_interface_transitions_cursor.start
			until l_interface_transitions_cursor.after
			loop
				l_test := l_interface_transitions_cursor.key
				l_transition := l_interface_transitions_cursor.item

				create l_true_expressions.make_equal (a_funcs.count + 1)
				create l_false_expressions.make_equal (a_funcs.count + 1)
				Result.force ([l_true_expressions, l_false_expressions], l_test)

				l_evaluator.set_context (l_test.transition.preconditions, l_test.transition.postconditions, l_test.test_case_info.class_under_test)
				l_funcs_cursor := a_funcs.new_cursor
				from l_funcs_cursor.start
				until l_funcs_cursor.after
				loop
					l_func := l_funcs_cursor.item

					l_evaluation := evaluate_function (l_evaluator, l_test, a_operand_map_table, l_func)
					if l_evaluation.is_successful then
						l_expr := expression_from_function (l_func, Void, a_operand_map_table.item (l_func), l_class, l_feature)
						if l_expr /= Void then
							if l_evaluation.val then
								l_true_expressions.force (l_expr)
							else
								l_false_expressions.force (l_expr)
							end
						end
					end

					l_funcs_cursor.forth
				end

				l_interface_transitions_cursor.forth
			end
		end

	evaluate_function (a_evaluator: CI_EXPRESSION_EVALUATOR; a_test_case: CI_TEST_CASE_TRANSITION_INFO; a_operand_map_table: DS_HASH_TABLE [HASH_TABLE [INTEGER_32, INTEGER_32], EPA_FUNCTION]; a_expr: EPA_FUNCTION): TUPLE[is_successful, val: BOOLEAN]
			-- Evaluate `a_expr' using `a_evaluator', and return the result.
		local
			l_operand_map: HASH_TABLE [INTEGER_32, INTEGER_32]
			l_resolved_function: EPA_FUNCTION
			l_successful, l_val: BOOLEAN
		do
			a_evaluator.wipe_out_error
			if a_operand_map_table.has (a_expr) then
				l_operand_map := a_operand_map_table.item (a_expr)
				l_resolved_function := a_expr.partially_evaluated_with_arguments (operand_function_table (l_operand_map, a_test_case))
				a_evaluator.evaluate (ast_from_expression_text (l_resolved_function.body))
				l_successful := not a_evaluator.has_error and then a_evaluator.last_value /= Void and then a_evaluator.last_value.is_boolean
				if l_successful then
					l_val := a_evaluator.last_value.as_boolean.is_true
				end

					-- Logging.					
				logger.push_level ({ELOG_LOG_MANAGER}.debug_level)
				logger.put_string (once "%T%T")
				logger.put_string (l_resolved_function.body)
				logger.put_string (once " == ")
				if not l_successful then
					logger.put_line ("failed")
				else
					logger.put_line (l_val.out)
				end
				logger.pop_level
			else
				l_successful := False
			end

			Result := [l_successful, l_val]
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

feature -- Access

	transition_data: LINKED_LIST [CI_TEST_CASE_TRANSITION_INFO]
			-- Transition data from which contracts are inferred
		do
			Result := data.transition_data
		end

	feature_under_test: FEATURE_I
			-- Feature under test

	class_under_test: CLASS_C
			-- Class where `feature_under_test' comes

	is_creation: BOOLEAN
			-- Is `featue_under_test' tested as a creation procedure?

	is_query: BOOLEAN
			-- Is `feature_under_test' a query?

feature{NONE} -- Implementation

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

	quantifier_free_expressions (a_quantifier_expressions: DS_HASH_SET [CI_QUANTIFIED_EXPRESSION]): DS_HASH_TABLE [DS_HASH_TABLE [DS_HASH_SET [EPA_FUNCTION], CI_QUANTIFIED_EXPRESSION], STRING]
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
			logger.push_level ({ELOG_LOG_MANAGER}.debug_level)
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

	valid_frame_properties (
		a_ternary_logic: BOOLEAN;
		a_is_precondition: BOOLEAN;
		a_expressions: like quantifier_free_expressions;
		a_bookkeeping_agent: detachable PROCEDURE [ANY, TUPLE [a_quantified_expr: CI_QUANTIFIED_EXPRESSION; a_resolved_expr: STRING; a_evaluator: CI_EXPRESSION_EVALUATOR; a_tc_info: CI_TEST_CASE_TRANSITION_INFO]]): DS_HASH_SET [CI_QUANTIFIED_EXPRESSION]
			-- Set of valid frame properties from `a_expressions'
			-- A frame property is valid if it evaluates to True in all test cases.
		local
			l_tc_cursor: DS_HASH_TABLE_CURSOR [DS_HASH_TABLE [DS_HASH_SET [EPA_FUNCTION], CI_QUANTIFIED_EXPRESSION], STRING_8]
			l_transition_info: CI_TEST_CASE_TRANSITION_INFO
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
			l_evaluator.set_is_ternary_logic_enabled (a_ternary_logic)
			l_evaluator.set_evaluating_pre_expressions (a_is_precondition)

				-- Logging.
			logger.push_level ({ELOG_LOG_MANAGER}.debug_level)
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
				l_evaluator.set_context (l_transition_info.transition.preconditions, l_transition_info.transition.postconditions, l_transition_info.test_case_info.class_under_test)
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
							l_function := l_expr_cursor.item.partially_evaluated_with_arguments (operand_function_table (l_quantified_function.operand_map, l_transition_info))
							l_evaluator.evaluate (ast_from_expression_text (l_function.body))
							l_all_qfree_true := not l_evaluator.has_error and then l_evaluator.last_value.is_boolean and then l_evaluator.last_value.as_boolean.is_true
								-- A quantified expression is evaluated to False or there is an error during evaluation, remove it from candidate set.
							if l_all_qfree_true then
								if a_bookkeeping_agent /= Void then
									a_bookkeeping_agent.call ([l_quantified_function, l_function.body, l_evaluator, l_transition_info])
								end
							else
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
		end

	operand_function_table (a_operand_map: HASH_TABLE [INTEGER, INTEGER]; a_transition_data: CI_TEST_CASE_TRANSITION_INFO): HASH_TABLE [EPA_FUNCTION, INTEGER]
			-- A table from function operand index to expressions representing that operand in the context of `a_transition_data'
			-- `a_operand_map' is a map 1-based argument index in a function to 0-based operand indexes in `a_transition_data'.
		local
			l_cursor: CURSOR
			l_transition: SEM_TRANSITION
			l_arg_func: EPA_FUNCTION
		do
			create Result.make (5)
			l_transition := a_transition_data.transition
			l_cursor := a_operand_map.cursor
			from
				a_operand_map.start
			until
				a_operand_map.after
			loop
				create l_arg_func.make_from_expression (l_transition.reversed_variable_position.item (a_operand_map.item_for_iteration))
				Result.put (l_arg_func, a_operand_map.key_for_iteration)
				a_operand_map.forth
			end
			a_operand_map.go_to (l_cursor)
		end

	setup_last_contracts
			-- Setup `last_contracts' using `last_preconditions' and `last_postconditions'.
		do
			create last_contracts.make (2)
			last_contracts.put (last_preconditions, True)
			last_contracts.put (last_postconditions, False)
		end

	expression_from_function (a_function: EPA_FUNCTION; a_function_type: detachable TYPE_A; a_operand_map: HASH_TABLE [INTEGER, INTEGER]; a_class: CLASS_C; a_feature: FEATURE_I): EPA_EXPRESSION
			-- An expression from `a_function'
			-- `a_function_type' is the type of `a_function', if Void, type check `a_function' to get the real type.
			-- The resulting expression is understood in the context of `a_feature' in `a_class'.
			-- `a_operand_map' is a table from 1-based function argument index to 0-based operand index in `a_feature'.
		local
			l_arg_index: INTEGER
			l_arg_str: STRING
			l_opd_str: STRING
			l_body: STRING
			l_operand_strs: HASH_TABLE [STRING, INTEGER]
			l_creator: EPA_AST_EXPRESSION_SAFE_CREATOR
		do
				-- Translate 1-based argument indexes in `a_function'.`body' into 0-based operand indexes in `a_feature'.
			l_operand_strs := operand_name_index_with_feature (feature_under_test, class_under_test)
			l_body := a_function.body.twin
			across 1 |..| a_function.arity as l_argument_indexes loop
				l_arg_index := l_argument_indexes.item
				l_arg_str := curly_brace_surrounded_integer (l_arg_index)
				l_body.replace_substring_all (l_arg_str, l_operand_strs.item (a_operand_map.item (l_arg_index)))
			end
			if a_function_type /= Void then
				Result := l_creator.safe_create_with_text_and_type (a_class, a_feature, l_body, a_class, a_function_type)
			else
				Result := l_creator.safe_create_with_text (a_class, a_feature, l_body, a_class)
			end
		end

	expression_from_quantified_expression (a_quantified_expr: CI_QUANTIFIED_EXPRESSION; a_class: CLASS_C; a_feature: FEATURE_I): EPA_EXPRESSION
			-- An expression from `a_quantified_expr'
			-- The resulting expression is understood in the context of `a_feature' in `a_class'.		
		local
			l_var_name: STRING
			l_forall: EPA_UNIVERSAL_QUANTIFIED_EXPRESSION
			l_predicate: EPA_EXPRESSION
			l_text: STRING
			l_func: EPA_FUNCTION
			l_new_pred_func: EPA_FUNCTION
		do

			l_var_name := a_quantified_expr.quantified_variable_name (a_feature, a_class)
			l_func := a_quantified_expr.predicate
			l_text := l_func.body.twin
			l_text.replace_substring_all (curly_brace_surrounded_integer (a_quantified_expr.quantified_variable_argument_index), l_var_name)
			create l_new_pred_func.make (l_func.argument_types, l_func.argument_domains, l_func.result_type, l_text)
			if a_quantified_expr.is_for_all then
				l_predicate := expression_from_function (l_new_pred_func, l_new_pred_func.result_type, a_quantified_expr.operand_map, a_class, a_feature)
				if l_predicate /= Void then
					create {EPA_UNIVERSAL_QUANTIFIED_EXPRESSION}Result.make (l_var_name, a_quantified_expr.quantified_variabale_type, l_predicate, a_class, a_feature, a_class)
				end
--			else
--				check not_supported_yet: False end
			end
		end

feature{NONE} -- Candidate validation

	operand_string_table_for_feature (a_feature: FEATURE_I): HASH_TABLE [STRING, INTEGER]
			-- Operand string table for `a_feature'
			-- Result is a table from 0-based operand index to curly brace surrounded indexes for `feature_under_test'	
			-- 0 -> {0}, 1 -> {1} and so on.			
		local
			l_opd_count: INTEGER
		do
			l_opd_count := operand_count_of_feature (a_feature)
			create Result.make (l_opd_count)
			across 0 |..| (l_opd_count - 1) as l_operands loop
				Result.put (curly_brace_surrounded_integer (l_operands.item), l_operands.item)
			end
		end

	candidate_property (a_clauses: DS_HASH_SET [STRING]; a_connector: STRING; a_operand_string_table: HASH_TABLE [STRING, INTEGER]): TUPLE [function: EPA_FUNCTION; operand_map: HASH_TABLE [INTEGER, INTEGER]]
			-- Candidate property cosisting all clauses in `a_clauses'
			-- `a_connector' is the operator to connect different `a_clauses', can be either "or" or "and".
			-- `a_operand_string_table' is a table from 0-based operand indexes to their place holder strings in the text, i.e. curly brace surrounded indexes.
			-- 				For example 0 -> {0}.
			--
			-- `function' is the function representation for the returned candidate property.
			-- `operand_map' maps (1-based argument indexes in the function) to (0-based operand indexes in the call to feature-under-test).
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
				if l_count > 1 then
					l_func_text.append_character ('(')
					l_func_text.append (l_cursor.item)
					l_func_text.append_character (')')
				else
					l_func_text.append (l_cursor.item)
				end
				if i < l_count then
					l_func_text.append_character (' ')
					l_func_text.append (a_connector)
					l_func_text.append_character (' ')
				end
				l_cursor.forth
				i := i + 1
			end

				-- Update the place holders in the text so that the indexes are w.r.t. the function arguments (1-based).
				-- Maintain a table to map the function argument indexes to feature-under-text operand indexes.
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
						-- Update the mapping from (1-based argument indexes in the function) to (0-based operand indexes in the feature call)
					l_operand_map.put (l_opd_index, i)
						-- In function text, replace the old place holder with a temporary place holder;
						-- 		keep track of which final place holders should be used in the end.
					l_arg_index_holder := curly_brace_surrounded_integer (i)
					l_new_holder := double_square_surrounded_integer (i)
					l_place_holder_tbl.extend (l_arg_index_holder, l_new_holder)
					l_func_text.replace_substring_all (l_old_holder, l_new_holder)

					i := i + 1
				end
			end
				-- Replace temporal place holders with final place holders.
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

	validate_candidate_properties (a_pre: BOOLEAN; a_candidates: EPA_HASH_SET [EPA_FUNCTION]; a_operand_map_table: DS_HASH_TABLE [HASH_TABLE [INTEGER_32, INTEGER_32], EPA_FUNCTION]; a_message: STRING)
			-- Validate `a_candidates', and remove all invaild ones.
			-- The candidates are for pre conditions if `a_pre', and for postconditions otherwise.
		local
			l_test_case: CI_TEST_CASE_TRANSITION_INFO
			l_candidates: DS_HASH_SET_CURSOR [EPA_FUNCTION]
			l_confirmed_candidates, l_candidates_twin: EPA_HASH_SET [EPA_FUNCTION]
			l_candidate: EPA_FUNCTION
			l_evaluator: CI_EXPRESSION_EVALUATOR
			l_operand_map_tables: DS_HASH_TABLE [HASH_TABLE [INTEGER_32, INTEGER_32], EPA_FUNCTION]
			l_operand_map: HASH_TABLE [INTEGER, INTEGER]
			l_resolved_function: EPA_FUNCTION
			l_is_valid, l_is_invalid, l_confirmed: BOOLEAN
			l_candidate_properties: EPA_HASH_SET [EPA_FUNCTION]
			l_once_true, l_always_true, l_once_false: EPA_HASH_SET [EPA_FUNCTION]
			l_evaluation_result: like evaluate_function
		do
			logger.put_line_with_time (a_message)
			logger.push_level ({ELOG_CONSTANTS}.debug_level)

				-- Iterate through all test cases, and validate all properties in `candidate_properties'
				-- in the context text of each test case.
			l_operand_map_tables := a_operand_map_table
			l_candidate_properties := a_candidates.twin
			create l_once_true.make (a_candidates.count)
			l_once_true.set_equality_tester (a_candidates.equality_tester)
			l_once_false := l_once_true.twin
			l_always_true := a_candidates.twin

			create l_evaluator
			l_evaluator.set_is_ternary_logic_enabled (True)
			l_evaluator.set_evaluating_pre_expressions (a_pre)
			across transition_data as l_test_cases loop
				l_test_case := l_test_cases.item
				logger.put_line ("%TTest case " + l_test_case.test_case_info.test_case_class.name_in_upper)
				l_evaluator.set_context (l_test_case.transition.preconditions, l_test_case.transition.postconditions, l_test_case.test_case_info.class_under_test)

					-- Iterate through all candidate properties and validate them
					-- one by one in the context of `l_test_case'.
				from
					l_candidates := l_candidate_properties.new_cursor
					l_candidates.start
				until
					l_candidates.after
				loop
					l_candidate := l_candidates.item

					l_evaluation_result := evaluate_function (l_evaluator, l_test_case, a_operand_map_table, l_candidate)
					l_is_valid := l_evaluation_result.is_successful and then l_evaluation_result.val
					l_is_invalid := l_evaluation_result.is_successful and then not l_evaluation_result.val

					if l_is_valid then
						l_once_true.force (l_candidate)
					elseif l_is_invalid then
						l_once_false.force (l_candidate)
						l_always_true.remove (l_candidate)
					elseif not l_evaluation_result.is_successful then
						l_always_true.remove (l_candidate)
					end
					l_candidates.forth

--					l_operand_map := l_operand_map_tables.item (l_candidate)
--					l_resolved_function := l_candidate.partially_evaluated_with_arguments (operand_function_table (l_operand_map, l_test_case))
--					l_evaluator.evaluate (ast_from_expression_text (l_resolved_function.body))
--					l_is_valid := not l_evaluator.has_error and then l_evaluator.last_value.is_boolean and then l_evaluator.last_value.as_boolean.is_true

--					if (config.is_validation_universal and then not l_is_valid)				-- confirmed to exclude
--						or else (not config.is_validation_universal and then l_is_valid) 	-- confirmed to include
--					then
--						l_confirmed_candidates.force (l_candidate)
--						l_candidate_properties.remove (l_candidate)		-- confirmed properties don't need to validated again
--					else
--						l_candidates.forth
--					end

--					if l_is_valid then
--						l_candidates.forth
--					else
--						l_candidate_properties.remove (l_candidate)
--						l_operand_map_tables.remove (l_candidate)
--					end

--						-- Logging.					
--					logger.push_level ({ELOG_LOG_MANAGER}.debug_level)
--					logger.put_string (once "%T%T")
--					logger.put_string (l_resolved_function.body)
--					logger.put_string (once " == ")
--					if l_evaluator.has_error then
--						logger.put_line (l_evaluator.error_reason)
--					else
--						logger.put_line (l_evaluator.last_value.out)
--					end
--					logger.pop_level
				end
			end

			if config.is_optimistic_about_nonsensical_values then
					-- Take expressions that were at least once True and never False.
				a_candidates.intersect (l_once_true)
				a_candidates.subtract (l_once_false)
			else
					-- Take only expressions always evaluated to True.
				a_candidates.intersect (l_always_true)
			end

--			from
--				l_candidates := a_candidates.new_cursor
--				l_candidates.start
--			until
--				l_candidates.after
--			loop
--				l_candidate := l_candidates.item

--				if config.use_true_for_unknown then
--					
--				end

--				l_confirmed := l_confirmed_candidates.has (l_candidate)
--				if config.is_validation_universal and then l_confirmed
--					or else not config.is_validation_universal and then not l_confirmed
--				then
--					a_candidates.remove (l_candidate)
--					a_operand_map_table.remove (l_candidate)
--				else
--					l_candidates.forth
--				end
--			end

			logger.pop_level
		end

	program_states_at_entry_in_functions (a_functions: DS_HASH_SET [EPA_FUNCTION]; a_abstraction: DS_HASH_SET [EPA_EXPRESSION]; a_operand_map_table: DS_HASH_TABLE [HASH_TABLE [INTEGER_32, INTEGER_32], EPA_FUNCTION])
				: HASH_TABLE [TUPLE [true_exprs, false_exprs: DS_HASH_SET [EPA_EXPRESSION]], CI_TEST_CASE_TRANSITION_INFO]
			-- Program states at feature entry abstracted using `a_functions'.
			-- Only the functions whose corresponding expressions are in `a_abstraction' are used.
			-- Result contains, for each test case in `data', sets of expressions that evaluate to True or False.
		local
			l_pre_result: HASH_TABLE [TUPLE [true_funcs, false_funcs: DS_HASH_SET [EPA_FUNCTION]], CI_TEST_CASE_TRANSITION_INFO]
			l_evaluator: CI_EXPRESSION_EVALUATOR
			l_test_case: CI_TEST_CASE_TRANSITION_INFO
			l_operand_map_table: DS_HASH_TABLE [HASH_TABLE [INTEGER_32, INTEGER_32], EPA_FUNCTION]
			l_candidates: DS_HASH_SET_CURSOR [EPA_FUNCTION]
			l_true_funcs, l_false_funcs, l_missing_funcs, l_src: DS_HASH_SET [EPA_FUNCTION]
			l_true_exprs, l_false_exprs, l_dest: DS_HASH_SET [EPA_EXPRESSION]
			l_src_exprs, l_dest_exprs, l_exprs_to_remove: DS_HASH_SET [EPA_EXPRESSION]
			l_candidate: EPA_FUNCTION
			l_expr, l_neg_expr: EPA_EXPRESSION
			l_evaluation_result: like evaluate_function
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_couples: ARRAY [TUPLE [src: DS_HASH_SET [EPA_FUNCTION]; dest: DS_HASH_SET [EPA_EXPRESSION]]]
			l_expression_couples: ARRAY [TUPLE [src, dest: DS_HASH_SET [EPA_EXPRESSION]]]
		do
				-- Organize functions into different sets based on their values
			create l_pre_result.make_equal (data.transitions.count + 1)
			l_operand_map_table := a_operand_map_table
			create l_missing_funcs.make_equal (20)
			create l_evaluator
			l_evaluator.set_is_ternary_logic_enabled (True)
			l_evaluator.set_evaluating_pre_expressions (True)
			across transition_data as l_test_cases loop
				l_test_case := l_test_cases.item
				create l_true_funcs.make_equal (20)
				create l_false_funcs.make_equal (20)
				l_pre_result.force ([l_true_funcs, l_false_funcs], l_test_case)

				l_evaluator.set_context (l_test_case.transition.preconditions, l_test_case.transition.postconditions, l_test_case.test_case_info.class_under_test)
				from
					l_candidates := a_functions.new_cursor
					l_candidates.start
				until
					l_candidates.after
				loop
					l_candidate := l_candidates.item
--					if not l_missing_funcs.has (l_candidate) then
						l_evaluation_result := evaluate_function (l_evaluator, l_test_case, l_operand_map_table, l_candidate)
						if l_evaluation_result.is_successful then
							if l_evaluation_result.val then
								l_true_funcs.force (l_candidate)
							else
								l_false_funcs.force (l_candidate)
							end
						else
							l_missing_funcs.force (l_candidate)
						end
--					end
					l_candidates.forth
				end
			end

				-- Organize expressions from `a_abstraction' based on their values at feature entry.
				-- Remove expressions that don't have a valid value in some runs.
			create Result.make_equal (data.transitions.count + 1)
			l_class := class_under_test
			l_feature := feature_under_test
			across l_pre_result as l_result_entry loop
				l_test_case := l_result_entry.key
				l_true_funcs := l_result_entry.item.true_funcs
				l_false_funcs := l_result_entry.item.false_funcs

				create l_true_exprs.make_equal (l_true_funcs.count + 1)
				create l_false_exprs.make_equal (l_false_funcs.count + 1)
				Result.force ([l_true_exprs, l_false_exprs], l_test_case)




------------------------------------------------
				l_couples := <<[l_true_funcs, l_true_exprs], [l_false_funcs, l_false_exprs]>>
				across l_couples as l_couple loop
					l_src := l_couple.item.src
					l_dest := l_couple.item.dest
					from l_src.start
					until l_src.after
					loop
						l_candidate := l_src.item_for_iteration
						l_expr := expression_from_function (l_candidate, Void, l_operand_map_table.item (l_candidate), l_class, l_feature)
						if l_expr /= Void then
							l_dest.force (l_expr)
						end
--						if a_abstraction.has (l_expr) then			-- the corresponding expression is interesting.
--						end
						l_src.forth
					end
				end

				l_expression_couples := <<[l_false_exprs, l_true_exprs], [l_true_exprs, l_false_exprs]>>
				across l_expression_couples as l_expr_couple loop
					l_src_exprs := l_expr_couple.item.src
					l_dest_exprs:= l_expr_couple.item.dest
					create l_exprs_to_remove.make_equal (l_src_exprs.count)

					from l_src_exprs.start
					until l_src_exprs.after
					loop
						l_expr := l_src_exprs.item_for_iteration
						if a_abstraction.has (l_expr) then
							-- Keep the expression as it is
						else
							l_exprs_to_remove.force (l_expr)

								-- Is the negation of the expression interesting?
								-- This is a hack. More systematic checking should be performed here.
							l_neg_expr := create {EPA_AST_EXPRESSION}.make_with_text (l_expr.class_, l_expr.feature_, "not (" + l_expr.text + ")", l_expr.written_class)
							if a_abstraction.has (l_neg_expr) then
								l_dest_exprs.force (l_neg_expr)
							end
						end
						l_src_exprs.forth
					end
					l_src_exprs.subtract (l_exprs_to_remove)
				end
----------------------------				
			end

		end

	log_candidate_properties (a_candidates: DS_HASH_SET [EPA_FUNCTION]; a_message: STRING)
			-- Log `candidate_properties' with staring message `a_message'.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_FUNCTION]
		do
			logger.push_level ({ELOG_LOG_MANAGER}.debug_level)
			logger.put_line_with_time (a_message)
			from
				l_cursor := a_candidates.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				logger.put_line (once "%T" + l_cursor.item.body)
				l_cursor.forth
			end
			logger.pop_level
		end

	setup_inferred_contracts_in_last_postconditions (a_candidates: DS_HASH_SET [EPA_FUNCTION]; a_operand_map_table: DS_HASH_TABLE [HASH_TABLE [INTEGER_32, INTEGER_32], EPA_FUNCTION]; a_mapping_agent: detachable PROCEDURE [ANY, TUPLE [a_expr: EPA_EXPRESSION; a_func: EPA_FUNCTION]])
			-- Generate final inferred contracts from `candidate_properties' and
			-- store result in `last_postconditions'.
		local
			l_candidates: DS_HASH_SET_CURSOR [EPA_FUNCTION]
			l_postconditions: like last_postconditions
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_property: EPA_EXPRESSION
		do
			l_postconditions := last_postconditions
			l_class := class_under_test
			l_feature := feature_under_test
			from
				l_candidates := a_candidates.new_cursor
				l_candidates.start
			until
				l_candidates.after
			loop
				l_property := expression_from_function (l_candidates.item, Void, a_operand_map_table.item (l_candidates.item), l_class, l_feature)
				if l_property /= Void then
					l_postconditions.force_last (l_property)
					if a_mapping_agent /= Void then
						a_mapping_agent.call ([l_property, l_candidates.item])
					end
				end
				l_candidates.forth
			end
		end

	setup_inferred_contracts_in_last_preconditions (a_candidates: DS_HASH_SET [EPA_FUNCTION]; a_operand_map_table: DS_HASH_TABLE [HASH_TABLE [INTEGER_32, INTEGER_32], EPA_FUNCTION]; a_mapping_agent: detachable PROCEDURE [ANY, TUPLE [a_expr: EPA_EXPRESSION; a_func: EPA_FUNCTION]])
			-- Generate final inferred contracts from `candidate_properties' and
			-- store result in `last_preconditions'.
		local
			l_candidates: DS_HASH_SET_CURSOR [EPA_FUNCTION]
			l_preconditions: like last_preconditions
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_property: EPA_EXPRESSION
		do
			l_preconditions := last_preconditions
			l_class := class_under_test
			l_feature := feature_under_test
			from
				l_candidates := a_candidates.new_cursor
				l_candidates.start
			until
				l_candidates.after
			loop
				l_property := expression_from_function (l_candidates.item, Void, a_operand_map_table.item (l_candidates.item), l_class, l_feature)
				if l_property /= Void then
					l_preconditions.force_last (l_property)
					if a_mapping_agent /= Void then
						a_mapping_agent.call ([l_property, l_candidates.item])
					end
				end
				l_candidates.forth
			end
		end

end
