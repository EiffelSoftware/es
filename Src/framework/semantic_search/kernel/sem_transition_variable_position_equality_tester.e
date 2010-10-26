note
	description: "Equality tester for {SEM_TRANSITION_VARIABLE_POSITION}"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_TRANSITION_VARIABLE_POSITION_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [SEM_TRANSITION_VARIABLE_POSITION]
		redefine
			test
		end

	IR_SHARED_EQUALITY_TESTERS

feature -- Status report

	test (v, u: SEM_TRANSITION_VARIABLE_POSITION): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result := v.position = u.position
			end
		end

end
