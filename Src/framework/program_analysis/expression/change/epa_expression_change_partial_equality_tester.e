note
	description: "Partial equality tester for {EPA_EXPRESSION_CHANGE}"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXPRESSION_CHANGE_PARTIAL_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [EPA_EXPRESSION_CHANGE]
		redefine
			test
		end

feature -- Status report

	test (v, u: EPA_EXPRESSION_CHANGE): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result :=
					v.is_relative = u.is_relative and then
					expression_equality_tester.test (v.expression, u.expression)
			end
		end

feature{NONE} -- Implementation

	expression_equality_tester: EPA_EXPRESSION_EQUALITY_TESTER
			-- Equality tester for expressions
		once
			create Result
		end

end
