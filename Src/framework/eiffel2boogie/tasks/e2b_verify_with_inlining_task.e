note
	description: "Summary description for {E2B_VERIFY_WITH_INLINING_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_VERIFY_WITH_INLINING_TASK

inherit

	ROTA_TASK_I

create
	make

feature {NONE} -- Initialization

	make (a_verifier: attached like verifier; a_tasks: like remaining_tasks)
			-- Initialize task.
		do
			verifier := a_verifier
			remaining_tasks := a_tasks
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
		local
			l_translator_input: E2B_TRANSLATOR_INPUT
			l_boogie_universe: IV_UNIVERSE
			l_context: E2B_SHARED_CONTEXT
		do
			if
				attached verifier.last_result and then
				verifier.last_result.has_verification_errors
			then
					-- Verify again with inlining
				create l_translator_input.make
				create l_context
				l_context.options.routines_to_inline.wipe_out
				across verifier.last_result.verification_errors as i loop
					l_translator_input.add_feature (i.item.eiffel_feature)
					l_context.options.routines_to_inline.extend (i.item.eiffel_feature.body_index)
				end

				create l_boogie_universe.make
				create inlining_verifier.make
				remaining_tasks.start
				remaining_tasks.forth
				remaining_tasks.put_left (create {E2B_TRANSLATE_CHUNK_TASK}.make (l_translator_input, l_boogie_universe))
				remaining_tasks.put_left (create {E2B_GENERATE_BOOGIE_TASK}.make (l_boogie_universe, inlining_verifier))
				remaining_tasks.put_left (create {E2B_EXECUTE_BOOGIE_TASK}.make (inlining_verifier))
				remaining_tasks.put_left (create {E2B_EVALUATE_BOOGIE_OUTPUT_TASK}.make (inlining_verifier))
				remaining_tasks.put_left (create {E2B_MERGE_RESULTS_TASK}.make (verifier, inlining_verifier))
			end
			has_next_step := False
		end

	cancel
			-- <Precursor>
		do
			has_next_step := False
		end

feature {NONE} -- Implementation

	remaining_tasks: attached LINKED_LIST [ROTA_TASK_I]
			-- List of remaining tasks.

	verifier: attached E2B_VERIFIER
			-- Boogie verifier.

	inlining_verifier: detachable E2B_VERIFIER
			-- Boogie verifier.

end
