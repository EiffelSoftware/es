note
	description: "Summary description for {AFX_VOID_CHECK_OPERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_VOID_CHECK_OPERATOR

inherit
	ANY
		undefine
			is_equal,
			copy
		end

feature -- Basic operation

	evaluate_void_check (a_value: EPA_EXPRESSION_VALUE; a_operator: INTEGER): EPA_EXPRESSION_VALUE
			-- Evalute the result of comparing `a_value' with `Void', using `a_operator' as the equality test operator.
		require
			operator_valid: is_valid_void_check_operator (a_operator)
		local
			l_result: BOOLEAN
		do
			if attached {EPA_REFERENCE_VALUE} a_value then
				l_result := not is_void_check_equal (a_operator)
				create {EPA_BOOLEAN_VALUE} Result.make (l_result)
			elseif attached {EPA_VOID_VALUE} a_value then
				l_result := is_void_check_equal (a_operator)
				create {EPA_BOOLEAN_VALUE} Result.make (l_result)
			else
				create {EPA_NONSENSICAL_VALUE} Result
			end
		end

feature -- Status report

	is_valid_void_check_operator (a_operator: INTEGER): BOOLEAN
			-- Is `a_operator' a valid void-check operator?
		do
			Result := is_void_check_equal (a_operator) or else is_void_check_not_equal (a_operator)
		end

	is_void_check_equal (a_operator: INTEGER): BOOLEAN
			-- Is `a_operator' a void-check equal operator?
		do
			Result := a_operator = Operator_void_check_equal
		end

	is_void_check_not_equal (a_operator: INTEGER): BOOLEAN
			-- Is `a_operator' a void-check not-equal operator?
		do
			Result := a_operator = Operator_void_check_not_equal
		end

feature -- Output

	void_check_operator_text (a_operator: INTEGER): STRING
			-- Text of an operator.
		require
			operator_valid: is_valid_void_check_operator (a_operator)
		do
			inspect a_operator
			when Operator_void_check_equal then
				Result := "="
			when Operator_void_check_not_equal then
				Result := "/="
			else
				check False end
			end
		end

feature -- Constant

	Operator_void_check_equal: INTEGER = 201
	Operator_void_check_not_equal: INTEGER = 202

end
