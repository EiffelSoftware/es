indexing
	description:
		"[
			Event for a failed proof.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EVENT_LIST_PROOF_FAILED_ITEM

inherit

	EVENT_LIST_PROOF_ITEM_I
		rename
			data as error
		end

create
	make

feature {NONE} -- Initialization

	make (a_class: CLASS_C; a_feature: FEATURE_I; a_error: EP_ERROR)
			-- Initialize item.
		require
			a_class_not_void: a_class /= Void
			a_feature_not_void: a_feature /= Void
			a_error_not_void: a_error /= Void
		do
			initialize (a_class, a_feature)
			error := a_error
			description := a_error.description
		ensure
			context_class_set: context_class = a_class
			context_feature_set: context_feature = a_feature
			error_set: error = a_error
		end

feature -- Access

	error: EP_ERROR
			-- <Precursor>

	description: STRING_32
			-- <Precursor>

end
