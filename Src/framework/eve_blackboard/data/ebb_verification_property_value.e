note
	description: "Summary description for {EBB_VERIFICATION_PROPERTY_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_VERIFICATION_PROPERTY_VALUE

create
	make

feature {NONE} -- Initialization

	make (a_property: attached like property)
			-- Initialize this value with `a_property'.
		do
			property := a_property
		ensure
			property_set: property = a_property
		end

feature -- Access

	property: attached EBB_VERIFICATION_PROPERTY
			-- Property associated with this value.

--feature -- Status report: Proofs

--	is_proven_to_hold: BOOLEAN
--			-- Is this condition proven to hold?

--	is_proven_to_fail: BOOLEAN
--			-- Is this condition proven to fail?

--	is_proof_failed: BOOLEAN
--			-- Did the proof of this condition fail?
--			-- e.g. because of a timeout of the prover

--	is_not_proven: BOOLEAN
--			-- Is this condition not proven?

--	is_update: BOOLEAN
--			-- Is this value an update compared to last result in history?

--feature -- Status setting

--	set_proven_to_hold
--				-- Set `is_proven_to_hold' to true.
--			do
--				set_all_to_false
--				is_proven_to_hold := True
--			ensure
--				is_proven_to_hold: is_proven_to_hold
--			end

--	set_proven_to_fail
--				-- Set `is_proven_to_fail' to true.
--			do
--				set_all_to_false
--				is_proven_to_fail := True
--			ensure
--				is_proven_to_fail: is_proven_to_fail
--			end

--	set_proof_failed
--			-- Set `is_proof_failed' to true.
--		do
--			set_all_to_false
--			is_proof_failed := True
--		ensure
--			is_proof_failed: is_proof_failed
--		end

--	set_not_proven
--			-- Set `is_not_proven' to true.
--		do
--			set_all_to_false
--			is_not_proven := True
--		ensure
--			is_not_proven: is_not_proven
--		end

--	set_update
--			-- Set `is_update' to true.
--		do
--			is_update := True
--		ensure
--			is_update: is_update
--		end

end
