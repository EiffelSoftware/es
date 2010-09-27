note
	description: "Equality tester for {SEM_EQUATION}"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_EQUATION_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [SEM_EQUATION]
		redefine
			test
		end

feature -- Status report

	test (v, u: SEM_EQUATION): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result :=
					v.is_precondition = u.is_precondition and then
					v.is_human_written = v.is_human_written and then
					equation_equality_tester.test (v.equation, u.equation)
			end
		end

feature{NONE} -- Implementation

	equation_equality_tester: EPA_EQUATION_EQUALITY_TESTER
			-- Equality tester for {EPA_EQUATION}
		once
			create Result
		end

end
