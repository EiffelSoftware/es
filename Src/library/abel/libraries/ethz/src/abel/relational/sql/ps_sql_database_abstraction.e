note
	description: "[
		Provides the interface for a wrapper to a database like MySQL or SQlite.
		Descendants may implement connection pooling, or just open and close connections all the time.		
		]"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_SQL_DATABASE_ABSTRACTION

feature {PS_EIFFELSTORE_EXPORT}

	acquire_connection: PS_SQL_CONNECTION_ABSTRACTION
		-- Get a new connection.
		-- The transaction isolation level of th new connection is the same as in `Current.transaction_isolation_level', and autocommit is disabled.
		deferred
		end

	release_connection (a_connection:PS_SQL_CONNECTION_ABSTRACTION)
		-- Release connection `a_connection'
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
