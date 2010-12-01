note
	description: "Summary description for {AFX_SHARED_SERVER_EXPRESSIONS_FROM_FEATURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_SERVER_EXPRESSIONS_FROM_FEATURE

feature -- Access

	server_expressions_from_feature: AFX_SERVER_EXPRESSIONS_FROM_FEATURE
			-- Server to be queried about expressions from a feature.
		do
			Result := Server_cache.item
		end

feature -- Status set

	set_server_expressions_from_feature (a_server: AFX_SERVER_EXPRESSIONS_FROM_FEATURE)
			-- Set server.
		require
			server_attached: a_server /= Void
		do
			Server_cache.put (a_server)
		end

feature {NONE} -- Implementation

	Server_cache: CELL [AFX_SERVER_EXPRESSIONS_FROM_FEATURE]
			-- Cache for program state expression server.
		once
			create Result.put (create {AFX_SERVER_EXPRESSIONS_FROM_FEATURE}.make (10))
		end

end
