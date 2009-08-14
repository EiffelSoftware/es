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
			data as error_list
		end

create
	make

feature {NONE} -- Initialization

	make (a_class: CLASS_C; a_feature: FEATURE_I; a_error_list: LIST [EP_ERROR])
			-- <Precursor>
		require
			a_class_not_void: a_class /= Void
			a_feature_not_void: a_feature /= Void
			a_error_list_not_void: a_error_list /= Void
			a_error_list_not_empty: not a_error_list.is_empty
		do
			initialize (a_class, a_feature)
			error_list := a_error_list
			description := a_error_list.first.description
		ensure
			context_class_set: context_class = a_class
			context_feature_set: context_feature = a_feature
			error_set: error_list = a_error_list
		end

feature -- Access

	error_list: LIST [EP_ERROR]
			-- <Precursor>

	description: STRING_32
			-- <Precursor>

end
