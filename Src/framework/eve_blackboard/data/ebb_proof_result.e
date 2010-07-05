note
	description: "Result of a proof."
	date: "$Date$"
	revision: "$Revision$"

expanded class
	EBB_PROOF_RESULT

inherit

	ANY
		redefine
			default_create,
			out
		end

	DEBUG_OUTPUT
		undefine
			default_create,
			out
		end

create
	default_create,
	set_proven_to_hold,
	set_proven_to_fail,
	set_proof_failed,
	set_not_proven

feature {NONE} -- Initialization

	default_create
			-- Initialize proof result as `is_not_proven'.
		do
			set_not_proven
		ensure then
			is_not_proven: is_not_proven
		end

feature -- Status report

	is_proven_to_hold: BOOLEAN
			-- Is this condition proven to hold?

	is_proven_to_fail: BOOLEAN
			-- Is this condition proven to fail?

	is_proof_failed: BOOLEAN
			-- Did the proof of this condition fail?
			-- e.g. because of a timeout of the prover

	is_not_proven: BOOLEAN
			-- Is this condition not proven?

	is_update: BOOLEAN
			-- Is this value an update compared to last result in history?

feature -- Status setting

	set_proven_to_hold
				-- Set `is_proven_to_hold' to true.
			do
				set_all_to_false
				is_proven_to_hold := True
			ensure
				is_proven_to_hold: is_proven_to_hold
			end

	set_proven_to_fail
				-- Set `is_proven_to_fail' to true.
			do
				set_all_to_false
				is_proven_to_fail := True
			ensure
				is_proven_to_fail: is_proven_to_fail
			end

	set_proof_failed
			-- Set `is_proof_failed' to true.
		do
			set_all_to_false
			is_proof_failed := True
		ensure
			is_proof_failed: is_proof_failed
		end

	set_not_proven
			-- Set `is_not_proven' to true.
		do
			set_all_to_false
			is_not_proven := True
		ensure
			is_not_proven: is_not_proven
		end

	set_update
			-- Set `is_update' to true.
		do
			is_update := True
		ensure
			is_update: is_update
		end

	merge (a_other: EBB_PROOF_RESULT)
			-- Merge with `a_other'.
			-- This copies the values of `a_other' if `a_other.is_update' is true.
		do
			if a_other.is_update then
				is_proven_to_hold := a_other.is_proven_to_hold
				is_proven_to_fail := a_other.is_proven_to_fail
				is_proof_failed := a_other.is_proof_failed
				is_not_proven := a_other.is_not_proven
				is_update := a_other.is_update
			end
		end

feature -- Output

	out: STRING
			-- <Precursor>
		do
			if is_proven_to_hold then
				Result := "Proven to hold"
			elseif is_proven_to_fail then
				Result := "Proven to fail"
			elseif is_proof_failed then
				Result := "Proof failed"
			elseif is_not_proven then
				Result := "Not proven"
			else
				check False end
			end
			if is_update then
				Result.append (" (updated)")
			end
		end

	debug_output: STRING
			-- <Precursor>
		do
			Result := out
		end

feature {NONE} -- Implementation

	set_all_to_false
			-- Set all properties to False.
		do
			is_proven_to_hold := False
			is_proven_to_fail := False
			is_proof_failed := False
			is_not_proven := False
		ensure
			effect: not is_proven_to_hold and not is_proven_to_fail and not is_proof_failed and not is_not_proven
		end

invariant
	one_state_is_true: is_proven_to_hold or is_proven_to_fail or is_proof_failed or is_not_proven
	only_one_state_is_true1: is_proven_to_hold implies not is_proven_to_fail and not is_proof_failed and not is_not_proven
	only_one_state_is_true2: is_proven_to_fail implies not is_proven_to_hold and not is_proof_failed and not is_not_proven
	only_one_state_is_true3: is_proof_failed implies not is_proven_to_hold and not is_proven_to_fail and not is_not_proven
	only_one_state_is_true4: is_not_proven implies not is_proven_to_hold and not is_proven_to_fail and not is_proof_failed

end
