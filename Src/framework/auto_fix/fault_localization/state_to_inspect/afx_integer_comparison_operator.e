note
	description: "Summary description for {AFX_INTEGER_COMPARISON_OPERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_INTEGER_COMPARISON_OPERATOR

inherit
	ANY
		undefine
			is_equal,
			copy
		end

feature -- Basic operator

	evaluate_integer_comparison (a_left_value, a_right_value: EPA_EXPRESSION_VALUE; a_operator: INTEGER): EPA_EXPRESSION_VALUE
			-- Evaluate applying `a_operator' to `a_left_value' and `a_right_value', as integer valus,
			--		and return the result value.
			-- If one value is Void or {NONSENSICAL}, the result would be {NONSENSICAL}.
		require
			operator_valid: is_valid_integer_comparison (a_operator)
		local
			l_left, l_right: INTEGER
		do
			if (a_left_value /= Void and then attached {EPA_INTEGER_VALUE} a_left_value as lt_left)
					and then (a_right_value /= Void and then attached {EPA_INTEGER_VALUE} a_right_value as lt_right)
			then
				l_left := lt_left.item
				l_right := lt_right.item

				inspect a_operator
				when Operator_integer_eq then
					create {EPA_BOOLEAN_VALUE} Result.make (l_left = l_right)
				when Operator_integer_ne then
					create {EPA_BOOLEAN_VALUE} Result.make (l_left /= l_right)
				when Operator_integer_gt then
					create {EPA_BOOLEAN_VALUE} Result.make (l_left > l_right)
				when Operator_integer_ge then
					create {EPA_BOOLEAN_VALUE} Result.make (l_left >= l_right)
				when Operator_integer_lt then
					create {EPA_BOOLEAN_VALUE} Result.make (l_left < l_right)
				when Operator_integer_le then
					create {EPA_BOOLEAN_VALUE} Result.make (l_left <= l_right)
				else
					check should_not_happend: False end
				end
			else
				create {EPA_NONSENSICAL_VALUE} Result
			end
		end

feature -- Status report

	is_valid_integer_comparison (a_operator: INTEGER): BOOLEAN
			-- Is `a_operator' a valid integer comparison operator?
		do
			Result := Operator_integer_lb < a_operator and then a_operator < Operator_integer_ub
		end

feature -- Output

	operator_text (a_operator: INTEGER): STRING
			-- Text of an operator.
		require
			operator_valid: is_valid_integer_comparison (a_operator)
		do
			inspect a_operator
			when Operator_integer_eq then
				Result := "="
			when Operator_integer_ne then
				Result := "/="
			when Operator_integer_gt then
				Result := ">"
			when Operator_integer_ge then
				Result := ">="
			when Operator_integer_lt then
				Result := "<"
			when Operator_integer_le then
				Result := "<="
			else
				check False end
			end
		end

feature -- Constant

	Operator_integer_lb: INTEGER = 0
	Operator_integer_eq: INTEGER = 1
	Operator_integer_ne: INTEGER = 2
	Operator_integer_gt: INTEGER = 3
	Operator_integer_ge: INTEGER = 4
	Operator_integer_lt: INTEGER = 5
	Operator_integer_le: INTEGER = 6
	Operator_integer_ub: INTEGER = 7

end
