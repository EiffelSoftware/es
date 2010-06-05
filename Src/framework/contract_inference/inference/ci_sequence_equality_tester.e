note
	description: "Equality tester for {CI_SEQUENCE_EQUALITY_TESTER}"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_SEQUENCE_EQUALITY_TESTER [G]

inherit
	KL_EQUALITY_TESTER [CI_SEQUENCE [G]]
		redefine
			test
		end

	EPA_SHARED_EQUALITY_TESTERS

feature -- Status report

	test (v, u: CI_SEQUENCE [G]): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result :=
					v.target_variable_name ~ u.target_variable_name and then
					v.function_name ~ u.function_name and then
					v.is_pre_state = u.is_pre_state and then
					v.content |=| u.content
			end
		end

end
