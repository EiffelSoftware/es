note
	description: "Summary description for {AFX_EXPRESSION_VALUE_EQUALITY_TESTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXPRESSION_VALUE_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [EPA_EXPRESSION_VALUE]
		redefine
			test
		end

feature -- Status report

	test (v, u: EPA_EXPRESSION_VALUE): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result := v ~ u
			end
		end

end
