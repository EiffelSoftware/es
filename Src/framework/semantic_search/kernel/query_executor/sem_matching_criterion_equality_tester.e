note
	description: "Equality tester for {SEM_MATCHING_CRITERION}"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_MATCHING_CRITERION_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [SEM_MATCHING_CRITERION]
		redefine
			test
		end

	IR_SHARED_EQUALITY_TESTERS

feature -- Status report

	test (v, u: SEM_MATCHING_CRITERION): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result :=
					v.criterion ~ u.criterion and then
					v.variables ~ u.variables and then
					ir_value_equality_tester.test (v.value, u.value)
			end
		end

end
