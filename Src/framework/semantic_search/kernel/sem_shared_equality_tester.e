note
	description: "Shared equality testers"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_SHARED_EQUALITY_TESTER

inherit
	IR_SHARED_EQUALITY_TESTERS

feature -- Access

	sem_equation_equality_tester: SEM_EQUATION_EQUALITY_TESTER
			-- Equality tester for {SEM_EQUATION} objects
		once
			create Result
		end

	sem_matching_criterion_equality_tester: SEM_MATCHING_CRITERION_EQUALITY_TESTER
			-- Equality tester for {SEM_MATCHING_CRITERION_EQUALITY_TESTER} objects
		once
			create Result
		end

end
