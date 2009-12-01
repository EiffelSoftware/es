note
	description: "Summary description for {AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY_MANAGER_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY_MANAGER_I

feature -- operation

	summarize_transition (a_transition: AFX_BOOLEAN_MODEL_TRANSITION)
			-- summarize the information from `a_transition' into corresponding summary
		deferred
		end

	to_summary_list: DS_ARRAYED_LIST [AFX_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY]
			-- return the list of all transition summaries
		deferred
		end

end
