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

	infer (a_data: like data)
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		local
			l_suitable_functions: like suitable_functions
			l_quantified_expressions: like quantified_expressions
			l_quantifier_free_exressions: like quantifier_free_expressions
			l_valid_frame_properties: like valid_frame_properties
		do
				-- Initialize.
			data := a_data
			setup_data_structures

				-- Find building blocks for frame conditions.
			l_suitable_functions := suitable_functions (True, agent is_function_suitable)
			l_quantified_expressions := quantified_expressions (l_suitable_functions, True)
			l_quantifier_free_exressions := quantifier_free_expressions (l_quantified_expressions)
			l_valid_frame_properties := valid_frame_properties (False, l_quantifier_free_exressions, Void)

				-- Setup results.
			create last_preconditions.make (10)
			last_preconditions.set_equality_tester (expression_equality_tester)
			create last_postconditions.make (10)
			last_postconditions.set_equality_tester (expression_equality_tester)
			generate_inferred_contracts (l_valid_frame_properties)
			setup_last_contracts

				-- Logging.
			logger.push_info_level
			logger.put_line (once "Valid frame properties:")
			from
				l_valid_frame_properties.start
			until
				l_valid_frame_properties.after
			loop
				logger.put_string (once "%T")
				logger.put_line (l_valid_frame_properties.item_for_iteration.debug_output)
				l_valid_frame_properties.forth
			end
			logger.pop_level
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
				not a_function.argument_type (2).is_integer			 -- Function argument shoult not of type integer, because we handle integer argument differently.
			then
				l_func_valuations := a_valuations.projected (1, value_set_for_variable (a_transition.reversed_variable_position.item (a_target_variable_index).text, a_transition))

					-- If `a_function' is a boolean query, we require that there are more than one object which made the query to return True.
				if a_function.result_type.is_boolean then
					l_func_valuations := l_func_valuations.projected (l_func_valuations.function.arity + 1, true_value_set (a_transition))
				end

				if l_func_valuations.map.count > 1 then
					Result := True
				end

					-- Remove functions with nonsensical values, because a candidate property containing such
					-- functions will not be a valid contract anyway.
				if Result then
					Result := not l_func_valuations.has_nonsensical_in_result
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
			l_temp_body: STRING
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
--				if l_func_arg_type.is_conformant_to (class_under_test, l_actual_arg_type) then
--					l_templates.extend (["old " + curly_brace_surrounded_integer (1) + ".object_comparison implies ({3} /~ {2} implies(", "))"])
--					l_templates.extend (["not old " + curly_brace_surrounded_integer (1) + ".object_comparison implies ({3} /= {2} implies (", "))"])
--				else
					l_templates.extend (["{3} /= {2} implies (", ")"])
--				end

				from
					l_templates.start
				until
					l_templates.after
				loop
						-- Construct frame property text.
					create l_predicate_body.make (64)
					l_predicate_body.append (l_templates.item_for_iteration.header)
					l_predicate_body.append (once "old ")
					l_temp_body := a_function.body.twin
					l_temp_body.replace_substring_all (curly_brace_surrounded_integer (2), curly_brace_surrounded_integer (3))
					l_predicate_body.append (l_temp_body)
					if a_negated_consequent then
						l_predicate_body.append (once " /= ")
					else
						l_predicate_body.append (once " = ")
					end
					l_predicate_body.append (l_temp_body)
					l_predicate_body.append (l_templates.item_for_iteration.trailer)

						-- Setup frame property scope and operand map.
					create l_scope.make (a_function, 2, a_pre_state)
					create l_operand_map.make (2)
					l_operand_map.put (a_target_variable_index, 1)
					l_operand_map.put (1, 2)

						-- Setup argument types for the frame property.
					create l_argument_types.make (1, 3)
					l_argument_types.put (a_function.argument_type (1), 1)
					l_argument_types.put (feature_under_test.arguments.first, 2)
					l_argument_types.put (a_function.argument_type (2), 3)
					l_predicate := quantified_function (l_argument_types, l_predicate_body)

						-- Create frame property.
					create l_quantified_expr.make (3, l_predicate, l_scope, True, l_operand_map)
					Result.force_last (l_quantified_expr)
					l_templates.forth
				end
			end
		end

	is_class_a_container (a_class: CLASS_C): BOOLEAN
			-- Is `a_class' a {CONTAINER}?		
		local
			l_container_id: INTEGER
		do
			l_container_id := first_class_starts_with_name ("CONTAINER").class_id
			Result := ancestors (a_class).there_exists (agent (c: CLASS_C; a_id: INTEGER): BOOLEAN do Result := c.class_id = a_id end (?, l_container_id))
		end

	generate_inferred_contracts (a_valid_properties: DS_HASH_SET [CI_QUANTIFIED_EXPRESSION])
			-- Generate final inferred contracts from `candidate_properties' and
			-- store result in `last_postconditions'.
		local
			l_properties: DS_HASH_SET_CURSOR [CI_QUANTIFIED_EXPRESSION]
			l_expr: EPA_EXPRESSION
		do
			from
				l_properties := a_valid_properties.new_cursor
				l_properties.start
			until
				l_properties.after
			loop
				l_expr := expression_from_quantified_expression (l_properties.item, class_under_test, feature_under_test)
				last_postconditions.force_last (l_expr)
				l_properties.forth
			end
		end

end
