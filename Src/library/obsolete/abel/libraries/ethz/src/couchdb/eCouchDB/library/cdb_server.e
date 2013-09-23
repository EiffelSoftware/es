note
	description: "Summary description for {CDB_SERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CDB_SERVER
inherit
	SHARED_HTTP_CLIENT

feature -- Access
	info : detachable STRING -- void safety addition - returns result of HTTP request which may fail
			-- Get MOTD and version
		do
			Result := http.get ("/")
		end

	databases : detachable STRING -- void safety addition - returns result of HTTP request which may fail
			-- Get a list of databases
		do
			Result := http.get ("/_all_dbs")
		end

	config : detachable STRING -- void safety addition - returns result of HTTP request which may fail
			-- Get configuration data
		do
			Result := http.get ("/_config")
		end

	uuids : detachable STRING -- void safety addition - returns result of HTTP request which may fail
			-- Get a number of UUIDs
		do
			Result := http.get ("/_uuids")
		end

	replicate : detachable STRING -- void safety addition - returns result of HTTP request which may fail
			-- Replicate
		do
			--	Result := http.post ()
		end

	stats : detachable STRING -- void safety addition - returns result of HTTP request which may fail
			-- Statistics overview
		do
			Result := http.get ("/_stats")
		end

	active_task : detachable STRING -- void safety addition - returns result of HTTP request which may fail
			-- Active task list
		do
			Result := http.get ("/_active_tasks")
		end

end
