note
	description: "Summary description for {AFX_PREDICATE_EQUALITY_TESTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EQUATION_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [AFX_EQUATION]
		redefine
			test
		end

feature -- Status report

	test (v, u: AFX_EQUATION): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result :=
					expression_equality_tester.test (u.expression, v.expression) and then
					value_equality_tester.test (u.value, v.value)
			end
		end

feature{NONE} -- Implementation

	expression_equality_tester: AFX_EXPRESSION_EQUALITY_TESTER
			-- Equality tester for expressions
		once
			create Result
		end

	value_equality_tester: AFX_EXPRESSION_VALUE_EQUALITY_TESTER
			-- Equality tester for expression values
		once
			create Result
		end


end
