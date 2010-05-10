note
	description: "Equality tester for {CI_FUNCTION}"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_FUNCTION_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [EPA_FUNCTION]
		redefine
			test
		end

feature -- Status report

	test (v, u: EPA_FUNCTION): BOOLEAN
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
				Result := v.body ~ u.body
			end
		end

end
