note
	description: "Equality testers"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_SHARED_EQUALITY_TESTERS

feature -- Access

	ci_quantified_expression_equality_tester: CI_QUANTIFIED_EXPRESSION_EQUALITY_TESTER
			-- Equality tester for quantified expressions
		once
			create Result
		end

end
