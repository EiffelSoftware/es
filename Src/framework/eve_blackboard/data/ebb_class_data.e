note
	description: "Summary description for {EBB_CLASS_DATA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_CLASS_DATA

inherit

	EBB_CLASS_ASSOCIATION

	SHARED_WORKBENCH
		export {NONE} all end

	EBB_SHARED_ALL

create
	make

feature {NONE} -- Initialization

	make (a_class: attached CLASS_C)
			-- Initialize empty verification state associated to `a_class'.
		do
			make_with_class (a_class)
			create verification_state.make (a_class)
			create verification_history.make
		ensure
			consistent: class_id = a_class.class_id
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
			across features_written_in_class (associated_class) as l_cursor loop
				Result.extend (blackboard.data.feature_data (l_cursor.item))
			end
		end

end
