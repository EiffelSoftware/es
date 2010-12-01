note
	description: "Summary description for {AFX_SHARED_SERVER_EXPRESSIONS_TO_MONITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_SERVER_EXPRESSIONS_TO_MONITOR

feature -- Access

	server_expressions_to_monitor: AFX_SERVER_EXPRESSIONS_TO_MONITOR
			-- Server to be queried about expressions to monitor.
		do
			Result := Server_cache.item
		end

feature -- Status set

	set_server_expressions_to_monitor (a_server: AFX_SERVER_EXPRESSIONS_TO_MONITOR)
			-- Set server.
		require
			server_attached: a_server /= Void
		do
			Server_cache.put (a_server)
		end

feature {NONE} -- Implementation

	Server_cache: CELL [AFX_SERVER_EXPRESSIONS_TO_MONITOR]
			-- Cache.
		once
			create Result.put (create {AFX_SERVER_EXPRESSIONS_TO_MONITOR})
		end

end
