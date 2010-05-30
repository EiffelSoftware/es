note
	description: "Summary description for {AFX_QUERY_MODEL_TRANSITION_SELECTOR_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_QUERY_MODEL_TRANSITION_SELECTOR_I

feature -- Status report

	is_suitable (a_transition: AFX_QUERY_MODEL_TRANSITION): BOOLEAN
			-- Is `a_transition' suitable to be used as source in model construction?
		deferred
		end

end
