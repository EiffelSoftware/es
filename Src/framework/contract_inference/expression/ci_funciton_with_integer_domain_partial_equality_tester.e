note
	description: "[
		Equality tester for {CI_FUNCTION_WITH_INTEGER_DOMAIN}
		Note: This is not a strict equality tester, it only 
		checks the target variable name and function name.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_FUNCITON_WITH_INTEGER_DOMAIN_PARTIAL_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [CI_FUNCTION_WITH_INTEGER_DOMAIN]
		redefine
			test
		end

	EPA_SHARED_EQUALITY_TESTERS

feature -- Status report

	test (v, u: CI_FUNCTION_WITH_INTEGER_DOMAIN): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result :=
					v.target_operand_index ~ u.target_operand_index and then
					v.function_name ~ u.function_name

			end
		end

end
