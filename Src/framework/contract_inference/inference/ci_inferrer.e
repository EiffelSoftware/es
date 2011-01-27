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
				create {EPA_AST_EXPRESSION} Result.make_with_text_and_type (a_class, a_feature, l_body, a_class, a_function_type)
			else
				create {EPA_AST_EXPRESSION} Result.make_with_text (a_class, a_feature, l_body, a_class)
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
				create l_forall.make (l_var_name, a_quantified_expr.quantified_variabale_type, l_predicate, a_class, a_feature, a_class)
				Result := l_forall
			else
				check not_supported_yet: False end
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
				if l_count > 1 then
					l_func_text.append_character ('(')
					l_func_text.append (l_cursor.item)
					l_func_text.append_character (')')
				else
					l_func_text.append (l_cursor.item)
				end
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

	validate_candiate_properties (a_candidates: EPA_HASH_SET [EPA_FUNCTION]; a_operand_map_table: DS_HASH_TABLE [HASH_TABLE [INTEGER_32, INTEGER_32], EPA_FUNCTION]; a_message: STRING)
			-- Validate `a_candidates', and remove all invaild ones.
		local
			l_test_case: CI_TEST_CASE_TRANSITION_INFO
			l_candidates: DS_HASH_SET_CURSOR [EPA_FUNCTION]
			l_candidate: EPA_FUNCTION
			l_evaluator: CI_EXPRESSION_EVALUATOR
			l_operand_map_tables: DS_HASH_TABLE [HASH_TABLE [INTEGER_32, INTEGER_32], EPA_FUNCTION]
			l_operand_map: HASH_TABLE [INTEGER, INTEGER]
			l_resolved_function: EPA_FUNCTION
			l_is_valid: BOOLEAN
			l_candidate_properties: EPA_HASH_SET [EPA_FUNCTION]
		do
			logger.put_line_with_time (a_message)
			logger.push_level ({ELOG_CONSTANTS}.debug_level)

				-- Iterate through all test cases, and validate all properties in `candidate_properties'
				-- in the context text of each test case.
			l_operand_map_tables := a_operand_map_table
			l_candidate_properties := a_candidates
			create l_evaluator
			l_evaluator.set_is_ternary_logic_enabled (True)
			across transition_data as l_test_cases loop
				l_test_case := l_test_cases.item
				logger.put_line ("%TTest case " + l_test_case.test_case_info.test_case_class.name_in_upper)
				l_evaluator.set_context (l_test_case.transition.preconditions, l_test_case.transition.postconditions, l_test_case.test_case_info.class_under_test)

					-- Iterate through all candidate properties and validate them
					-- one by one in the context of `l_test_case'.
				from
					l_candidates := a_candidates.new_cursor
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
					logger.push_level ({ELOG_LOG_MANAGER}.debug_level)
					logger.put_string (once "%T%T")
					logger.put_string (l_resolved_function.body)
					logger.put_string (once " == ")
					if l_evaluator.has_error then
						logger.put_line (l_evaluator.error_reason)
					else
						logger.put_line (l_evaluator.last_value.out)
					end
					logger.pop_level
				end
			end

			logger.pop_level
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
				l_postconditions.force_last (l_property)
				if a_mapping_agent /= Void then
					a_mapping_agent.call ([l_property, l_candidates.item])
				end
				l_candidates.forth
			end
		end

end
