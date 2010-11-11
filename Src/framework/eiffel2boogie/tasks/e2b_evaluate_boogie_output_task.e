note
	description: "Task to evaluate Boogie output."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_EVALUATE_BOOGIE_OUTPUT_TASK

inherit

	ROTA_TASK_I

create
	make

feature {NONE} -- Initialization

	make (a_verifier: attached like verifier)
			-- Initialize task.
		do
			verifier := a_verifier
			has_next_step := True
		end

feature -- Status report

	has_next_step: BOOLEAN
			-- <Precursor>

	is_interface_usable: BOOLEAN = True
			-- <Precursor>

feature {ROTA_S, ROTA_TASK_I} -- Basic operations

	step
			-- <Precursor>
		do
			if attached verifier.last_output then
				verifier.parse_verification_output
			end
			has_next_step := False
		end

	cancel
			-- <Precursor>
		do
			has_next_step := False
		end

feature {NONE} -- Implementation

	verifier: attached E2B_VERIFIER
			-- Boogie verifier.

end
