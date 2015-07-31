note
	description: "Evaluator to evaluate expressions in the context of collected state expressions"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXPRESSION_EVALUATOR

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
			process_bin_free_as,
			process_current_as,
			process_bin_star_as,
			process_bin_slash_as,
			process_bin_div_as,
			process_bin_mod_as
		end

	EPA_SHARED_EQUALITY_TESTERS

	EPA_UTILITY

	SHARED_TEXT_ITEMS

	ETR_PARSING_HELPER
		select
			error_handler
		end

feature -- Access

	prestate: EPA_STATE
			-- Values in pre-state

	poststate: EPA_STATE
			-- Values in post-state

	context_class: CLASS_C
			-- Context class for expression evaluation

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
			Result := prestate
		end

	post_state_values: EPA_STATE
			-- Expressions values from pre-execution state
		do
			Result := poststate
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

	sequence_value (a_value: EPA_EXPRESSION_VALUE): detachable ANY
			-- Sequence value out of `a_value', if not possible, return the original `a_value'
		do
			Result := a_value
		end

feature -- Status report

	has_error: BOOLEAN
			-- Was an error during last expression evaluation?

	error_reason: detachable STRING
			-- Reason for the last error

	is_ternary_logic_enabled: BOOLEAN
			-- Is ternary logic enabled?
			-- So nonsensical values can be used in boolean algebra?
			-- Default: False

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
			setup_formal_parameters (l_parser, context_class)
			Entity_feature_parser.set_syntax_version (Entity_feature_parser.Provisional_syntax)
			l_parser.parse_from_utf8_string (once "check " + a_string, context_class)
			check l_parser.expression_node /= Void end
			evaluate (l_parser.expression_node)
		end

feature -- Setting

	set_context (a_prestate: like prestate; a_poststate: like poststate; a_context_class: like context_class)
			-- Setup context.
		do
			prestate := a_prestate
			poststate := a_poststate
			context_class := a_context_class
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

	set_is_ternary_logic_enabled (b: BOOLEAN)
			-- Set `is_ternary_logic_enabled' with `b'.
		do
			is_ternary_logic_enabled := b
		ensure
			is_ternary_logic_enabled_set: is_ternary_logic_enabled = b
		end

	wipe_out_error
			-- Wipe all error
		do
			has_error := False
			error_reason := ""
		end

feature{NONE} -- Implementation

	initialize_data_structures
			-- Initialize data structures.
		do
			last_value := Void
			create missing_expressions.make (5)
			missing_expressions.set_equality_tester (expression_equality_tester)
			wipe_out_error
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
--					if Result /= Void and then attached {EPA_ANY_VALUE} Result.value as l_any then
--						if attached {CI_SEQUENCE [EPA_EXPRESSION_VALUE]} l_any.item as l_sequence then
--							if log_manager /= Void then
--								log_manager.put_line_at_info_level ("%T" + a_expr + " == " + l_sequence.out + "%N")
--							end
--						elseif attached {MML_FINITE_SEQUENCE [EPA_EXPRESSION_VALUE]} l_any.item as l_sequence then
--							if log_manager /= Void then
--								log_manager.put_line_at_info_level ("%T" + a_expr + " == " + l_sequence.out + "%N")
--							end
--						end
--					end
				end
			end
		end

--	evalute_unary_sequence_operator (a_sequence: MML_FINITE_SEQUENCE [EPA_EXPRESSION_VALUE]; a_operator_name: STRING)
--			-- Evaluate `a_sequence' on operator `a_operator_name',
--			-- Make result available in `last_value'.
--		require
--			a_operator_name_valid: sequence_un_operators.has (a_operator_name)
--		do
--			if a_operator_name ~ sequence_is_empty_un_operator then
--				create {EPA_BOOLEAN_VALUE} last_value.make (a_sequence.is_empty)
--			elseif a_operator_name ~ sequence_count_un_operator then
--				create {EPA_INTEGER_VALUE} last_value.make (a_sequence.count)
--			end
--		end

--	evalute_binary_sequence_operator (a_left, a_right: ANY; a_operator_name: STRING)
--			-- Evaluate `a_sequence' on operator `a_operator_name',
--			-- Make result available in `last_value'.
--		require
--			a_operator_name_valid: sequence_bin_operators.has (a_operator_name)
--		local
--			l_sequence: CI_SEQUENCE [EPA_EXPRESSION_VALUE]
--		do
--			if a_operator_name ~ sequence_is_equal_bin_operator then
--				if
--					attached {MML_FINITE_SEQUENCE [EPA_EXPRESSION_VALUE]} a_left as l_left and then
--					attached {MML_FINITE_SEQUENCE [EPA_EXPRESSION_VALUE]} a_right as l_right
--				then
--					create {EPA_BOOLEAN_VALUE} last_value.make (l_left |=| l_right)
--				else
--					set_has_error (True, msg_type_error_sequence_expected)
--				end

--			elseif a_operator_name ~ sequence_is_prefix_of_bin_operator then
--				if
--					attached {MML_FINITE_SEQUENCE [EPA_EXPRESSION_VALUE]} a_left as l_left and then
--					attached {MML_FINITE_SEQUENCE [EPA_EXPRESSION_VALUE]} a_right as l_right
--				then
--					create {EPA_BOOLEAN_VALUE} last_value.make (l_left.is_prefix_of (l_right))
--				else
--					set_has_error (True, msg_type_error_sequence_expected)
--				end

--			elseif a_operator_name ~ sequence_is_suffix_of_bin_operator then
--				if
--					attached {MML_FINITE_SEQUENCE [EPA_EXPRESSION_VALUE]} a_left as l_left and then
--					attached {MML_FINITE_SEQUENCE [EPA_EXPRESSION_VALUE]} a_right as l_right
--				then
--					create {EPA_BOOLEAN_VALUE} last_value.make (l_left.is_suffix_of (l_right))
--				else
--					set_has_error (True, msg_type_error_sequence_expected)
--				end

--			elseif a_operator_name ~ sequence_concatenation_bin_operator then
--				if
--					attached {MML_FINITE_SEQUENCE [EPA_EXPRESSION_VALUE]} a_left as l_left and then
--					attached {MML_FINITE_SEQUENCE [EPA_EXPRESSION_VALUE]} a_right as l_right
--				then
--					create {EPA_ANY_VALUE} last_value.make (l_left |+| l_right)
--				else
--					set_has_error (True, msg_type_error_sequence_expected)
--				end

--			elseif a_operator_name ~ sequence_head_bin_operator then
--				if
--					attached {MML_FINITE_SEQUENCE [EPA_EXPRESSION_VALUE]} a_left as l_left and then
--					attached {EPA_INTEGER_VALUE} a_right as l_right
--				then
--					create {EPA_ANY_VALUE} last_value.make (l_left.front (l_right.item - l_left.lower_bound + 1))
--				else
--					set_has_error (True, msg_type_error_sequence_expected)
--				end
--			elseif a_operator_name ~ sequence_tail_bin_operator then
--				if
--					attached {MML_FINITE_SEQUENCE [EPA_EXPRESSION_VALUE]} a_left as l_left and then
--					attached {EPA_INTEGER_VALUE} a_right as l_right
--				then
--					create {EPA_ANY_VALUE} last_value.make (l_left.tail (l_right.item - l_left.lower_bound + 1))
--				else
--					set_has_error (True, msg_type_error_sequence_expected)
--				end
--			else
--				set_has_error (True, msg_free_binary_operator_not_supported (a_operator_name))
--			end
--		end

feature{NONE} -- Implementation

	process_current_as (l_as: CURRENT_AS)
		do
			process_expression (l_as)
		end

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
				if attached {PARAN_AS} l_as.expr as l_paran then
					l_equation := equation_by_expression_ast (l_paran.expr, True)
				else
					l_equation := equation_by_expression_ast (l_as.expr, True)
				end

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
			l_left_value: like last_value
			l_right_value: like last_value
			l_value: BOOLEAN
		do
			if not has_error then
					-- Process left.
				process_boolean_expression (a_left)
				if not has_error then
					l_left_value := last_value
				end

					-- Process right.
				if not has_error then
					process_boolean_expression (a_right)
					if not has_error then
						l_right_value := last_value
					end
				end

				if not has_error then
					if l_left_value.is_boolean and then l_right_value.is_boolean then
							-- Evaluate expression
						if a_operator_name ~ ti_and_keyword then
							l_value := l_left_value.as_boolean.item and l_right_value.as_boolean.item
						elseif a_operator_name ~ ti_or_keyword then
							l_value := l_left_value.as_boolean.item or l_right_value.as_boolean.item
						elseif a_operator_name ~ ti_implies_keyword then
							l_value := l_left_value.as_boolean.item implies l_right_value.as_boolean.item
						elseif a_operator_name ~ ti_xor_keyword then
							l_value := l_left_value.as_boolean.item xor l_right_value.as_boolean.item
						end

						create {EPA_BOOLEAN_VALUE} last_value.make (l_value)
					elseif is_ternary_logic_enabled then
						if l_left_value.is_nonsensical and then l_right_value.is_nonsensical then
							create {EPA_NONSENSICAL_VALUE} last_value
						elseif l_left_value.is_nonsensical and then l_right_value.is_boolean then
							if a_operator_name ~ ti_and_keyword then
								create {EPA_NONSENSICAL_VALUE} last_value
							elseif a_operator_name ~ ti_or_keyword or a_operator_name ~ ti_implies_keyword then
								if l_right_value.as_boolean.is_true then
									create {EPA_BOOLEAN_VALUE} last_value.make (True)
								else
									create {EPA_NONSENSICAL_VALUE} last_value
								end
							elseif a_operator_name ~ ti_xor_keyword then
								create {EPA_NONSENSICAL_VALUE} last_value
							end
						elseif l_left_value.is_boolean and then l_right_value.is_nonsensical then
							if a_operator_name ~ ti_and_keyword then
								create {EPA_NONSENSICAL_VALUE} last_value
							elseif a_operator_name ~ ti_or_keyword then
								if l_left_value.as_boolean.is_true then
									create {EPA_BOOLEAN_VALUE} last_value.make (True)
								else
									create {EPA_NONSENSICAL_VALUE} last_value
								end
							elseif a_operator_name ~ ti_implies_keyword then
								if l_left_value.as_boolean.is_false then
									create {EPA_BOOLEAN_VALUE} last_value.make (True)
								else
									create {EPA_NONSENSICAL_VALUE} last_value
								end
							elseif a_operator_name ~ ti_xor_keyword then
								create {EPA_NONSENSICAL_VALUE} last_value
							end
						else
							set_has_error (True, msg_type_error_boolean_value_expected)
						end
					end
				end
			end
		end

	process_boolean_expression (a_expr: EXPR_AS)
			-- Process `a_expr' as if it is a boolean expression
		local
			l_value: like last_value
		do
			if not has_error then
				a_expr.process (Current)
				if not has_error then
					l_value := last_value
					if l_value.is_boolean or else (l_value.is_nonsensical and then is_ternary_logic_enabled) then
					else
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
					if a_operator_name ~ once "+" then
						l_value := l_left_value.item + l_right_value.item
					elseif a_operator_name ~ once "-" then
						l_value := l_left_value.item - l_right_value.item
					elseif a_operator_name ~ once "*" then
						l_value := l_left_value.item * l_right_value.item
					elseif a_operator_name ~ once "//" then
						l_value := l_left_value.item // l_right_value.item
					elseif a_operator_name ~ once "\\" then
						l_value := l_left_value.item \\ l_right_value.item
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
			l_equation: detachable EPA_EQUATION
		do
			if not has_error then
				l_equation := equation_by_expression_ast (l_as, False)
				if l_equation /= Void then
					last_value := l_equation.value
				else
					process_binary_equality_relation_operator_as (l_as.left, l_as.right, once "=")
				end
			end
		end

	process_bin_ne_as (l_as: BIN_NE_AS)
		local
			l_equation: detachable EPA_EQUATION
		do
			if not has_error then
				l_equation := equation_by_expression_ast (l_as, False)
				if l_equation /= Void then
					last_value := l_equation.value
				else
					process_binary_equality_relation_operator_as (l_as.left, l_as.right, once "/=")
				end
			end
		end

	process_un_not_as (l_as: UN_NOT_AS)
		local
			l_value: like last_value
		do
			process_unary_as (l_as)
			if not has_error then
				process_boolean_expression (l_as.expr)
				l_value := last_value
				if not has_error then
					if l_value.is_boolean then
						create {EPA_BOOLEAN_VALUE} last_value.make (not last_value.as_boolean.item)
					elseif l_value.is_nonsensical and then is_ternary_logic_enabled then
						create {EPA_NONSENSICAL_VALUE} last_value
					else
						set_has_error (True, msg_type_error_boolean_value_expected)
					end
				end
			end
		end

	process_bin_tilde_as (l_as: BIN_TILDE_AS)
		local
			l_equation: EPA_EQUATION
			l_ast: BIN_TILDE_AS
			l_left: EXPR_AS
			l_right: EXPR_AS
			l_left_value: EPA_REFERENCE_VALUE
			l_right_value: EPA_REFERENCE_VALUE
			l_set: BOOLEAN
		do
			if not has_error then
				l_left := l_as.left
				l_right := l_as.right
				safe_process (l_left)
				if not has_error then
					if attached {EPA_REFERENCE_VALUE} last_value as l_lvalue then
						l_left_value := l_lvalue
						safe_process (l_right)
						if not has_error then
							if attached {EPA_REFERENCE_VALUE} last_value as l_rvalue then
								l_right_value := l_rvalue
								create {EPA_BOOLEAN_VALUE} last_value.make (
									(l_left_value.object_equivalent_class_id = l_right_value.object_equivalent_class_id) and
									l_left_value.object_equivalent_class_id > 0 and
									l_right_value.object_equivalent_class_id > 0)
								l_set := True
							end
						end
					end
				end

				if not has_error and then not l_set then
					create {EPA_BOOLEAN_VALUE} last_value.make (False)
				end
			end
		end

	process_bin_not_tilde_as (l_as: BIN_NOT_TILDE_AS)
		local
			l_ast: BIN_TILDE_AS
			l_operator: SYMBOL_STUB_AS
		do
			if not has_error then
				create l_operator.make ({EIFFEL_TOKENS}.te_tilde, 0, 0, 0, 0, 0, 0, 0)
				create l_ast.initialize (l_as.left, l_as.right, l_operator)
				process_bin_tilde_as (l_ast)
				if attached {EPA_BOOLEAN_VALUE} last_value as l_last_value then
					create {EPA_BOOLEAN_VALUE} last_value.make (not l_last_value.item)
				else
					set_has_error (True, "Wrong object equality evaluation")
				end
			end
		end

	process_tuple_as (l_as: TUPLE_AS)
		do
			process_expression (l_as)
		end

	process_un_free_as (l_as: UN_FREE_AS)
		local
			l_operator: STRING
		do
			if not has_error then
				l_operator := l_as.operator_name
				set_has_error (True, msg_free_unary_operator_not_supported (l_operator))
			end
		end

	process_bin_free_as (l_as: BIN_FREE_AS)
		local
			l_left, l_right: like sequence_value
			l_operator: STRING
		do
			if not has_error then
				l_operator := l_as.op_name.name
				set_has_error (True, msg_free_binary_operator_not_supported (l_operator))
			end
		end

	process_bin_slash_as (l_as: BIN_SLASH_AS)
		do
			process_binary_integer_operator_as (l_as.left, l_as.right, once "//")
		end

	process_bin_star_as (l_as: BIN_STAR_AS)
		do
			process_binary_integer_operator_as (l_as.left, l_as.right, once "*")
		end

	process_bin_div_as (l_as: BIN_DIV_AS)
		do
			process_binary_integer_operator_as (l_as.left, l_as.right, once "//")
		end

	process_bin_mod_as (l_as: BIN_MOD_AS)
		do
			process_binary_integer_operator_as (l_as.left, l_as.right, once "\\")
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

	msg_type_error_sequence_expected: STRING = "A sequence value is expected."

	msg_type_error_boolean_value_expected: STRING = "A boolean value is expected."

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
