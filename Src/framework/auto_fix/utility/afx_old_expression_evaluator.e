note
	description: "Summary description for {AFX_OLD_EXPRESSION_EVALUATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_OLD_EXPRESSION_EVALUATOR

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
			process_expr_call_as
		end

	EPA_SHARED_EQUALITY_TESTERS

	EPA_UTILITY

	SHARED_TEXT_ITEMS

	ETR_PARSING_HELPER
		select
			error_handler
		end

feature -- Basic operation

	evaluate (a_feature: EPA_FEATURE_WITH_CONTEXT_CLASS; a_text: STRING; a_post_state, a_pre_state: EPA_STATE)
		local
			l_creator: EPA_AST_EXPRESSION_SAFE_CREATOR
			l_expression: EPA_AST_EXPRESSION
			l_ast: AST_EIFFEL
		do
			context_feature := a_feature
			post_state := a_post_state
			pre_state := a_pre_state

			initialize_data_structures
			l_expression := l_creator.safe_create_with_text (a_feature.context_class, a_feature.feature_, a_text, a_feature.written_class)
			if l_expression /= Void then
				l_ast := l_expression.ast
				l_ast.process (Current)
			end
		end

	initialize_data_structures
			-- Initialize data structures.
		do
			last_value := Void
			wipe_out_error
		end


feature -- Access evaluation result

	last_value: EPA_EXPRESSION_VALUE
			-- Value of the last evaluated expression by `evaluate'

feature -- Access initial evaluation context

	context_feature: EPA_FEATURE_WITH_CONTEXT_CLASS

	post_state: EPA_STATE
			-- Values in post-state

	pre_state: EPA_STATE
			-- Values in pre-state

feature -- Status report

	is_ternary_logic_enabled: BOOLEAN = True

	has_error: BOOLEAN
			-- Was an error during last expression evaluation?

	error_reason: detachable STRING
			-- Reason for the last error

feature -- Setting

	wipe_out_error
			-- Wipe all error
		do
			has_error := False
			error_reason := ""
		end

feature{NONE} -- Implementation

	state (a_pre_state: BOOLEAN): EPA_STATE
			-- Return `pre_state' if `a_pre_state';
			-- Return `post_state' otherwise.
		do
			if a_pre_state then
				Result := pre_state
			else
				Result := post_state
			end
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
			-- use pre state values if `a_pre_state' is True, otherwise,
			-- use post state values.
			-- Void if no such equation is found.
		do
			Result := equation_by_expression (text_from_ast (a_expr_as), a_pre_state)
		end

	equation_by_expression (a_expr: STRING; a_pre_state: BOOLEAN): detachable EPA_EQUATION
			-- Equation whose expression is equal to `a_expr'
			-- use pre state values if `a_pre_state' is True, otherwise,
			-- use post state values.
			-- Void if no such equation is found.
		do
			if attached state (a_pre_state) as lt_state_values then
				Result := lt_state_values.item_with_expression_text (a_expr)
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

	process_expr_call_as (l_as: EXPR_CALL_AS)
		do
			process_expression (l_as)
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
						elseif a_operator_name ~ ti_and_then_keyword then
							l_value := l_left_value.as_boolean.item and then l_right_value.as_boolean.item
						elseif a_operator_name ~ ti_or_keyword then
							l_value := l_left_value.as_boolean.item or l_right_value.as_boolean.item
						elseif a_operator_name ~ ti_or_else_keyword then
							l_value := l_left_value.as_boolean.item or else l_right_value.as_boolean.item
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
							elseif a_operator_name ~ ti_or_keyword or a_operator_name ~ ti_or_else_keyword or a_operator_name ~ ti_implies_keyword then
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
							elseif a_operator_name ~ ti_or_keyword or a_operator_name ~ ti_or_else_keyword then
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
							create {EPA_NONSENSICAL_VALUE} last_value
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
						set_has_error (True, "type error")
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
						set_has_error (True, "type error")
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
			l_equation: detachable EPA_EQUATION
		do
			if not has_error then
				l_equation := equation_by_expression_ast (l_as, False)
				if l_equation /= Void and then not l_equation.value.is_nonsensical then
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
				if l_equation /= Void and then not l_equation.value.is_nonsensical then
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
						create {EPA_NONSENSICAL_VALUE} last_value
					end
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


feature -- Error messages

	msg_missing_expression (a_expr_as: AST_EIFFEL; a_old_state: BOOLEAN): STRING
			-- Message reporting that expressions `a_expr_as' is mising in state values.
		do
			create Result.make (64)
			Result.append (once "Expression missing: %"")
			Result.append (text_from_ast (a_expr_as))
			Result.append (once "%" is missing in ")
		end


end
