note
	description: "Summary description for {AFX_REFERENCE_COMPARISON_OPERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_REFERENCE_COMPARISON_OPERATOR

inherit
	ANY
		undefine
			is_equal,
			copy
		end

feature -- Basic operator

	evaluate_reference_comparison (a_left_value, a_right_value: EPA_EXPRESSION_VALUE; a_operator: INTEGER): EPA_EXPRESSION_VALUE
			-- applying `a_operator' to `a_left_value' and `a_right_value',
			--		and return the result value.
			-- If one value is Void or {NONSENSICAL}, the result would be {NONSENSICAL}.
		require
			operator_valid: is_valid_reference_comparison (a_operator)
		local
			l_left, l_right: STRING
		do
			if a_left_value /= Void and then attached {EPA_REFERENCE_VALUE} a_left_value as lt_left
					and then a_right_value /= Void and then attached {EPA_REFERENCE_VALUE} a_right_value as lt_right then
				l_left := lt_left.item
				l_right := lt_right.item

				inspect a_operator
				when Operator_reference_eq then
					create {EPA_BOOLEAN_VALUE} Result.make (l_left ~ l_right)
				when Operator_reference_ne then
					create {EPA_BOOLEAN_VALUE} Result.make (l_left /~ l_right)
				else
					check should_not_happend: False end
				end
			else
				create {EPA_NONSENSICAL_VALUE} Result
			end
		end

	negation_operator (a_operator_value: INTEGER): INTEGER
			-- Negation of the operator `a_operator_value'.
		require
			valid_operator: is_valid_reference_comparison (a_operator_value)
		do
			Result := Operator_reference_ub - a_operator_value
		end

feature -- Status report

	is_valid_reference_comparison (a_operator: INTEGER): BOOLEAN
			-- Is `a_operator' a valid reference comparison operator?
		do
			Result := Operator_reference_lb < a_operator and then a_operator < Operator_reference_ub
		end

feature -- Output

	operator_text (a_operator: INTEGER): STRING
			-- Text of an operator.
		require
			operator_valid: is_valid_reference_comparison (a_operator)
		do
			inspect a_operator
			when Operator_reference_eq then
				Result := "="
			when Operator_reference_ne then
				Result := "/="
			else
				check False end
			end
		end

feature -- Constant

	Operator_reference_lb: INTEGER = 0
	Operator_reference_eq: INTEGER = 1
	Operator_reference_ne: INTEGER = 2
	Operator_reference_ub: INTEGER = 3

end
