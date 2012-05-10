note
	description: "Summary description for {E2B_MERGE_RESULTS_TASK}."
	author: ""
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
		do
			if
				attached primary_verifier.last_result and then
				attached secondary_verifier.last_result
			then
				across secondary_verifier.last_result.verified_procedures as j loop
					primary_verifier.last_result.verified_procedures.extend (j.item)
					from
						primary_verifier.last_result.verification_errors.start
					until
						primary_verifier.last_result.verification_errors.after
					loop
						if primary_verifier.last_result.verification_errors.item.eiffel_feature.body_index = j.item.eiffel_feature.body_index then
							primary_verifier.last_result.verification_errors.remove
						else
							primary_verifier.last_result.verification_errors.forth
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
