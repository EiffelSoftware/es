note
	description: "A database driver manager."
	author: "Stephan van Staden"
	date: "9 June 2009"
	revision: "$Revision$"

deferred class
	DRIVER_MANAGER

feature

	generate_connection (url, user, password: STRING)
		require
			--SL-- True
		deferred
		ensure
			--SL-- Current.<DRIVER_MANAGER.last_connection> |-> _x * DBConnection(_x, {connection:sql(Current, url, user, password)})
		end

	last_connection: CONNECTION

end
