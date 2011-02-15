note
	description: "Summary description for {AFX_PROGRAM_STATE_SUSPICIOUSNESS_VALUE_CALCULATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_PROGRAM_STATE_SUSPICIOUSNESS_VALUE_CALCULATOR

feature -- Access

	last_suspiciousness_value: REAL
			-- Suspiciousness value from last computation.

feature -- Basic operation

	calculate_suspiciousness_value
			-- Calculate suspiciousness value and make the result available in `last_suspiciousness_value'.
		deferred
		end

end
