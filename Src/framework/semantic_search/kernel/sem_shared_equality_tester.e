note
	description: "Shared equality testers"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_SHARED_EQUALITY_TESTER

feature -- Access

	term_query_equality_tester: SEM_TERM_QUERY_EQUALITY_TESTER
			-- Equality tester for {TERM_QUERY} objects
		once
			create Result
		end

end
