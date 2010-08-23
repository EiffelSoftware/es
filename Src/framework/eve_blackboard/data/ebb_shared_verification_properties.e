note
	description: "Access to shared verification properties."
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_SHARED_VERIFICATION_PROPERTIES

feature {NONE} -- Access

	postcondition_satisfied: EBB_VERIFICATION_PROPERTY
			-- Property denoting that postcondition is satisfied.
		once
			create Result.make ("Postcondition satisfied")
		end

	class_invariant_satisfied: EBB_VERIFICATION_PROPERTY
			-- Property denoting that class invariant is satisfied.
		once
			create Result.make ("Class invariant satisfied")
		end

	frame_condition_satisfied: EBB_VERIFICATION_PROPERTY
			-- Property denoting that frame condition is satisfied.
		once
			create Result.make ("Frame condition satisfied")
		end

	preconditions_of_calls_satisfied: EBB_VERIFICATION_PROPERTY
			-- Property denoting that preconditions of feature calls are satisfied.
		once
			create Result.make ("Preconditions of calls satisfied")
		end

	checks_satisfied: EBB_VERIFICATION_PROPERTY
			-- Property denoting that check instructions are satisfied.
		once
			create Result.make ("Check instructions satisfied")
		end

end
