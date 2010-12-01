note
	description: "Summary description for {AFX_SHARED_SERVER_VARIABLES_IN_SCOPE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_SHARED_SERVER_VARIABLES_IN_SCOPE

inherit
	ANY
		undefine
			is_equal,
			copy
		end

feature -- Access

	server_variables_in_scope: AFX_SERVER_VARIABLES_IN_SCOPE
			-- Shared server.
		do
			Result := server_variables_in_scope_cell.item
		end

feature -- Status set

	set_server_variables_in_scope (a_server: AFX_SERVER_VARIABLES_IN_SCOPE)
			-- Set `server_variables_in_scope'.
		do
			server_variables_in_scope_cell.put (a_server)
		end

feature{NONE} -- Storage

	server_variables_in_scope_cell: CELL [AFX_SERVER_VARIABLES_IN_SCOPE]
			-- Storage for `server_variables_in_scope'.
		once
			create Result.put (create {AFX_SERVER_VARIABLES_IN_SCOPE})
		end

end
