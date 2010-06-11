note
	description: "Equality test for {CI_SINGLE_ARG_FUNCTION_SIGNATURE}"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_SINGLE_ARG_FUNCTION_SIGNATURE_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [CI_SINGLE_ARG_FUNCTION_SIGNATURE]
		redefine
			test
		end

	EPA_SHARED_EQUALITY_TESTERS

feature -- Status report

	test (v, u: CI_SINGLE_ARG_FUNCTION_SIGNATURE): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result :=
					v.argument_type.same_type (u.argument_type) and then
					v.result_type.same_type (u.result_type) and then
					v.argument_type.is_equivalent (u.argument_type) and then
					v.result_type.is_equivalent (v.result_type)
			end
		end

end
