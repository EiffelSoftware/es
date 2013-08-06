note
	description: "TODO"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_POSTCONDITION_MUTATION_TASK

inherit

	ROTA_TASK_I

	E2B_SHARED_CONTEXT

create
	make

feature {NONE} -- Initialization

	make (a_boogie_universe: IV_UNIVERSE; a_verifier: E2B_VERIFIER)
			-- Initialize task.
		do
			has_next_step := True
			boogie_universe := a_boogie_universe
			verifier := a_verifier
		end

feature -- Access

	boogie_universe: IV_UNIVERSE
			-- Boogie universe to operate on.

	verifier: E2B_VERIFIER
			-- Verifier used for verification.

feature -- Status report

	has_next_step: BOOLEAN
			-- <Precursor>

	is_interface_usable: BOOLEAN = True
			-- <Precursor>

feature {ROTA_S, ROTA_TASK_I} -- Basic operations

	step
			-- <Precursor>
		local
			processor: E2B_POSTCONDITION_MUTATION_VISITOR
		do
			create processor.make (boogie_universe, verifier)
			boogie_universe.process (processor)
			has_next_step := False
		end

	cancel
			-- <Precursor>
		do
			has_next_step := False
		end

end
