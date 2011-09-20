note
	description: "Summary description for {AFX_STATE_TRANSITOR_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_STATE_TRANSITOR_I

feature -- Basic operation

	construct_behavior (a_config: AFX_BEHAVIOR_CONSTRUCTOR_CONFIG)
			-- Construct behavior.
		deferred
		end

feature -- Access

	call_sequences: DS_LIST [AFX_STATE_TRANSITION_FIX]
			-- List of state transition fixes.
		deferred
		end

end
