note
	description: "Task to merge results from two-step verification."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_MERGE_RESULTS_TASK

inherit

	ROTA_TASK_I

create
	make

feature {NONE} -- Initialization

	make (a_primary_verifier, a_secondary_verifier: attached like primary_verifier)
			-- Initialize task.
		do
			primary_verifier := a_primary_verifier
			secondary_verifier := a_secondary_verifier
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
			l_new_success: BOOLEAN
			l_primary_result: E2B_PROCEDURE_RESULT
		do
			if
				attached primary_verifier.last_result and then
				attached secondary_verifier.last_result
			then
				across secondary_verifier.last_result.procedure_results as l_second_results loop
					if attached {E2B_SUCCESSFUL_VERIFICATION} l_second_results.item as l_second_success then
						from
							l_new_success := True
							primary_verifier.last_result.procedure_results.start
						until
							primary_verifier.last_result.procedure_results.after or not l_new_success
						loop
							l_primary_result := primary_verifier.last_result.procedure_results.item
							if
								l_primary_result.eiffel_class.class_id = l_second_success.eiffel_class.class_id and then
								l_primary_result.eiffel_feature.body_index = l_second_success.eiffel_feature.body_index
							then
								if attached {E2B_SUCCESSFUL_VERIFICATION} l_primary_result then
									l_new_success := False
								elseif attached {E2B_FAILED_VERIFICATION} l_primary_result as l_primary_failed then
									across l_primary_failed.errors as l_errors loop
										l_second_success.add_original_error (l_errors.item)
										if attached {E2B_PRECONDITION_VIOLATION} l_errors.item then
											l_second_success.set_suggestion ("You might need to weaken the precondition.")
										end
									end
									primary_verifier.last_result.procedure_results.remove
								else
									check False end
								end
							else
								primary_verifier.last_result.procedure_results.forth
							end
						end
						if l_new_success then
							primary_verifier.last_result.procedure_results.extend (l_second_success)
						end
					end
				end
			end
			has_next_step := False
		end

	cancel
			-- <Precursor>
		do
			has_next_step := False
		end

feature {NONE} -- Implementation

	primary_verifier: attached E2B_VERIFIER
			-- Boogie verifier.

	secondary_verifier: attached E2B_VERIFIER
			-- Boogie verifier.

end
