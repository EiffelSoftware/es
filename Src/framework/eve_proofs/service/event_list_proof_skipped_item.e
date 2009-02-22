indexing
	description:
		"[
			Event for a skipped proof
		]"
	date: "$Date$"
	revision: "$Revision$"

class EVENT_LIST_PROOF_SKIPPED_ITEM

inherit

	EVENT_LIST_PROOF_ITEM_I
		rename
			data as reason
		end

create
	make

feature {NONE} -- Initialization

	make (a_class: CLASS_C; a_feature: FEATURE_I; a_reason: STRING)
			-- Initialize event item.
		require
			a_class_not_void: a_class /= Void
			a_reason_not_void: a_reason /= Void
		do
			initialize (a_class, a_feature)
			reason := a_reason
			description := "Skipped: " + a_reason
		ensure
			context_class_set: context_class = a_class
			context_feature_set: context_feature = a_feature
			reason_set: reason = a_reason
		end

feature -- Access

	reason: STRING
			-- <Precursor>

	description: STRING_32
			-- <Precursor>

end
