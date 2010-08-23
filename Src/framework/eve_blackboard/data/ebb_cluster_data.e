note
	description: "Blackboard data for a cluster."
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_CLUSTER_DATA

inherit

	EBB_CHILD_ELEMENT [EBB_SYSTEM_DATA, EBB_CLUSTER_DATA]
		redefine
			recalculate_correctness_confidence
		end

	EBB_PARENT_ELEMENT [EBB_CLUSTER_DATA, EBB_CLASS_DATA]
		undefine
			set_stale,
			set_fresh
		redefine
			recalculate_correctness_confidence
		end

feature -- Access

feature -- Basic operations


	recalculate_correctness_confidence
			-- <Precursor>
		do
			Precursor {EBB_PARENT_ELEMENT}
			Precursor {EBB_CHILD_ELEMENT}
		end


end
