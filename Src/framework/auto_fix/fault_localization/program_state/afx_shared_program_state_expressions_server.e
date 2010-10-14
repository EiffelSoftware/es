note
	description: "Summary description for {AFX_SHARED_PROGRAM_STATE_EXPRESSIONS_SERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_PROGRAM_STATE_EXPRESSIONS_SERVER

create
	default_create

feature -- Access

	state_expression_server: AFX_PROGRAM_STATE_EXPRESSIONS_SERVER
			-- Program state expression server.
		do
			Result := Server_cache.item
		end

feature -- Status set

	set_state_expression_server (a_server: AFX_PROGRAM_STATE_EXPRESSIONS_SERVER)
			-- Set server.
		require
			server_attached: a_server /= Void
		do
			Server_cache.put (a_server)
		end

feature{NONE} -- Implementation

	Server_cache: CELL [AFX_PROGRAM_STATE_EXPRESSIONS_SERVER]
			-- Cache for program state expression server.
		once
			create Result.put (Void)
		end


end
