note
	description: "Summary description for {PS_SQL_DATABASE_ABSTRACTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_SQL_DATABASE_ABSTRACTION

feature

	acquire_connection: PS_SQL_CONNECTION_ABSTRACTION
		deferred
		end

	release_connection (a_connection:PS_SQL_CONNECTION_ABSTRACTION)
		deferred
		end

end
