indexing
	description:
		"[
			Event for a successful proof.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EVENT_LIST_PROOF_SUCCESSFUL_ITEM

inherit

	EVENT_LIST_PROOF_ITEM_I

create
	make

feature {NONE} -- Initialization

	make (a_class: CLASS_C; a_feature: FEATURE_I)
			-- Initialize event item.
		require
			a_class_not_void: a_class /= Void
			a_feature_not_void: a_feature /= Void
		do
			initialize (a_class, a_feature)
			data := Void
			description := "Successful"
		ensure
			context_class_set: context_class = a_class
			context_feature_set: context_feature = a_feature
		end

feature -- Access

	data: ANY
			-- <Precursor>

	description: STRING_32
			-- <Precursor>

end
