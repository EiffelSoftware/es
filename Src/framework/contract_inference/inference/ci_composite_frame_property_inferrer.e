note
	description: "[
		Inferrer to infer composite frame properties, such as
		forall o. old l.has (o) and s.has (o) implies Result.has (o)
				]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_COMPOSITE_FRAME_PROPERTY_INFERRER

inherit
	CI_INFERRER

	EPA_SHARED_MATH

feature -- Basic operations

	infer (a_data: like data)
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		local
			l_quantified_expressions: like quantified_expressions
			l_sig_cursor: like base_signatures.new_cursor
			l_quantifier_free_exressions: like quantifier_free_expressions
			l_valid_frame_properties: like valid_frame_properties
			l_valid_prop_cursor: DS_HASH_SET_CURSOR [CI_QUANTIFIED_EXPRESSION]
		do
			data := a_data
			setup_data_structures

			logger.put_line_with_time ("Start inferring composite frame properties.")
			find_suitable_functions

				-- Build frame property candidates.
			create l_quantified_expressions.make (10)
			l_quantified_expressions.set_equality_tester (ci_quantified_expression_equality_tester)
			from
				l_sig_cursor := base_signatures.new_cursor
				l_sig_cursor.start
			until
				l_sig_cursor.after
			loop
				l_quantified_expressions.append_last (quantified_expressions (l_sig_cursor.item))
				l_sig_cursor.forth
			end
			log_built_quantified_expressions (l_quantified_expressions)

				-- Validate quantified frame properties.
			create evaluation_distribution.make (100)
			evaluation_distribution.set_key_equality_tester (ci_quantified_expression_equality_tester)
			l_quantifier_free_exressions := quantifier_free_expressions (l_quantified_expressions)
			l_valid_frame_properties := valid_frame_properties (False, l_quantifier_free_exressions, agent on_property_evaluated)

				-- Filter out properties which only evaluated to true or only evaluated to false over all test cases.
			from
				l_valid_frame_properties.start
			until
				l_valid_frame_properties.after
			loop
				evaluation_distribution.search (l_valid_frame_properties.item_for_iteration)
				if evaluation_distribution.found implies (evaluation_distribution.found_item.true_times > 0 and evaluation_distribution.found_item.false_times > 0) then
					l_valid_frame_properties.forth
				else
					l_valid_frame_properties.remove (l_valid_frame_properties.item_for_iteration)
				end
			end

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

	evaluation_distribution: DS_HASH_TABLE [TUPLE [true_times: INTEGER; false_times: INTEGER], CI_QUANTIFIED_EXPRESSION]
			-- Evaluation distribution of quantified expression
			-- Key is a quantified expression, value is the evaluation distribution for that quantified expression.
			-- `true_times' is the number of times that the premise of the quantified expression evaluates to True.
			-- `false_times' is the number of times that the premise of the quantified expression evaluates to False.

	on_property_evaluated (a_quantified_expr: CI_QUANTIFIED_EXPRESSION; a_resolved_expr: STRING; a_evaluator: CI_EXPRESSION_EVALUATOR; a_tc_info: CI_TEST_CASE_TRANSITION_INFO)
			-- Action to be performed when the resolved form `a_resolved_expr' of the quantified expression `a_quantified_expr' is validated
			-- in `a_tc_info' using `a_evaluator'.
		local
			l_premise_as: detachable EXPR_AS
			l_distribution: TUPLE [true_times: INTEGER; false_times: INTEGER]
		do
			check attached {EXPR_AS} ast_from_expression_text (a_resolved_expr) as l_as then
				if attached {BIN_EQ_AS} l_as as l_equal_as then
						-- Handle the case when `a_quantified_expr' is an implication.
					l_premise_as := l_equal_as.left
				elseif attached {BIN_IMPLIES_AS} l_as as l_implies_as then
						-- Handle the case when `a_quantified_expr' is an equation.
					l_premise_as := l_implies_as.left
				end

					-- Only handle the case when premise is of type boolean.
				if l_premise_as /= Void and then a_tc_info.transition.context.expression_type (l_premise_as).is_boolean then
					a_evaluator.evaluate (l_premise_as)
					if not a_evaluator.has_error then
						if attached {EPA_BOOLEAN_VALUE} a_evaluator.last_value as l_bool_value then
							evaluation_distribution.search (a_quantified_expr)
							if evaluation_distribution.found then
								l_distribution := evaluation_distribution.found_item
							else
								l_distribution := [0, 0]
								evaluation_distribution.force_last (l_distribution, a_quantified_expr)
							end

								-- Increase distribution counter.
							if l_bool_value.item then
								l_distribution.put_integer (l_distribution.true_times + 1, 1)
							else
								l_distribution.put_integer (l_distribution.false_times + 1, 2)
							end
						end
					end
				end
			end
		end

	base_functions: like suitable_functions
			-- Functions that are used as building blocks of more complicated frame properties.
			-- Those functions are from pre-state valuations.

	base_signatures: DS_HASH_SET [CI_SINGLE_ARG_FUNCTION_SIGNATURE]
			-- Set of signatures of functions in `base_functions'

	pre_functions_by_signature: DS_HASH_TABLE [like base_functions, CI_SINGLE_ARG_FUNCTION_SIGNATURE]
			-- Set of functions grouped by signature in pre-state.
			-- Key is signature, value is a set of functions with the same signature.
			-- Intention: To support inferring frame properties such as:
			-- old l.has (o) or old s.has (o) implies l.has (o), for LINKED_LIST.append (l.append (s)),
			-- we first find some trigger functions, those functions are stored in `base_functions', for example, old l.has (o).
			-- Then we find all functions in pre- and post-state valuations which has the same signature as those functions
			-- in `base_functions', for example, old s.has (o), l.has (o). Those newly found functions are stored either
			-- in `pre_functions_by_signature' or `post_functions_by_signature' depending on where they are found.
			-- Then a property template generator will take one or more functions from `pre_functions_by_signature' and one
			-- function from `post_functions_by_signature', and combile them as a frame property.

	post_functions_by_signature: DS_HASH_TABLE [like base_functions, CI_SINGLE_ARG_FUNCTION_SIGNATURE]
			-- Set of functions grouped by signature in post-state.
			-- Key is signature, value is a set of functions with the same signature.
			-- See `pre_functions_by_signatures' for explanation of this feature.

	functions_by_signature: HASH_TABLE [like pre_functions_by_signature, BOOLEAN]
			-- Table of functions by signature
			-- Key is a boolean indicating pre-state or post-state, value is a table from signature to functions.
			-- See `pre_functions_by_signature' and `post_functions_by_signature' for details.

feature{NONE} -- Implementation

	is_function_with_multiple_argument_valuations (a_function: EPA_FUNCTION; a_valuations: EPA_FUNCTION_VALUATIONS; a_target_variable_index: INTEGER; a_transition: SEM_TRANSITION): BOOLEAN
			-- Does `a_function' has multiple argument valuations in the context of `a_transition'?
			-- `a_function' is assumed to be a qualified call, the target object has index `a_target_variable_index'.
			-- The valuations to check are from `a_valuations'.
			-- For example, `a_function' can be "v_2.has", if in `a_valuations', there are:
			-- v_2.has (v_1), v_2.has (v_3), then "v_2.has" is considered to have multiple argument valuations.
		local
			l_func_valuations: EPA_FUNCTION_VALUATIONS
		do
				-- We are only interested in boolean queries with one argument,
				-- together with the target, the arity of that function
				-- should be 2.		
			if
				a_function.arity = 2 and then 						 -- Function should have one argument.
				not a_function.argument_type (2).is_integer	and then -- Function argument shoult not of type integer, because we handle integer argument differently.
				((a_function.result_type.is_integer) or (a_function.result_type.is_boolean)) -- Function should return an integer or a boolean
			then
				l_func_valuations := a_valuations.projected (1, value_set_for_variable (a_transition.reversed_variable_position.item (a_target_variable_index).text, a_transition))
				if l_func_valuations.map.count > 1 then
					Result := True
				end
			end
		end

	is_function_with_same_signature (a_function: EPA_FUNCTION; a_valuations: EPA_FUNCTION_VALUATIONS; a_target_variable_index: INTEGER; a_transition: SEM_TRANSITION; a_signature: CI_SINGLE_ARG_FUNCTION_SIGNATURE; a_pre_state: BOOLEAN): BOOLEAN
			-- Does `a_function' have the same signature as `a_signature'?
		local
			l_func_valuations: EPA_FUNCTION_VALUATIONS
			l_signature: CI_SINGLE_ARG_FUNCTION_SIGNATURE
			l_func_target_type: TYPE_A
			l_operand_type: TYPE_A
		do
				-- We are only interested in boolean queries with one argument,
				-- together with the target, the arity of that function
				-- should be 2.		
			if a_function.arity = 2 then
				if attached {SEM_FEATURE_CALL_TRANSITION} a_transition as l_feat_tran then
					l_operand_type := l_feat_tran.reversed_variable_position.item (a_target_variable_index).type
					l_operand_type := actual_type_from_formal_type (l_operand_type, l_feat_tran.class_)
					l_operand_type := l_operand_type.instantiation_in (l_feat_tran.class_.actual_type, l_feat_tran.class_.class_id)
					l_func_target_type := a_function.argument_type (1)

					if l_operand_type.is_conformant_to (l_feat_tran.class_, l_func_target_type) then
						l_signature := signature_of_single_argument_function (a_function, a_target_variable_index)
						if l_signature /= Void then
							Result := ci_single_arg_function_signature_equality_tester.test (l_signature, a_signature)
						end
					end
				end
			end
		end

feature{NONE} -- Implementation

	find_suitable_functions
			-- Find functions that are suitable as building blocks of more complicated frame properties,
			-- Store result in `base_functions'.
		local
			l_cursor: DS_HASH_SET_CURSOR [TUPLE [function: EPA_FUNCTION; target_variable_index: INTEGER_32]]
			l_signature: CI_SINGLE_ARG_FUNCTION_SIGNATURE
			l_sig_cursor: like base_signatures.new_cursor
			l_state_functions: DS_HASH_TABLE [like base_functions, CI_SINGLE_ARG_FUNCTION_SIGNATURE]
			l_pre_state: BOOLEAN
			l_functions: like base_functions
			l_function: EPA_FUNCTION
		do
			base_functions := suitable_functions (True, agent is_function_with_multiple_argument_valuations)
			create base_signatures.make (base_functions.count)
			base_signatures.set_equality_tester (ci_single_arg_function_signature_equality_tester)

				-- Group `base_functions' according to their signature.
			from
				l_cursor := base_functions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_signature := signature_of_single_argument_function (l_cursor.item.function, l_cursor.item.target_variable_index)
				if l_signature /= Void then
					base_signatures.force_last (l_signature)
				end
				l_cursor.forth
			end

				-- Logging.
			logger.push_fine_level
			logger.put_line (once "Found the following base functions:")
			from
				l_cursor := base_functions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				logger.put_line (
					once "%T" +
					l_cursor.item.function.debug_output +
					once ", signature: " +
					signature_of_single_argument_function (l_cursor.item.function, l_cursor.item.target_variable_index).debug_output +
					once ", target operand index = " + l_cursor.item.target_variable_index.out)
				l_cursor.forth
			end
			logger.put_line (once "")
			logger.pop_level

				-- Collect functiosn in pre- and post-state valuations, which have the same signature as those
				-- in `base_functions'.
			create pre_functions_by_signature.make (10)
			pre_functions_by_signature.set_key_equality_tester (ci_single_arg_function_signature_equality_tester)
			create post_functions_by_signature.make (10)
			post_functions_by_signature.set_key_equality_tester (ci_single_arg_function_signature_equality_tester)
			create functions_by_signature.make (2)
			functions_by_signature.put (pre_functions_by_signature, True)
			functions_by_signature.put (post_functions_by_signature, False)

				-- Iterate through all signatures.
			from
				l_sig_cursor := base_signatures.new_cursor
				l_sig_cursor.start
			until
				l_sig_cursor.after
			loop
				l_signature := l_sig_cursor.item
				l_pre_state := True
					-- Iterate through pre- and post-state.
				across <<True, false>> as l_func_cursor loop
					l_pre_state := l_func_cursor.item
					l_state_functions := functions_by_signature.item (l_pre_state)
					l_state_functions.search (l_signature)
					if l_state_functions.found then
						l_functions := l_state_functions.found_item
					else
						create l_functions.make (10)
						l_functions.set_equality_tester (function_candidate_equality_tester)
						l_state_functions.force_last (l_functions, l_signature)
					end
						-- For each signature and each state, get the set of functions of the same signature in that state.
					l_functions.append_last (suitable_functions (l_pre_state, agent is_function_with_same_signature (?, ?, ?, ?, l_signature, l_pre_state)))
				end
				l_sig_cursor.forth
			end

				-- Logging.
			logger.put_line ("Found the following functions, grouped by signature:")
			across <<True, False>> as l_func_cursor loop
				l_pre_state := l_func_cursor.item
				l_state_functions := functions_by_signature.item (l_pre_state)
				if l_pre_state then
					logger.put_line ("   In pre-state:")
				else
					logger.put_line ("    In post-state:")
				end
				from
					l_sig_cursor := base_signatures.new_cursor
					l_sig_cursor.start
				until
					l_sig_cursor.after
				loop
					l_functions := l_state_functions.item (l_sig_cursor.item)
					if l_functions /= Void then
						logger.put_line (once "        Signature:" + l_sig_cursor.item.debug_output)
						from
							l_cursor := l_functions.new_cursor
							l_cursor.start
						until
							l_cursor.after
						loop
							logger.put_line (once "          " + l_cursor.item.function.body + ", target operand index = " + l_cursor.item.target_variable_index.out)
							l_cursor.forth
						end
					end
					l_sig_cursor.forth
				end
			end
		end

	signature_of_single_argument_function (a_function: EPA_FUNCTION; a_target_variable_index: INTEGER): detachable CI_SINGLE_ARG_FUNCTION_SIGNATURE
			-- Signature of single argument function `a_function'
			-- `a_function' is assumed to be a qualified call, so its arity should be 2, the first one is the target.
		require
			a_function.arity = 2
		local
			l_target_type: TYPE_A
			l_arg_type: TYPE_A
			l_result_type: TYPE_A
			l_feature_name: STRING
			l_dot_index: INTEGER
			l_lparan_index: INTEGER
			l_feature: FEATURE_I
		do
			l_target_type := operand_types_with_feature (feature_under_test, class_under_test).item (a_target_variable_index).actual_type
			l_target_type := actual_type_from_formal_type (l_target_type, class_under_test)
			l_target_type := l_target_type.instantiation_in (class_under_test.actual_type, class_under_test.class_id)

			l_dot_index := a_function.body.index_of ('.', 1)
			l_lparan_index := a_function.body.index_of ('(', l_dot_index + 1)
			l_feature_name := a_function.body.substring (l_dot_index + 1, l_lparan_index - 1)
			l_feature := l_target_type.associated_class.feature_named (l_feature_name)
			if l_feature /= Void then
				l_arg_type := l_feature.arguments.i_th (1).actual_type
				l_arg_type := actual_type_from_formal_type (l_arg_type, l_target_type.associated_class)
				l_arg_type := l_arg_type.instantiation_in (l_target_type, l_target_type.associated_class.class_id)


				l_result_type := l_feature.type.actual_type
				l_result_type := actual_type_from_formal_type (l_result_type, l_target_type.associated_class)
				l_result_type := l_result_type.instantiation_in (l_target_type, l_target_type.associated_class.class_id)
				create Result.make (l_arg_type, l_result_type)
			else
				Result := Void
			end
		end

	quantified_expressions (a_signature: CI_SINGLE_ARG_FUNCTION_SIGNATURE): DS_HASH_SET [CI_QUANTIFIED_EXPRESSION]
			-- Quantified expressions. Functions in resulting expressions must with signature `a_signature'
		local
			l_premises: like base_functions
			l_consequent: like base_functions
			l_cursor: like suitable_functions.new_cursor
		do
			create Result.make (10)
			Result.set_equality_tester (ci_quantified_expression_equality_tester)

			l_premises := pre_functions_by_signature.item (a_signature)
			l_consequent := post_functions_by_signature.item (a_signature)
			if l_premises /= Void and then l_consequent /= Void then
					-- Iterate through the functions in `l_consequent', for each of such function,
					-- build a set of quantified implications, with premises comes from a subset of
					-- functions in `l_premises', for example:
					-- Forall o . l_pre1 (o) and l_pre2 (o) implies l_con (o)
				from
					l_cursor := l_consequent.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					Result.append_last (quantified_expression_with_functions (l_premises, l_cursor.item, a_signature))
					l_cursor.forth
				end
			end
		end

	quantified_expression_with_functions (a_premise_functions: like base_functions; a_consequent_function: like function_type_anchor; a_signature: CI_SINGLE_ARG_FUNCTION_SIGNATURE): like quantified_expressions
			-- Quantified expressions whose premises are built from `a_premise_functions', whose
			-- consequent is built from `a_consequent_function' and all the premise/consequent functions must have
			-- signature `a_signature'.
		local
			l_premises: EPA_HASH_SET [like function_type_anchor]
			l_max_premise_num: INTEGER
		do
			create Result.make (20)
			Result.set_equality_tester (ci_quantified_expression_equality_tester)

			create l_premises.make (a_premise_functions.count)
			l_premises.set_equality_tester (function_candidate_equality_tester)
			l_premises.append_last (a_premise_functions)

				-- Decide the max number of premise used in implication based frame properties.
			if config.composite_max_premise_number > 0 then
				l_max_premise_num := config.composite_max_premise_number.min (l_premises.count)
			else
				l_max_premise_num := l_premises.count
			end

				-- Iterate through all premise possibilities to generate frame property candidates.
			across config.composite_min_premise_number |..| l_max_premise_num as l_premise_num loop
				across l_premises.combinations (l_premise_num.item) as l_cursor loop
					if a_signature.is_result_boolean then
						Result.append_last (
							quantified_expressions_internal (
								l_cursor.item,
								a_consequent_function,
								a_signature,
								config.is_composite_negation_boolean_premise_enabled,
								config.composite_boolean_premise_connectors,
								config.composite_boolean_connectors))
					elseif a_signature.is_result_integer then
						Result.append_last (
							quantified_expressions_internal (
								l_cursor.item,
								a_consequent_function,
								a_signature,
								False,
								config.composite_integer_premise_connectors,
								config.composite_integer_connectors))
					end
				end
			end
		end

	quantified_expressions_internal (
		a_premises: EPA_HASH_SET [like function_type_anchor];
		a_consequent: like function_type_anchor;
		a_signature: CI_SINGLE_ARG_FUNCTION_SIGNATURE;
		a_premise_negation_enabled: BOOLEAN;
		a_premise_connectors: LINKED_SET [STRING]
		a_premise_consequent_connectors: LINKED_SET [STRING]): like quantified_expressions
			-- Quantified expressions built from `a_premises' and `a_consequent'
			-- Functions in `a_premises' and `a_consequent' are of boolean type and they have
			-- signature of `a_signature'.
		local
			l_cursor: DS_HASH_SET_CURSOR [like function_type_anchor]
			l_premises: LINKED_LIST [DS_HASH_SET [like function_type_anchor]]
			l_function: EPA_FUNCTION
			l_negated_function: EPA_FUNCTION
			l_func_set: DS_HASH_SET [like function_type_anchor]
			l_actual_premises: like cartesian_product
			l_scope: CI_FUNCTION_DOMAIN_QUANTIFIED_SCOPE
			l_predicate_body: STRING
			l_operand_map: HASH_TABLE [INTEGER, INTEGER]
			l_row, l_column: INTEGER
			l_operator_name: STRING
			l_func_body: STRING
			l_quantifier_index: INTEGER
			l_quantifier_text: STRING
			l_dquantifier_text: STRING
			l_columns_num: INTEGER
			l_consequent_text: STRING
			l_index_tbl: HASH_TABLE [INTEGER, INTEGER] -- Table from target variable index in premise/consequent functions to operand index in the final frame property predicate
			l_opd_index: INTEGER
			l_curly1: STRING
			l_curly2: STRING
			l_quantified_expr: CI_QUANTIFIED_EXPRESSION
			l_predicate: EPA_FUNCTION
			l_pred_arg_types: ARRAY [TYPE_A]
			l_operand_types: like operand_types_with_feature
			l_connector: STRING
			l_actual_predicate_body: STRING
		do
			create Result.make (10)
			Result.set_equality_tester (ci_quantified_expression_equality_tester)

			l_curly1 := curly_brace_surrounded_integer (1)
			l_curly2 := curly_brace_surrounded_integer (2)
				-- Construct the set of premise functions along with their negations.
			create l_premises.make
			create l_index_tbl.make (5)
			from
				l_opd_index := 1
				l_cursor := a_premises.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_function := l_cursor.item.function
				if a_premise_negation_enabled then
					create l_negated_function.make (l_function.argument_types.twin, l_function.argument_domains.twin, l_function.result_type, once "not old " + l_function.body)
				end
				create l_function.make (l_function.argument_types.twin, l_function.argument_domains.twin, l_function.result_type, once "old " + l_function.body)
				create l_func_set.make (2)
				l_func_set.set_equality_tester (function_candidate_equality_tester)
				l_func_set.force_last ([l_function, l_cursor.item.target_variable_index])
				if a_premise_negation_enabled then
					l_func_set.force_last ([l_negated_function, l_cursor.item.target_variable_index])
				end
				l_premises.extend (l_func_set)
				if not l_index_tbl.has (l_cursor.item.target_variable_index) then
					l_index_tbl.put (l_opd_index, l_cursor.item.target_variable_index)
					l_opd_index := l_opd_index + 1
				end
				l_cursor.forth
			end
			if not l_index_tbl.has (a_consequent.target_variable_index) then
				l_index_tbl.put (l_opd_index, a_consequent.target_variable_index)
				l_opd_index := l_opd_index + 1
			end

				-- Setup `l_pred_arg_types'.
			create l_pred_arg_types.make (1, l_opd_index)
			l_operand_types := operand_types_with_feature (feature_under_test, class_under_test)
			across l_index_tbl as l_index_cursor loop
				l_pred_arg_types.put (l_operand_types.item (l_index_cursor.key), l_index_cursor.item)
			end
			l_pred_arg_types.put (a_premises.first.function.argument_type (2), l_opd_index)

			l_actual_premises := cartesian_product (l_premises)
			l_columns_num := l_actual_premises.width

				-- Iterate through all actual premises and generate frame property candidates.
			l_quantifier_index := l_opd_index
			l_quantifier_text := curly_brace_surrounded_integer (l_quantifier_index)
			l_dquantifier_text := double_square_surrounded_integer (l_quantifier_index)
			across a_premise_connectors as l_operators loop
				l_operator_name := once " " + l_operators.item + once " "
				across 1 |..| l_actual_premises.height as l_rows loop
					l_row := l_rows.item
					create l_predicate_body.make (128)
					create l_operand_map.make (l_columns_num)
						-- Setup premises.
					across 1 |..| l_actual_premises.width as l_columns loop
						l_column := l_columns.item
						check attached {like function_type_anchor} l_actual_premises.item (l_row, l_column) as l_premise_func then
							l_operand_map.put (l_premise_func.target_variable_index, l_index_tbl.item (l_premise_func.target_variable_index))
							l_func_body := l_premise_func.function.body.twin
							l_func_body.replace_substring_all (l_curly2, l_quantifier_text)
							l_func_body.replace_substring_all (l_curly1, curly_brace_surrounded_integer (l_index_tbl.item (l_premise_func.target_variable_index)))
							l_predicate_body.append (l_func_body)
							if l_column < l_columns_num then
								l_predicate_body.append (l_operator_name)
							end
						end
					end
					l_predicate_body.prepend (once "(")
					l_predicate_body.append (once ")")
					across a_premise_consequent_connectors as l_connectors loop
						l_connector := once " " + l_connectors.item + once " "
						l_actual_predicate_body := l_predicate_body + l_connector
							-- Setup consequent.
						l_operand_map.put (a_consequent.target_variable_index, l_index_tbl.item (a_consequent.target_variable_index))
						create l_consequent_text.make (32)
						l_consequent_text.append (a_consequent.function.body)
						l_consequent_text.replace_substring_all (l_curly2, l_quantifier_text)
						l_consequent_text.replace_substring_all (l_curly1, curly_brace_surrounded_integer (l_index_tbl.item (a_consequent.target_variable_index)))
						l_actual_predicate_body.append (l_consequent_text)

							-- Create quantified expression as the frame property.
						create l_scope.make (a_premises.first.function, 2, True)
						l_predicate := quantified_function (l_pred_arg_types, l_actual_predicate_body)
						create l_quantified_expr.make (l_quantifier_index, l_predicate, l_scope, True, l_operand_map)
						Result.force_last (l_quantified_expr)
					end
				end
			end
		end

	function_type_anchor: TUPLE [function: EPA_FUNCTION; target_variable_index: INTEGER]
			-- Type anchor

	cartesian_product (a_sets: LIST [DS_HASH_SET [HASHABLE]]): ARRAY2 [HASHABLE]
			-- Cartesion project
		local
			l_rows: INTEGER
			l_columns: INTEGER
			l_repitition_factor: INTEGER
			l_repititions: ARRAYED_LIST [INTEGER]
			l_set: DS_HASH_SET [HASHABLE]
			l_item_cursor: DS_HASH_SET_CURSOR [HASHABLE]
			l_row: INTEGER
			l_column: INTEGER
			i: INTEGER
			l_item: HASHABLE
		do
			l_columns := a_sets.count
			l_rows := 1
			l_repitition_factor := 1
			create l_repititions.make (a_sets.count)
			across a_sets.new_cursor.reversed as l_set_cursor loop
				l_repititions.put_front (l_repitition_factor)
				l_rows := l_rows * l_set_cursor.item.count
				l_repitition_factor := l_repitition_factor * l_set_cursor.item.count
			end
			create Result.make (l_rows, l_columns)

				-- Construct result cartesian product.
			l_column := 1
			across a_sets as l_set_cursor loop
				l_repitition_factor := l_repititions.i_th (l_column)
				l_set := l_set_cursor.item
				l_row := 1
				across 1 |..| (l_rows // l_repitition_factor // l_set_cursor.item.count) as l_times loop
					from
						l_item_cursor := l_set.new_cursor
						l_item_cursor.start
					until
						l_item_cursor.after
					loop
						l_item := l_item_cursor.item
						from
							i := 1
						until
							i > l_repitition_factor
						loop
							Result.put (l_item, l_row, l_column)
							i := i + 1
							l_row := l_row + 1
						end
						l_item_cursor.forth
					end
				end
				l_column := l_column + 1
			end
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

feature{NONE} -- Logging

	log_built_quantified_expressions (a_exprs: like quantified_expressions)
			-- Log that `a_exprs' have been built.
		local
			l_quantified_expr_cursor: DS_HASH_SET_CURSOR [CI_QUANTIFIED_EXPRESSION]
		do
			logger.push_fine_level
			logger.put_line ("Built the following frame property candidates:")
			from
				l_quantified_expr_cursor := a_exprs.new_cursor
				l_quantified_expr_cursor.start
			until
				l_quantified_expr_cursor.after
			loop
				logger.put_line (once "    " + l_quantified_expr_cursor.item.debug_output)
				l_quantified_expr_cursor.forth
			end
			logger.pop_level
		end

end
