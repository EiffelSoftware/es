note
	description: "Equality tester for {CI_TEST_CASE_TRANSITION_INFO}"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_TEST_CASE_TRANSITION_INFO_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [CI_TEST_CASE_TRANSITION_INFO]
		redefine
			test
		end

	EPA_SHARED_EQUALITY_TESTERS

feature -- Status report

	test (v, u: CI_TEST_CASE_TRANSITION_INFO): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result :=
					v.signature ~ u.signature
			end
		end

end
