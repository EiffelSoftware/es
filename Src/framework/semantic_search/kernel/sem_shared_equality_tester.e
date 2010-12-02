note
	description: "Shared equality testers"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_SHARED_EQUALITY_TESTER

inherit
	IR_SHARED_EQUALITY_TESTERS

	KL_SHARED_STRING_EQUALITY_TESTER

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

	sem_transition_variable_position_equality_tester: SEM_TRANSITION_VARIABLE_POSITION_EQUALITY_TESTER
			-- Equality tester for {SEM_TRANSITION_VARIABLE_POSITION} objects
		once
			create Result
		end

	sql_type_equality_tester: SQL_TYPE_EQUALITY_TESTER
			-- Equality tester for {SQL_TYPE}
		once
			create Result
		end

	semq_term_equality_tester: SEMQ_TERM_EQUALITY_TESTER
			-- Equality tester for {SEMQ_TERM}
		once
			create Result
		end

	sem_variable_with_uuid_equality_tester: SEM_VARIABLE_WITH_UUID_EQUALITY_TESTER
			-- Equality test for {SEM_VARIABLE_WITH_UUUID}
		once
			create Result
		end

end
