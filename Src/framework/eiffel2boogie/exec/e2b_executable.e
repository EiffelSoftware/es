note
	description: "Interface for a platform-dependent implementation to run Boogie."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	E2B_EXECUTABLE

feature -- Access

	input: attached E2B_INPUT
			-- Input for Boogie.

	last_output: attached STRING
			-- Output of last run of Boogie.

feature -- Element change

	set_input (a_input: attached E2B_INPUT)
			-- Set `input' to `a_input'.
		do
			input := a_input
		ensure
			input_set: input = a_input
		end

feature -- Basic operations

	run
			-- Run Boogie on `input'.
		deferred
		end

end
