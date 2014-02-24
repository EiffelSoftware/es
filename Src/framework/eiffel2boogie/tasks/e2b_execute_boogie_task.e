note
	description: "Task to execute Boogie."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_EXECUTE_BOOGIE_TASK

inherit

	ROTA_TASK_I

	E2B_SHARED_CONTEXT

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
			if not is_started then
				start
				is_started := True
				verifier.verify_asynchronous
			end
			has_next_step := verifier.is_running

			if has_next_step then
				set_status ("Boogie running: " + peek_time.out)
			else
				set_status ("Boogie finished: " + get_time.out)
			end
		end

	cancel
			-- <Precursor>
		do
			verifier.cancel
			has_next_step := False
		end

feature {NONE} -- Implementation

	is_started: BOOLEAN
			-- Is verifier already started?

	verifier: attached E2B_VERIFIER
			-- Boogie verifier.

end
