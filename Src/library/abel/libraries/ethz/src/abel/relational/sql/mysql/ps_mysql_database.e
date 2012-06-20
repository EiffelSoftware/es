note
	description: "Summary description for {PS_MYSQL_DATABASE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_MYSQL_DATABASE
inherit
	PS_SQL_DATABASE_ABSTRACTION

create make

feature

	acquire_connection: PS_SQL_CONNECTION_ABSTRACTION
		local
			database:MYSQLI_CLIENT
		do
			create database.make
			database.set_username (user)
			database.set_password (pw)
			database.set_database (name)
			database.set_host (host)
			database.set_port (port)
			database.connect
			database.set_flag_autocommit (False)

			internal_set_transaction_level (database)
--			print (database.last_error_message)
			create {PS_MYSQL_CONNECTION} Result.make (database)



		end

	release_connection (a_connection:PS_SQL_CONNECTION_ABSTRACTION)
		do
			check attached{PS_MYSQL_CONNECTION} a_connection as conn then
				conn.internal_connection.rollback
				conn.internal_connection.close

			end
		end


feature{NONE}

	make (username, password, db_name, db_host:STRING; db_port:INTEGER)
		do
			user:= username
			pw:= password
			name:= db_name
			host:= db_host
			port:= db_port
			create transaction_isolation_level
			transaction_isolation_level:= transaction_isolation_level.repeatable_read -- This is the standard in MySQL for InnoDB tables
		end

	user:STRING
	pw:STRING
	name:STRING
	host:STRING
	port:INTEGER

	internal_set_transaction_level (a_connection: MYSQLI_CLIENT)
		do
			if transaction_isolation_level = transaction_isolation_level.read_uncommitted then
				a_connection.execute_query ("SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED")
			elseif transaction_isolation_level = transaction_isolation_level.read_committed then
				a_connection.execute_query ("SET TRANSACTION ISOLATION LEVEL READ COMMITTED")
			elseif transaction_isolation_level = transaction_isolation_level.repeatable_read then
				-- Do nothing - This is the standard
			elseif transaction_isolation_level = transaction_isolation_level.serializable then
				a_connection.execute_query ("SET TRANSACTION ISOLATION LEVEL SERIALIZABLE")
			end
		end

end
