note
	description: "Summary description for {AFX_PROGRAM_STATE_ASPECT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_PROGRAM_STATE_ASPECT

inherit

	AFX_PROGRAM_STATE_EXPRESSION

feature -- Basic operation

	evaluate (a_state: EPA_STATE)
			-- Evaluate current program state aspect regarding `a_state',
			--		and make the evaluation result available in `last_result'.
		require
			state_attached: a_state /= Void
		deferred
		end

feature -- Access

	last_value: EPA_EXPRESSION_VALUE
			-- Value of current program state aspect from last evaluation.

end
