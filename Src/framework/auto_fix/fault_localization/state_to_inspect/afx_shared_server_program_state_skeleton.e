note
	description: "Summary description for {AFX_SHARED_SERVER_PROGRAM_STATE_SKELETON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_SERVER_PROGRAM_STATE_SKELETON

feature -- Access

	server_program_state_skeleton: AFX_SERVER_PROGRAM_STATE_SKELETON
			-- Server to be queried about program state skeletons.
		do
			Result := Server_cache.item
		end

feature -- Status set

	set_server_program_state_skeleton (a_server: AFX_SERVER_PROGRAM_STATE_SKELETON)
			-- Set server.
		require
			server_attached: a_server /= Void
		do
			Server_cache.put (a_server)
		end

feature {NONE} -- Implementation

	Server_cache: CELL [AFX_SERVER_PROGRAM_STATE_SKELETON]
			-- Cache.
		once
			create Result.put (create {AFX_SERVER_PROGRAM_STATE_SKELETON})
		end

end
