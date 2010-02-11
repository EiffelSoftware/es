note
	description: "Summary description for {AFX_SHARED_EVENT_ACTIONS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_EVENT_ACTIONS

feature -- Access

	event_actions: AFX_EVENT_ACTIONS
			-- Event actions
		once
			create Result.make
		end

end
