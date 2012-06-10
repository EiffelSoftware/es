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
			create {PS_MYSQL_CONNECTION} Result.make (database)
		end

	release_connection (a_connection:PS_SQL_CONNECTION_ABSTRACTION)
		do
			-- ignore for the moment - connection pooling first has to be implemented
		end


feature{NONE}

	make (username, password, db_name, db_host:STRING; db_port:INTEGER)
		do
			user:= username
			pw:= password
			name:= db_name
			host:= db_host
			port:= db_port
		end

	user:STRING
	pw:STRING
	name:STRING
	host:STRING
	port:INTEGER

end
