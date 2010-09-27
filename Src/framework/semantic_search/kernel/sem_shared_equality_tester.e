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

	document_field_equality_tester: SEM_DOCUMENT_FIELD_EQUALITY_TESTER
			-- Equality tester for {SEM_DOCUMENT_FIELD} objects
		once
			create Result
		end

	sem_equation_equality_tester: SEM_EQUATION_EQUALITY_TESTER
			-- Equality tester for {SEM_EQUATION} objects
		once
			create Result
		end


end
