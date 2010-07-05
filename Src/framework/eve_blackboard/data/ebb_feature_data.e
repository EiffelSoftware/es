note
	description: "Summary description for {EBB_FEATURE_DATA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_FEATURE_DATA

inherit

	EBB_FEATURE_ASSOCIATION

	SHARED_WORKBENCH
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make (a_feature: attached FEATURE_I)
			-- Initialize empty feature data associated to `a_feature'.
		do
			make_with_feature (a_feature)
			create verification_state.make (a_feature)
			create verification_history.make
		ensure
			consistent: system.class_of_id (class_id) = a_feature.written_class
			consistent2: associated_feature.rout_id_set ~ a_feature.rout_id_set
		end

feature -- Access

	verification_state: attached EBB_FEATURE_VERIFICATION_STATE
			-- Current verification state of this feature.

	verification_history: attached LINKED_LIST [attached EBB_FEATURE_VERIFICATION_STATE]
			-- Past verification state of this feature.

feature -- Basic operations

	update_with_new_result (a_result: attached EBB_FEATURE_VERIFICATION_RESULT)
			-- Update `verification_state' with `a_result'.
		do
			verification_history.extend (verification_state)
			verification_state := verification_state.twin
			verification_state.update_with_new_result (a_result)
		end

end
