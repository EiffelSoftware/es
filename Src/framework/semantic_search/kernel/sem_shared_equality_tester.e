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


end
