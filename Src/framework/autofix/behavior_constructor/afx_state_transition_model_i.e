note
	description: "Summary description for {AFX_STATE_TRANSITION_MODEL_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_STATE_TRANSITION_MODEL_I

inherit
    AFX_SHARED_SESSION

    AFX_SHARED_BOOLEAN_STATE_OUTLINE_MANAGER
    	undefine is_equal, copy end

feature -- Status report

	is_good: BOOLEAN
			-- Is manager good to use?
		deferred
		end

	model_directory: STRING
			-- Directory in model repository.
		deferred
		end

feature -- Operation

	optimize_model
			-- Optimize the model.
		deferred
		end

	summarize_transition (a_transition: AFX_BOOLEAN_MODEL_TRANSITION)
			-- Summarize the information from `a_transition'.
		deferred
		end

	clear_summary
			-- Clear all summary information in the manager.
		deferred
		end

	to_summary_set: DS_HASH_SET [AFX_STATE_TRANSITION_SUMMARY]
			-- Return the set of all transition summaries.
		deferred
		end

feature -- Serialization

	save_to_file (a_file_name: STRING)
			-- Save the state transition summary information into file `a_file'.
		deferred
		end

	load_from_file (a_file_name: STRING)
			-- Load the state transition summary information from file `a_file'
		deferred
		end

feature -- Initialization

	initialize_boolean_state_outline_manager
			-- Initialize boolean state outline manager.
		local
		    l_manager: AFX_BOOLEAN_STATE_OUTLINE_MANAGER
		do
		    if boolean_state_outline_manager = Void then
		        create l_manager.make_default
		        set_boolean_state_manager (l_manager)
		    end
		end
end
