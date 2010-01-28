note
	description: "Summary description for {AFX_SHARED_BEHAVIOR_CONSTRUCTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_BEHAVIOR_CONSTRUCTOR

inherit
    AFX_SHARED_STATE_TRANSITION_MODEL

create
    default_create

feature -- Query

	state_transitions_from_model (a_objects: DS_HASH_TABLE [AFX_STATE, STRING_8];
					a_dest_objects: DS_HASH_TABLE [AFX_STATE, STRING_8];
					a_context_class: CLASS_C;
					a_class_set: detachable DS_HASH_SET [CLASS_C];
					a_criteria: detachable AFX_BEHAVIOR_FEATURE_SELECTOR_I;
					a_is_forward: BOOLEAN): DS_ARRAYED_LIST [AFX_STATE_TRANSITION_FIX]
			-- Query the call sequences transit `a_objects' to `a_dest_objects'.
		local
		    l_config: AFX_BEHAVIOR_CONSTRUCTOR_CONFIG
		    l_constructor: AFX_BEHAVIOR_CONSTRUCTOR
			l_loader: AFX_STATE_TRANSITION_MODEL_LOADER
		do
   			create l_loader.make
   			l_loader.load_state_transition_model (a_objects, a_dest_objects)
   			if not l_loader.is_successful then
   			    check error_in_model_loading: False end
   			end

			l_constructor := constructor
		    create l_config.make (a_objects, a_dest_objects, a_context_class, a_class_set)
   			l_constructor.construct_behavior (l_config, a_criteria, a_is_forward)
   			Result := l_constructor.call_sequences
		end

feature -- Access

	constructor: AFX_BEHAVIOR_CONSTRUCTOR
			-- Shared behavior constructor.
		once
		    create Result
		end

end
