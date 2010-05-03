note
	description: "Equality testers"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_SHARED_EQUALITY_TESTERS

feature -- Access

	ci_function_equality_tester: CI_FUNCTION_EQUALITY_TESTER
			-- Equality tester for {CI_FUNCTION}
		once
			create Result
		end

end
