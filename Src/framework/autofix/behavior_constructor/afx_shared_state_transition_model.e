note
	description: "Summary description for {AFX_SHARED_STATE_TRANSITION_MODEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_STATE_TRANSITION_MODEL

feature -- Access

	state_transition_model: AFX_STATE_TRANSITION_MODEL
			-- Shared state transition model.
		once
		    create Result.make_default
		end

end
