note
	description: "Interface for classes the make the result of an evaluation explicit."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXT_CHECKER

feature -- Access

	passed_check: BOOLEAN
			-- The evaluation of the last iteration by this checker.
		deferred
		end

end
