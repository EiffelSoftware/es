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


	transaction_isolation_level: PS_TRANSACTION_ISOLATION_LEVEL
		-- The currently active transaction isolation level


	set_transaction_isolation_level (a_level: PS_TRANSACTION_ISOLATION_LEVEL)
		-- Set the transaction isolation level `a_level' for all connections that are acquired in the future
		do
			transaction_isolation_level:= a_level
		end
end
