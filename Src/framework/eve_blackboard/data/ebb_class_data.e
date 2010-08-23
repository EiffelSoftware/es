note
	description: "Blackboard data for a class."
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_CLASS_DATA

inherit

	EBB_CHILD_ELEMENT [EBB_CLUSTER_DATA, EBB_CLASS_DATA]
		redefine
			has_correctness_confidence,
			recalculate_correctness_confidence
		end

	EBB_PARENT_ELEMENT [EBB_CLASS_DATA, EBB_FEATURE_DATA]
		undefine
			set_stale,
			set_fresh
		redefine
			has_correctness_confidence,
			recalculate_correctness_confidence
		end

	EBB_CLASS_ASSOCIATION

	SHARED_WORKBENCH
		export {NONE} all end

	EBB_SHARED_ALL

create
	make

feature {NONE} -- Initialization

	make (a_class: attached like associated_class)
			-- Initialize empty verification state associated to `a_class'.
		do
			make_parent
			make_with_class (a_class)
			if a_class.is_compiled then
				create verification_state.make (a_class.compiled_class)
			end
			create verification_history.make
		ensure
			consistent: associated_class = a_class
			consistent: verification_state.class_id = class_id
		end

feature -- Access

	verification_state: attached EBB_CLASS_VERIFICATION_STATE
			-- Current verification state of this feature.

	verification_history: attached LINKED_LIST [EBB_CLASS_VERIFICATION_STATE]
			-- Past verification state of this feature.

	features: attached LIST [EBB_FEATURE_DATA]
			-- List of features of this class.
		do
			create {LINKED_LIST [EBB_FEATURE_DATA]} Result.make
			across features_written_in_class (compiled_class) as l_cursor loop
				Result.extend (blackboard.data.feature_data (l_cursor.item))
			end
		end

feature -- Status report

	has_correctness_confidence: BOOLEAN
			-- <Precursor>
		do
			Result := is_compiled and then Precursor
		end

feature -- Basic operations

	recalculate_correctness_confidence
			-- <Precursor>
		do
			Precursor {EBB_PARENT_ELEMENT}
			Precursor {EBB_CHILD_ELEMENT}
		end

end
