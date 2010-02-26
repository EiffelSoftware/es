note
	description: "Summary description for {EPA_SHARED_EQUALITY_TESTERS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_SHARED_EQUALITY_TESTERS

feature -- Equality tester

	equation_equality_tester: EPA_EQUATION_EQUALITY_TESTER
			-- Equality tester for equations
		once
			create Result
		end

	expression_equality_tester: EPA_EXPRESSION_EQUALITY_TESTER
			-- Equality tester for expressions
		once
			create Result
		end

end
