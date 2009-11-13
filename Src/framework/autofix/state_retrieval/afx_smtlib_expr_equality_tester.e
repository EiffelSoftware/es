note
	description: "Summary description for {AFX_SMTLIB_EXPR_EQUALITY_TESTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SMTLIB_EXPR_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [AFX_SMTLIB_EXPR]
		redefine
			test
		end

feature -- Status report

	test (v, u: AFX_SMTLIB_EXPR): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
					-- Case sensitive comparison is used here,
					-- although insensitive comparion also suffice.
				Result := v.expression ~ u.expression
			end
		end

end
