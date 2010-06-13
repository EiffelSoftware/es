note
	description: "Equality tester {CI_QUANTIFIED_EXPRESSION_EQUALITY_TESTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_QUANTIFIED_EXPRESSION_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [CI_QUANTIFIED_EXPRESSION]
		redefine
			test
		end

	EPA_SHARED_EQUALITY_TESTERS

feature -- Status report

	test (v, u: CI_QUANTIFIED_EXPRESSION): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result :=
					u.is_for_all = v.is_for_all and then
					u.out ~ v.out
--					function_equality_tester.test (u.predicate, v.predicate)
			end
		end

end
