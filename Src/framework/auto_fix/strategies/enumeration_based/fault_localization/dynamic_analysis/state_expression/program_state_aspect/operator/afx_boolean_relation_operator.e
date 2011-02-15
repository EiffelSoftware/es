note
	description: "Summary description for {AFX_BOOLEAN_RELATION_OPERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_BOOLEAN_RELATION_OPERATOR

inherit
	ANY
		undefine
			is_equal,
			copy
		end

feature -- Basic operator

	evaluate_boolean_relation (a_left_value, a_right_value: EPA_EXPRESSION_VALUE; a_operator: INTEGER): EPA_EXPRESSION_VALUE
			-- Evaluate the result of applying `a_operator' to `a_left_value' and `a_right_value', as boolean operands,
			--		and return the result.
		require
			operator_valid: is_valid_boolean_operator (a_operator)
		local
			l_left_valid, l_right_valid, l_left, l_right, l_result, l_result_valid: BOOLEAN

		do
			if attached {EPA_BOOLEAN_VALUE} a_left_value as lt_left then
				l_left := lt_left.item
				l_left_valid := True
			end

			if attached {EPA_BOOLEAN_VALUE} a_right_value as lt_right then
				l_right := lt_right.item
				l_right_valid := True
			end

			inspect a_operator
			when Operator_boolean_null then
				if l_left_valid then
					l_result := l_left
					l_result_valid := True
				end
			when Operator_boolean_negation then
				if l_left_valid then
					l_result := not l_left
					l_result_valid := True
				end
			when Operator_boolean_equal then
				if l_left_valid and then l_right_valid then
					l_result := l_left = l_right
					l_result_valid := True
				end
			when Operator_boolean_implies then
				if l_left_valid and then l_right_valid then
					l_result := l_left implies l_right
					l_result_valid := True
				end
			when Operator_boolean_and_then then
				if l_left_valid then
					if l_left then
						-- The right operand is only evaluated when the first operand is True.
						if l_right_valid then
							l_result := l_right
							l_result_valid := True
						else
							-- l_result_valid := False
						end
					else
						-- The right operand
						l_result := False
						l_result_valid := True
					end
				else
					-- l_result_valid := False
				end
			when Operator_boolean_and then
				if l_left_valid and then l_right_valid then
					l_result := l_left and l_right
					l_result_valid := True
				end
			when Operator_boolean_or_else then
				if l_left_valid then
					if not l_left then
						-- The right operand is only evaluated when the first operand is False.
						if l_right_valid then
							l_result := l_right
							l_result_valid := True
						else
							-- l_result_valid := False
						end
					else
						-- The left operand being True gives the result True.
						l_result := True
						l_result_valid := True
					end
				else
					-- l_result_valid := False
				end
			when Operator_boolean_or then
				if l_left_valid and then l_right_valid then
					l_result := l_left or l_right
					l_result_valid := True
				end
			else
				check False end
			end

			if l_result_valid then
				create {EPA_BOOLEAN_VALUE} Result.make (l_result)
			else
				create {EPA_NONSENSICAL_VALUE} Result
			end
		end

feature -- Status report

	is_valid_boolean_operator (a_operator: INTEGER): BOOLEAN
			-- Is `a_operator' a valid operator?
		do
			Result := Operator_boolean_lb < a_operator and then a_operator < Operator_boolean_ub
		end

	is_unary_boolean_operator (a_operator: INTEGER): BOOLEAN
			-- Is `a_operator' an unary boolean operator?
		do
			Result := a_operator = Operator_boolean_null or a_operator = Operator_boolean_negation
		end

	is_binary_boolean_operator (a_operator: INTEGER): BOOLEAN
			-- Is `a_operator' a binary boolean operator?
		do
			Result := Operator_boolean_equal <= a_operator and a_operator <= Operator_boolean_or
		end

feature -- Output

	boolean_operator_text (a_operator: INTEGER): STRING
			-- Text of an operator.
		require
			operator_valid: is_valid_boolean_operator (a_operator)
		do
			inspect a_operator
			when Operator_boolean_null then
				Result := ""
			when Operator_boolean_negation then
				Result := "not"
			when Operator_boolean_equal then
				Result := "="
			when Operator_boolean_implies then
				Result := "implies"
			when Operator_boolean_and_then then
				Result := "and then"
			when Operator_boolean_and then
				Result := "and"
			when Operator_boolean_or_else then
				Result := "or else"
			when Operator_boolean_or then
				Result := "or"
			else
				check False end
			end
		end

feature -- Constant

	Operator_boolean_lb: INTEGER = 99
	Operator_boolean_null: INTEGER = 100
	Operator_boolean_negation: INTEGER = 101
	Operator_boolean_equal: INTEGER = 102
	Operator_boolean_implies: INTEGER = 103
	Operator_boolean_and_then: INTEGER = 104
	Operator_boolean_and: INTEGER = 105
	Operator_boolean_or_else: INTEGER = 106
	Operator_boolean_or: INTEGER = 107
	Operator_boolean_ub: INTEGER = 108

end
