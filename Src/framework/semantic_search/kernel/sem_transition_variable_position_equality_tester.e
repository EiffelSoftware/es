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
				Result :=
					v.position = u.position and then
					v.is_argument = u.is_argument and then
					v.is_target = u.is_target and then
					v.is_operand = u.is_operand and then
					v.is_interface = u.is_interface
			end
		end

end
