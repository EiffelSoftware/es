note
	description: "Summary description for {EBB_FEATURE_VERIFICATION_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_FEATURE_VERIFICATION_STATE

inherit

	EBB_FEATURE_ASSOCIATION
		redefine
			out
		end

	SHARED_WORKBENCH
		export
			{NONE} all
		undefine
			out
		end

create
	make

feature {NONE} -- Initialization

	make (a_feature: FEATURE_I)
			-- Initialize empty verification state associated to `a_feature'.
		do
			make_with_feature (a_feature)

			if a_feature.is_attribute then
				correctness_confidence := -1.0
			end

		ensure
			consistent: system.class_of_id (class_id).feature_of_feature_id (feature_id).rout_id_set ~ a_feature.rout_id_set
		end

feature -- Access

	time: DATE_TIME
			-- Time when this verification state was last updated.

	correctness_confidence: REAL
			-- Confidence value for correctness.
			-- A value of 0.0 means no confidence of corretness and
			-- a value of 1.0 means full confidence of corretness.

feature -- Status report

	has_loops: BOOLEAN
			-- Does this feature has loops?

feature -- Proof data

	is_postcondition_proven: EBB_PROOF_RESULT
			-- Is postcondition proven to be satisfied?

	is_class_invariant_proven: EBB_PROOF_RESULT
			-- Is class invariant proven to hold at end of feature?

	is_frame_condition_proven: EBB_PROOF_RESULT
			-- Is frame condition proven to be satisfied?

	is_loop_invariant_proven: EBB_PROOF_RESULT
			-- Is loop invariant proven?

	is_loop_variant_proven: EBB_PROOF_RESULT
			-- Is loop variant proven?

	proof_time: REAL
			-- Time in seconds used to prove feature.

feature -- Test data

	is_tested: BOOLEAN
			-- Is this feature tested?
		do
			Result := is_automatically_tested or is_manually_tested
		end

	is_automatically_tested: BOOLEAN
			-- Is this feature tested using automatic testing?

	automatic_testing_time: REAL
			-- Time in seconds used to automatically test feature.

	is_manually_tested: BOOLEAN
			-- Is this feature tested using manual test cases?

feature -- Basic operations

	update_with_new_result (a_result: EBB_FEATURE_VERIFICATION_RESULT)
			-- Merge with data from `a_other'.
		do
			-- TODO: merge data
			if a_result.is_postcondition_proven.is_update then
				is_postcondition_proven := a_result.is_postcondition_proven
			end
			if a_result.is_class_invariant_proven.is_update then
				is_class_invariant_proven := a_result.is_class_invariant_proven
			end

			calculate_correctness_confidence
		end

feature -- Output

	out: STRING
			-- <Precursor>
		do
			create Result.make_empty
			--Result.append ("Verification state of " + qualified_feature_name + "%N")
			Result.append ("is_postcondition_proven: " + is_postcondition_proven.out + "%N")
			Result.append ("is_class_invariant_proven: " + is_class_invariant_proven.out + "%N")
			Result.append ("is_frame_condition_proven: " + is_frame_condition_proven.out + "%N")
			Result.append ("is_loop_invariant_proven: " + is_loop_invariant_proven.out + "%N")
			Result.append ("is_loop_variant_proven: " + is_loop_variant_proven.out + "%N")
		end

feature {NONE} -- Implementation

	calculate_correctness_confidence
			-- Calculate correctness confidence value from verification state.
		do
			correctness_confidence := 0
			if is_postcondition_proven.is_proven_to_hold then
				correctness_confidence := correctness_confidence + 1
			end
			if is_class_invariant_proven.is_proven_to_hold then
				correctness_confidence := correctness_confidence + 1
			end
--			if is_frame_condition_proven.is_proven_to_hold then
--				correctness_confidence := correctness_confidence + 1
--			end
--			if is_loop_invariant_proven.is_proven_to_hold then
--				correctness_confidence := correctness_confidence + 1
--			end
--			if is_loop_variant_proven.is_proven_to_hold then
--				correctness_confidence := correctness_confidence + 1
--			end

--			correctness_confidence := correctness_confidence / 5
			correctness_confidence := correctness_confidence / 2
		end

invariant
--	confidence_in_interval: 0.0 <= correctness_confidence and correctness_confidence <= 1.0

end
