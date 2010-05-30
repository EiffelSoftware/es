note
	description: "Summary description for {AFX_SHARED_STATE_SERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_STATE_SERVER

feature -- Access

	state_server: AFX_STATE_SERVER
			-- State server
		once
			create Result.make
		end
end
