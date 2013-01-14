note
	description: "Summary description for {AFX_SHARED_BEHAVIOR_CONSTRUCTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_BEHAVIOR_CONSTRUCTOR

inherit
    AFX_SHARED_SESSION

create
    default_create

feature -- Query

	state_transitions_from_model (a_objects: DS_HASH_TABLE [EPA_STATE, STRING_8];
					a_dest_objects: DS_HASH_TABLE [EPA_STATE, STRING_8];
					a_context_class: CLASS_C;
					a_class_set: detachable DS_HASH_SET [CLASS_C];
					a_is_forward: BOOLEAN): DS_ARRAYED_LIST [AFX_STATE_TRANSITION_FIX]
			-- Query the call sequences transit `a_objects' to `a_dest_objects'.
		local
		    l_transitor: AFX_STATE_TRANSITOR
		do
			if True then
				create l_transitor.make (create {DIRECTORY}.make_with_path (config.model_directory))
				l_transitor.construct_behavior (a_dest_objects)
				Result := l_transitor.call_sequences
			end
		end


feature -- Access


feature{NONE} -- Operation

end
