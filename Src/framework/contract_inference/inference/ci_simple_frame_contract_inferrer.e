note
	description: "Contract inferrer to propose simple frame conditions"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_SIMPLE_FRAME_CONTRACT_INFERRER

inherit
	CI_INFERRER

feature -- Basic operations

	infer (a_data: LINKED_LIST [CI_TEST_CASE_TRANSITION_INFO])
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
			setup_data_structures

				-- Find building blocks for frame conditions.
			l_suitable_functions := suitable_functions (True, agent is_function_suitable)
			l_quantified_expressions := quantified_expressions (l_suitable_functions, True)
			l_quantifier_free_exressions := quantifier_free_expressions (l_quantified_expressions)
			l_valid_frame_properties := valid_frame_properties (l_quantifier_free_exressions)
		end

feature{NONE} -- Implementation

	is_function_suitable (a_function: EPA_FUNCTION; a_valuations: EPA_FUNCTION_VALUATIONS; a_target_variable_index: INTEGER; a_transition: SEM_TRANSITION): BOOLEAN
			-- Is `a_function' whose valuations in `a_transition' suitable as a building block for frame properties?
			-- `a_target_variable_index' is the 0-based operand index which is supposed to be the target of `a_function'.
		local
			l_func_valuations: EPA_FUNCTION_VALUATIONS
		do
				-- We are only interested in boolean queries with one argument,
				-- together with the target, the arity of that function
				-- should be 2.		
			if
				a_function.arity = 2 and then 						 -- Function should have one argument.
				not a_function.argument_type (1).is_integer			 -- Function argument shoult not of type integer, because we handle integer argument differently.
			then
				l_func_valuations := a_valuations.projected (1, value_set_for_variable (a_transition.reversed_variable_position.item (a_target_variable_index).text, a_transition))

					-- If `a_function' is a boolean query, we require that there are more than one object which made the query to return True.
				if a_function.result_type.is_boolean then
					l_func_valuations := l_func_valuations.projected (l_func_valuations.function.arity + 1, true_value_set (a_transition))
				end

				if l_func_valuations.map.count > 1 then
					Result := True
				end
			end
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
				forall_query_implies_query_expression (l_function, l_target_index, True, False).do_all (agent Result.force_last)
				forall_query_implies_query_expression_with_argument (l_function, l_target_index, True, False).do_all (agent Result.force_last)
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

	forall_query_implies_query_expression (a_function: EPA_FUNCTION; a_target_variable_index: INTEGER; a_pre_state: BOOLEAN; a_negated_consequent: BOOLEAN): DS_HASH_SET [CI_QUANTIFIED_EXPRESSION]
			-- Frame property predicate built from `a_suitable_function' whose target is with `a_target_variable_index'
			-- If `a_function' is a boolean query, the format of the frame property is:
			--   (1) "forall o . old a_function (o) implies a_function (o)" if `a_negated_consequent' is False, otherwise,
			--   (2) "forall o . old a_function (o) implies not a_function (o)"
			-- If `a_function' is not a boolean query, the format of the frame property is:
			--   (1) "forall o . old a_function (o) = a_function (o)" if `a_negated_consequent' is False, otherwise,
			--   (2) "forall o . old a_function (o) /= a_function (o)"			
			-- `a_pre_state' indicates if the scope of the quantified variable is from pre-execution state or post-execution state.
		local
			l_scope: CI_FUNCTION_DOMAIN_QUANTIFIED_SCOPE
			l_predicate_body: STRING
			l_quantified_expr: CI_QUANTIFIED_EXPRESSION
			l_operand_map: HASH_TABLE [INTEGER, INTEGER]
			l_predicate: EPA_FUNCTION
		do
			create Result.make (1)
			Result.set_equality_tester (ci_quantified_expression_equality_tester)

			create l_scope.make (a_function, 2, a_pre_state)
			create l_predicate_body.make (64)

			l_predicate_body.append (once "old ")
			l_predicate_body.append (a_function.body)
			if a_function.result_type.is_boolean then
				if a_negated_consequent then
					l_predicate_body.append (once " implies not ")
				else
					l_predicate_body.append (once " implies ")
				end
			else
				if a_negated_consequent then
					l_predicate_body.append (once " /= ")
				else
					l_predicate_body.append (once " = ")
				end
			end

			l_predicate_body.append (a_function.body)

			create l_operand_map.make (1)
			l_operand_map.put (a_target_variable_index, 1)
			l_predicate := quantified_function (a_function.argument_types, l_predicate_body)
			create l_quantified_expr.make (2, l_predicate, l_scope, True, l_operand_map)
			Result.force_last (l_quantified_expr)
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

	forall_query_implies_query_expression_with_argument (a_function: EPA_FUNCTION; a_target_variable_index: INTEGER; a_pre_state: BOOLEAN; a_negated_consequent: BOOLEAN): DS_HASH_SET [CI_QUANTIFIED_EXPRESSION]
			-- Frame property predicate built from `a_function' whose target is with `a_target_variable_index'
			-- If `a_function' is a boolean query, the format of the frame property is:
			--   (1) "forall o . old a_function (o) implies a_function (o)" if `a_negated_consequent' is False, otherwise,
			--   (2) "forall o . old a_function (o) implies not a_function (o)"
			-- If `a_function' is not a boolean query, the format of the frame property is:
			--   (1) "forall o . old a_function (o) = a_function (o)" if `a_negated_consequent' is False, otherwise,
			--   (2) "forall o . old a_function (o) /= a_function (o)"			
			-- `a_pre_state' indicates if the scope of the quantified variable is from pre-execution state or post-execution state.
		local
			l_scope: CI_FUNCTION_DOMAIN_QUANTIFIED_SCOPE
			l_predicate_body: STRING
			l_quantified_expr: CI_QUANTIFIED_EXPRESSION
			l_operand_map: HASH_TABLE [INTEGER, INTEGER]
			l_predicate: EPA_FUNCTION
			l_actual_arg_type: TYPE_A
			l_feat_types: DS_HASH_TABLE [TYPE_A, INTEGER_32]
			l_func_arg_type: TYPE_A
			l_argument_types: ARRAY [TYPE_A]
			l_is_container: BOOLEAN
			l_templates: LINKED_LIST [TUPLE [header: STRING; trailer: STRING]]
		do
			create Result.make (1)
			Result.set_equality_tester (ci_quantified_expression_equality_tester)

			if feature_under_test.argument_count = 1 and then a_function.arity = 2 and then not a_function.argument_type (2).is_integer then
				l_is_container := is_class_a_container (class_under_test)
				l_feat_types := resolved_operand_types_with_feature (feature_under_test, class_under_test, class_under_test.constraint_actual_type)
				l_actual_arg_type := l_feat_types.item (1)
				l_func_arg_type := a_function.argument_type (2).actual_type
				l_func_arg_type := actual_type_from_formal_type (l_func_arg_type, class_under_test)

					-- Create different contract templates depending on whether `class_under_test' is a CONTAINER class.
				create l_templates.make
				if l_func_arg_type.is_conformant_to (class_under_test, l_actual_arg_type) then
					l_templates.extend (["old " + curly_brace_surrounded_integer (1) + ".object_comparison implies ({3} /~ {2} implies(", "))"])
					l_templates.extend (["not old " + curly_brace_surrounded_integer (1) + ".object_comparison implies ({3} /= {2} implies (", "))"])
				else
					l_templates.extend (["{3} /= {2} implies (", ")"])
				end

				from
					l_templates.start
				until
					l_templates.after
				loop
						-- Construct frame property text.
					create l_predicate_body.make (64)
					l_predicate_body.append (l_templates.item_for_iteration.header)
					l_predicate_body.append (once "old ")
					l_predicate_body.append (a_function.body)
					if a_negated_consequent then
						l_predicate_body.append (once " /= ")
					else
						l_predicate_body.append (once " = ")
					end
					l_predicate_body.append (a_function.body)
					l_predicate_body.append (l_templates.item_for_iteration.trailer)

						-- Setup frame property scope and operand map.
					create l_scope.make (a_function, 2, a_pre_state)
					create l_operand_map.make (1)
					l_operand_map.put (a_target_variable_index, 1)
					l_operand_map.put (1, 2)

						-- Setup argument types for the frame property.
					create l_argument_types.make (1, 3)
					l_argument_types.put (a_function.argument_type (1), 1)
					l_argument_types.put (a_function.argument_type (2), 2)
					l_argument_types.put (feature_under_test.arguments.first, 3)
					l_predicate := quantified_function (l_argument_types, l_predicate_body)

						-- Create frame property.
					create l_quantified_expr.make (2, l_predicate, l_scope, True, l_operand_map)
					Result.force_last (l_quantified_expr)
					l_templates.forth
				end
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

--	fake_nullary_function (a_result_type: TYPE_A; a_body: STRING): EPA_FUNCTION
--			-- Fake nullary function of type `a_result_type' and body `a_body'
--		do
--			create Result.make (<<>>, <<>>, a_result_type, a_body)
--		end

	valid_frame_properties (a_expressions: like quantifier_free_expressions): DS_HASH_SET [CI_QUANTIFIED_EXPRESSION]
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

	operand_function_table (a_quantified_expression: CI_QUANTIFIED_EXPRESSION; a_transition_data: CI_TEST_CASE_TRANSITION_INFO): HASH_TABLE [EPA_FUNCTION, INTEGER]
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

	is_class_a_container (a_class: CLASS_C): BOOLEAN
			-- Is `a_class' a {CONTAINER}?		
		local
			l_container_id: INTEGER
		do
			l_container_id := first_class_starts_with_name ("CONTAINER").class_id
			Result := ancestors (a_class).there_exists (agent (c: CLASS_C; a_id: INTEGER): BOOLEAN do Result := c.class_id = a_id end (?, l_container_id))
		end

end
