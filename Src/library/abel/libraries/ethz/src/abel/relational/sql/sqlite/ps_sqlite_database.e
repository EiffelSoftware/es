note
	description: "Wrapper for a SQLite database."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_SQLITE_DATABASE

inherit
	PS_SQL_DATABASE_ABSTRACTION

create
	make

feature {PS_EIFFELSTORE_EXPORT}

	acquire_connection: PS_SQL_CONNECTION_ABSTRACTION
		-- Get a new connection.
		-- The transaction isolation level of th new connection is the same as in `Current.transaction_isolation_level', and autocommit is disabled.
		local
			sqlite_connection: SQLITE_DATABASE
		do
	--		create sqlite_connection.make_create_read_write (database)
	--		sqlite_connection.begin_transaction (False)
	--		create {PS_SQLITE_CONNECTION} Result.make (sqlite_connection)

			create {PS_SQLITE_CONNECTION} Result.make (unique_connection)

		end

	release_connection (a_connection:PS_SQL_CONNECTION_ABSTRACTION)
		-- Release connection `a_connection'
		do
			--check attached {PS_SQLITE_CONNECTION} a_connection as conn then
			--	conn.internal_connection.rollback
			--	conn.internal_connection.close
			--end


		end

feature {NONE} -- Initialization

	make (database_file: STRING)
			-- Initialization for `Current'.
		do
			create transaction_isolation_level
			transaction_isolation_level:= transaction_isolation_level.repeatable_read
			database:= database_file
			create unique_connection.make_create_read_write (database)
		end

	database: STRING


	unique_connection: SQLITE_DATABASE
end
