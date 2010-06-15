note
	description: "Evaluator to evaluate expressions in the context of collected state expressions"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_EXPRESSION_EVALUATOR

inherit
	AST_ITERATOR
		redefine
			process_un_old_as,
			process_void_as,
			process_integer_as,
			process_bool_as,
			process_bin_and_as,
			process_bin_and_then_as,
			process_bin_or_as,
			process_bin_or_else_as,
			process_bin_implies_as,
			process_bin_xor_as,
			process_bin_eq_as,
			process_bin_ge_as,
			process_bin_gt_as,
			process_bin_le_as,
			process_bin_lt_as,
			process_bin_ne_as,
			process_bin_minus_as,
			process_bin_plus_as,
			process_access_feat_as,
			process_nested_as,
			process_un_not_as,
			process_bin_tilde_as,
			process_bin_not_tilde_as,
			process_tuple_as,
			process_un_free_as,
			process_bin_free_as
		end

	EPA_SHARED_EQUALITY_TESTERS

	EPA_UTILITY

	SHARED_TEXT_ITEMS

	ETR_PARSING_HELPER
		select
			error_handler
		end

	CI_SEQUENCE_OPERATOR_NAMES

feature -- Access

	transition_context: CI_TEST_CASE_TRANSITION_INFO
			-- Context in which expressions are evaluated

	missing_expressions: DS_HASH_SET [EPA_EXPRESSION]
			-- Set of expressions that were needed to by the last
			-- `evaluate' but are missing in `transtion_context'.
			-- Note: The test case in `transition_context' needs to be executed
			-- again to get the values of these missing expressions

	last_value: EPA_EXPRESSION_VALUE
			-- Value of the last evaluated expression by `evaluate'

	pre_state_values: EPA_STATE
			-- Expressions values from pre-execution state
		do
			Result := transition_context.transition.precondition
		end

	post_state_values: EPA_STATE
			-- Expressions values from pre-execution state
		do
			Result := transition_context.transition.postcondition
		end

	extra_pre_state_values: detachable EPA_STATE
			-- Extra pre-state values

	extra_post_state_values: detachable EPA_STATE
			-- Extra post-state values			

	state_values (a_pre_state: BOOLEAN): EPA_STATE
			-- State values from pre-execution if `a_pre_state' is True,
			-- otherwise, from post-execution.
		do
			if a_pre_state then
				Result := pre_state_values
			else
				Result := post_state_values
			end
		end

	extra_state_values (a_pre_state: BOOLEAN): detachable EPA_STATE
			-- Extra state values from pre-execution if `a_pre_state' is True,
			-- otherwise, from post-execution.
		do
			if a_pre_state then
				Result := extra_pre_state_values
			else
				Result := extra_post_state_values
			end
		end

	sequence_value (a_value: EPA_EXPRESSION_VALUE): detachable MML_FINITE_SEQUENCE [EPA_EXPRESSION_VALUE]
			-- Sequence value out of `a_value'
		do
			if attached {EPA_ANY_VALUE} a_value as l_value then
				if attached {CI_SEQUENCE [EPA_EXPRESSION_VALUE]} a_value.item as l_sequence then
					Result := l_sequence.content
				elseif attached {MML_FINITE_SEQUENCE [EPA_EXPRESSION_VALUE]} a_value.item as l_sequence then
					Result := l_sequence
				end
			end
		end

feature -- Status report

	has_error: BOOLEAN
			-- Was an error during last expression evaluation?

	error_reason: detachable STRING
			-- Reason for the last error

feature -- Basic operations

	evaluate (a_expr: AST_EIFFEL)
			-- Evaluate `a_expr' in the context of `transition_context',
			-- make result available in `last_value'.
			-- Store missing expressions (if any) in `missing_expressions'.
			-- Old expressions will be evaluated in pre-execution state, and
			-- normal expressions will be evaluated in post-execution state.
			-- For example: in "old o.has (v) implies o.has (v)", sub-expression
			-- "old o.has (v)" will be evaluated in pre-execution state, and sub-expression
			-- "o.has (v)" will be evaluated in post-execution state.
		require
			a_expr_attached: a_expr /= Void
		do
			initialize_data_structures
			a_expr.process (Current)
		end

	evaluate_string (a_string: STRING)
			-- Evaluate `a_string' in `transition_context'.
			-- See comment of `evaluate' for details.
		local
			l_parser: like etr_expr_parser
		do
			l_parser := etr_expr_parser
			setup_formal_parameters (l_parser, transition_context.test_case_info.class_under_test)
			l_parser.parse_from_string (once "check " + a_string, transition_context.test_case_info.class_under_test)
			check l_parser.expression_node /= Void end
			evaluate (l_parser.expression_node)
		end

feature -- Setting

	set_transition_context (a_context: like transition_context)
			-- Set `transition_context' with `a_context'.
		do
			transition_context := a_context
		end

	set_extra_pre_state_values (a_values: like extra_pre_state_values)
			-- Set `extra_pre_state_values' with `a_values'
		do
			extra_pre_state_values := a_values
		end

	set_extra_post_state_values (a_values: like extra_post_state_values)
			-- Set `extra_post_state_values' with `a_values'
		do
			extra_post_state_values := a_values
		end

feature{NONE} -- Implementation

	initialize_data_structures
			-- Initialize data structures.
		do
			last_value := Void
			create missing_expressions.make (5)
			missing_expressions.set_equality_tester (expression_equality_tester)
		end

	set_has_error (b: BOOLEAN; a_reason: STRING)
			-- Set `has_error' with `b'.
		do
			has_error := b
			error_reason := a_reason.twin
		ensure
			has_error_set: has_error = b
		end

	equation_by_expression_ast (a_expr_as: AST_EIFFEL; a_pre_state: BOOLEAN): detachable EPA_EQUATION
			-- Equation whose expression is equal to `a_expr_as'
			-- in pre-execution state if `a_pre_state' is True, otherwise,
			-- in post-execution state.
			-- Void if no such equation is found.
		do
			Result := equation_by_expression (text_from_ast (a_expr_as), a_pre_state)
		end

	equation_by_expression (a_expr: STRING; a_pre_state: BOOLEAN): detachable EPA_EQUATION
			-- Equation whose expression is equal to `a_expr'
			-- in pre-execution state if `a_pre_state' is True, otherwise,
			-- in post-execution state.
			-- Void if no such equation is found.
		do
			Result := state_values (a_pre_state).item_with_expression_text (a_expr)
			if Result = Void then
				if attached {EPA_STATE} extra_state_values (a_pre_state) as l_state then
					Result := l_state.item_with_expression_text (a_expr)
				end
			end
		end

	evalute_unary_sequence_operator (a_sequence: MML_FINITE_SEQUENCE [EPA_EXPRESSION_VALUE]; a_operator_name: STRING)
			-- Evaluate `a_sequence' on operator `a_operator_name',
			-- Make result available in `last_value'.
		require
			a_operator_name_valid: sequence_un_operators.has (a_operator_name)
		do
			if a_operator_name ~ sequence_is_empty_un_operator then
				create {EPA_BOOLEAN_VALUE} last_value.make (a_sequence.is_empty)
			end
		end

	evalute_binary_sequence_operator (a_left, a_right: MML_FINITE_SEQUENCE [EPA_EXPRESSION_VALUE]; a_operator_name: STRING)
			-- Evaluate `a_sequence' on operator `a_operator_name',
			-- Make result available in `last_value'.
		require
			a_operator_name_valid: sequence_bin_operators.has (a_operator_name)
		local
			l_sequence: CI_SEQUENCE [EPA_EXPRESSION_VALUE]
		do
			if a_operator_name ~ sequence_is_equal_bin_operator then
				create {EPA_BOOLEAN_VALUE} last_value.make (a_left |=| a_right)

			elseif a_operator_name ~ sequence_is_prefix_of_bin_operator then
				create {EPA_BOOLEAN_VALUE} last_value.make (a_left.is_prefix_of (a_right))

			elseif a_operator_name ~ sequence_concatenation_bin_operator then
				create {EPA_ANY_VALUE} last_value.make (a_left |+| a_right)
			else
				set_has_error (True, msg_free_binary_operator_not_supported (a_operator_name))
			end
		end

feature{NONE} -- Implementation

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			process_expression (l_as)
		end

	process_expression (a_ast: AST_EIFFEL)
			-- Process `a_ast'.
		local
			l_equation: detachable EPA_EQUATION
		do
			if not has_error then
				l_equation := equation_by_expression_ast (a_ast, False)
				if l_equation /= Void then
					last_value := l_equation.value
				else
					set_has_error (True, msg_missing_expression (a_ast, False))
				end
			end
		end

	process_nested_as (l_as: NESTED_AS)
		do
			process_expression (l_as)
		end

	process_un_old_as (l_as: UN_OLD_AS)
		local
			l_expr_text: STRING
			l_equation: detachable EPA_EQUATION
		do
			if not has_error then
				l_equation := equation_by_expression_ast (l_as.expr, True)
				if l_equation /= Void then
					last_value := l_equation.value
				else
					set_has_error (True, msg_missing_expression (l_as.expr, True))
				end
			end
		end

	process_void_as (l_as: VOID_AS)
		do
			if not has_error then
				create {EPA_VOID_VALUE} last_value.make
			end
		end

	process_bool_as (l_as: BOOL_AS)
		do
			if not has_error then
				create {EPA_BOOLEAN_VALUE} last_value.make (l_as.value)
			end
		end

	process_integer_as (l_as: INTEGER_AS)
		do
			if not has_error then
				create {EPA_INTEGER_VALUE} last_value.make (l_as.integer_32_value)
			end
		end

	process_binary_boolean_operator_as (a_left: EXPR_AS; a_right: EXPR_AS; a_operator_name: STRING)
			-- Process binary boolean operator.
		local
			l_left_value: detachable EPA_BOOLEAN_VALUE
			l_right_value: detachable EPA_BOOLEAN_VALUE
			l_value: BOOLEAN
		do
			if not has_error then
					-- Process left.
				process_boolean_expression (a_left)
				if not has_error then
					l_left_value := last_value.as_boolean
				end

					-- Process right.
				if not has_error then
					process_boolean_expression (a_right)
					if not has_error then
						l_right_value := last_value.as_boolean
					end
				end

				if not has_error then
						-- Evaluate expression
					if a_operator_name ~ ti_and_keyword then
						l_value := l_left_value.item and l_right_value.item
					elseif a_operator_name ~ ti_or_keyword then
						l_value := l_left_value.item or l_right_value.item
					elseif a_operator_name ~ ti_implies_keyword then
						l_value := l_left_value.item implies l_right_value.item
					elseif a_operator_name ~ ti_xor_keyword then
						l_value := l_left_value.item xor l_right_value.item
					end

					create {EPA_BOOLEAN_VALUE} last_value.make (l_value)
				end
			end
		end

	process_boolean_expression (a_expr: EXPR_AS)
			-- Process `a_expr' as if it is a boolean expression
		do
			if not has_error then
				a_expr.process (Current)
				if not has_error then
					if not last_value.is_boolean then
						set_has_error (True, msg_type_error (a_expr, {EPA_EXPRESSION_VALUE}.boolean_type_name, last_value.type_name))
					end
				end
			end
		end

	process_integer_expression (a_expr: EXPR_AS)
			-- Process `a_expr' as if it is an integer expression
		do
			if not has_error then
				a_expr.process (Current)
				if not has_error then
					if not last_value.is_integer then
						set_has_error (True, msg_type_error (a_expr, {EPA_EXPRESSION_VALUE}.integer_type_name, last_value.type_name))
					end
				end
			end
		end

	process_bin_and_as (l_as: BIN_AND_AS)
		do
			process_binary_boolean_operator_as (l_as.left, l_as.right, ti_and_keyword)
		end

	process_bin_and_then_as (l_as: BIN_AND_THEN_AS)
		do
			process_binary_boolean_operator_as (l_as.left, l_as.right, ti_and_keyword)
		end

	process_bin_implies_as (l_as: BIN_IMPLIES_AS)
		do
			process_binary_boolean_operator_as (l_as.left, l_as.right, ti_implies_keyword)
		end

	process_bin_or_as (l_as: BIN_OR_AS)
		do
			process_binary_boolean_operator_as (l_as.left, l_as.right, ti_or_keyword)
		end

	process_bin_or_else_as (l_as: BIN_OR_ELSE_AS)
		do
			process_binary_boolean_operator_as (l_as.left, l_as.right, ti_or_keyword)
		end

	process_bin_xor_as (l_as: BIN_XOR_AS)
		do
			process_binary_boolean_operator_as (l_as.left, l_as.right, ti_xor_keyword)
		end

	process_binary_integer_operator_as (a_left: EXPR_AS; a_right: EXPR_AS; a_operator_name: STRING)
			-- Process binary integer operator.
		local
			l_left_value: detachable EPA_INTEGER_VALUE
			l_right_value: detachable EPA_INTEGER_VALUE
			l_value: INTEGER
		do
			if not has_error then
					-- Process left.
				process_integer_expression (a_left)
				if not has_error then
					l_left_value := last_value.as_integer
				end

					-- Process right.
				if not has_error then
					process_integer_expression (a_right)
					if not has_error then
						l_right_value := last_value.as_integer
					end
				end

				if not has_error then
						-- Evaluate expression
					if a_operator_name ~ "+" then
						l_value := l_left_value.item + l_right_value.item
					elseif a_operator_name ~ "-" then
						l_value := l_left_value.item - l_right_value.item
					end
					create {EPA_INTEGER_VALUE} last_value.make (l_value)
				end
			end
		end

	process_bin_minus_as (l_as: BIN_MINUS_AS)
		do
			process_binary_integer_operator_as (l_as.left, l_as.right, once "-")
		end

	process_bin_plus_as (l_as: BIN_PLUS_AS)
		do
			process_binary_integer_operator_as (l_as.left, l_as.right, once "+")
		end

	process_binary_integer_relation_operator_as (a_left: EXPR_AS; a_right: EXPR_AS; a_operator_name: STRING)
			-- Process binary integer relation_operator.
		local
			l_left_value: detachable EPA_INTEGER_VALUE
			l_right_value: detachable EPA_INTEGER_VALUE
			l_value: BOOLEAN
		do
			if not has_error then
					-- Process left.
				process_integer_expression (a_left)
				if not has_error then
					l_left_value := last_value.as_integer
				end

					-- Process right.
				if not has_error then
					process_integer_expression (a_right)
					if not has_error then
						l_right_value := last_value.as_integer
					end
				end

				if not has_error then
						-- Evaluate expression
					if a_operator_name ~ ">" then
						l_value := l_left_value.item > l_right_value.item
					elseif a_operator_name ~ "<" then
						l_value := l_left_value.item < l_right_value.item
					elseif a_operator_name ~ ">=" then
						l_value := l_left_value.item >= l_right_value.item
					elseif a_operator_name ~ "<=" then
						l_value := l_left_value.item <= l_right_value.item
					end
					create {EPA_BOOLEAN_VALUE} last_value.make (l_value)
				end
			end
		end

	process_bin_ge_as (l_as: BIN_GE_AS)
		do
			process_binary_integer_relation_operator_as (l_as.left, l_as.right, once ">=")
		end

	process_bin_gt_as (l_as: BIN_GT_AS)
		do
			process_binary_integer_relation_operator_as (l_as.left, l_as.right, once ">")
		end

	process_bin_le_as (l_as: BIN_LE_AS)
		do
			process_binary_integer_relation_operator_as (l_as.left, l_as.right, once "<=")
		end

	process_bin_lt_as (l_as: BIN_LT_AS)
		do
			process_binary_integer_relation_operator_as (l_as.left, l_as.right, once "<")
		end

	process_binary_equality_relation_operator_as (a_left: EXPR_AS; a_right: EXPR_AS; a_operator_name: STRING)
			-- Process binary equality related operator (= or /=).
		local
			l_left_value: detachable EPA_EXPRESSION_VALUE
			l_right_value: detachable EPA_EXPRESSION_VALUE
			l_value: BOOLEAN
		do
			if not has_error then
					-- Process left.
				a_left.process (Current)
				if not has_error then
					l_left_value := last_value
				end

					-- Process right.
				if not has_error then
					a_right.process (Current)
					if not has_error then
						l_right_value := last_value
					end
				end

				if not has_error then
						-- Evaluate expression
					if a_operator_name ~ "=" then
						l_value := expression_value_equality_tester.test (l_left_value, l_right_value)
					elseif a_operator_name ~ "/=" then
						l_value := not expression_value_equality_tester.test (l_left_value, l_right_value)
					end
					create {EPA_BOOLEAN_VALUE} last_value.make (l_value)
				end
			end
		end

	process_bin_eq_as (l_as: BIN_EQ_AS)
		local
		do
			process_binary_equality_relation_operator_as (l_as.left, l_as.right, once "=")
		end

	process_bin_ne_as (l_as: BIN_NE_AS)
		do
			process_binary_equality_relation_operator_as (l_as.left, l_as.right, once "/=")
		end

	process_un_not_as (l_as: UN_NOT_AS)
		do
			process_unary_as (l_as)
			if not has_error then
				process_boolean_expression (l_as.expr)
				if not has_error then
					create {EPA_BOOLEAN_VALUE} last_value.make (not last_value.as_boolean.item)
				end
			end
		end

	process_bin_tilde_as (l_as: BIN_TILDE_AS)
		do
			if not has_error then
				process_expression (l_as)
			end
		end

	process_bin_not_tilde_as (l_as: BIN_NOT_TILDE_AS)
		do
			if not has_error then
				process_expression (l_as)
			end
		end

	process_tuple_as (l_as: TUPLE_AS)
		do
			process_expression (l_as)
		end

	process_un_free_as (l_as: UN_FREE_AS)
		local
			l_sequence: like sequence_value
			l_operator: STRING
		do
			if not has_error then
				l_operator := l_as.operator_name
				process_unary_as (l_as)
				if not has_error and then sequence_un_operators.has (l_operator) then
					l_sequence := sequence_value (last_value)
					if l_sequence /= Void then
						evalute_unary_sequence_operator (l_sequence, l_operator)
					else
						set_has_error (True, msg_sequence_value_expected (l_operator, last_value))
					end
				else
					set_has_error (True, msg_free_unary_operator_not_supported (l_operator))
				end
			end
		end

	process_bin_free_as (l_as: BIN_FREE_AS)
		local
			l_left, l_right: like sequence_value
			l_operator: STRING
		do
			if not has_error then
				l_operator := l_as.op_name.name
				if sequence_bin_operators.has (l_operator) then
					l_as.left.process (Current)
					if not has_error then
						l_left := sequence_value (last_value)
						if l_left /= Void then
							l_as.right.process (Current)
							if not has_error then
								l_right := sequence_value (last_value)
								if l_right /= Void then
									evalute_binary_sequence_operator (l_left, l_right, l_operator)
								else
									set_has_error (True, msg_sequence_value_expected (l_operator, last_value))
								end
							end
						else
							set_has_error (True, msg_sequence_value_expected (l_operator, last_value))
						end
					end
				else
					set_has_error (True, msg_free_binary_operator_not_supported (l_operator))
				end
			end
		end
feature -- Error messages

	msg_missing_expression (a_expr_as: AST_EIFFEL; a_pre_state: BOOLEAN): STRING
			-- Message reporting that expressions `a_expr_as' is mising in state values.
		do
			create Result.make (64)
			Result.append (once "Expression missing: %"")
			Result.append (text_from_ast (a_expr_as))
			Result.append (once "%" is missing in ")
			Result.append (state_phase_name (a_pre_state))
		end

	msg_type_error (a_expr_as: EXPR_AS; a_expected_type: STRING; a_actual_type: STRING): STRING
			-- Message reporting a type error
		do
			create Result.make (64)
			Result.append (once "Type error: type of expression %"")
			Result.append (text_from_ast (a_expr_as))
			Result.append (once "should be ")
			Result.append (a_expected_type)
			Result.append (once ", but it is ")
			Result.append (a_actual_type)
		end

	msg_sequence_value_expected (a_operator: STRING; a_value: detachable EPA_EXPRESSION_VALUE): STRING
			-- Message reporting that a required value of type sequence is missing
		local
			l_value: STRING
		do
			if a_value = Void then
				l_value := "Void"
			else
				l_value := a_value.out
			end
			create Result.make (64)
			Result.append ("For sequence operator %"" + a_operator + "%", a value of type sequence is expected, but got " + l_value)
		end

	msg_free_unary_operator_not_supported (a_operator: STRING): STRING
			-- Message reporting that free unary operator `a_operator' is not supported.
		do
			create Result.make (64)
			Result.append ("Free unary operator %"")
			Result.append (a_operator)
			Result.append ("%" is not supported.")
		end

	msg_free_binary_operator_not_supported (a_operator: STRING): STRING
			-- Message reporting that free binary operator `a_operator' is not supported.
		do
			create Result.make (64)
			Result.append ("Free binary operator %"")
			Result.append (a_operator)
			Result.append ("%" is not supported.")
		end

	state_phase_name (a_pre_state: BOOLEAN): STRING
			-- State phase name
		do
			create Result.make (11)
			if a_pre_state then
				Result.append (once "pre-state")
			else
				Result.append (once "post_state")
			end
		end

end
