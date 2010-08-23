note
	description: "Summary description for {EBB_CLASS_VERIFICATION_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_CLASS_VERIFICATION_STATE

inherit

	EBB_CLASS_ASSOCIATION

	SHARED_WORKBENCH
		export {NONE} all end

	EBB_SHARED_BLACKBOARD
		export {NONE} all end

	EBB_SHARED_HELPER
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make (a_class: CLASS_C)
			-- Initialize empty verification state associated to `a_class'.
		do
			make_with_class (a_class.original_class)
		end

feature -- Access

	time: DATE_TIME
			-- Time when this verification state was last updated.

	correctness_confidence: REAL
			-- Confidence value for correctness.
			-- A value of 0.0 means no confidence of corretness and
			-- a value of 1.0 means full confidence of corretness.

feature -- Status report

	is_proven: BOOLEAN
			-- Have all features of this class been proven?

	is_tested: BOOLEAN
			-- Have all feature of this class been tested?

feature -- Implementation

	calculate_confidence
			-- Calculate correctness confidence based on confidence of individual features.
		local
			l_feature_list: LIST [FEATURE_I]
			l_feature_data: EBB_FEATURE_DATA
			l_accumulator: REAL
			l_count: INTEGER
		do
			across features_written_in_class (system.class_of_id (class_id)) as l_cursor loop
				l_feature_data := blackboard.data.feature_data (l_cursor.item)
				l_accumulator := l_accumulator + l_feature_data.verification_state.correctness_confidence
				l_count := l_count + 1
			end
			if l_count = 0 then
				correctness_confidence := 1
			else
				correctness_confidence := (l_accumulator / l_count) * (l_accumulator / l_count)
			end
		end

end
