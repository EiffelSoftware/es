note
	description: "Equality tester for {CI_INTEGER_QUERY}"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_INTEGER_QUERY_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [CI_INTEGER_QUERY]
		redefine
			test
		end

feature -- Status report

	test (v, u: CI_INTEGER_QUERY): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result :=
					(v.target_operand_index = u.target_operand_index) and then
					(v.feature_name ~ u.feature_name)
			end
		end

end
