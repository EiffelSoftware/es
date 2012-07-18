note
	description: "A class to create repositories with a database backend."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	REPOSITORY_FACTORY

feature -- Connection details

	username:STRING = "tutorial"
	password:STRING = "tutorial"

	db_name:STRING = "tutorial"
	db_host:STRING = "127.0.0.1"
	db_port:INTEGER = 3306

	sqlite_filename: STRING = "tutorial.db"

feature -- Factory methods

	create_mysql_repository: PS_RELATIONAL_REPOSITORY
		-- Create a MySQL repository
		local
			database: PS_MYSQL_DATABASE
			mysql_strings: PS_MYSQL_STRINGS
			backend: PS_GENERIC_LAYOUT_SQL_BACKEND
		do
			create database.make (username, password, db_name, db_host, db_port)
			create mysql_strings
			create backend.make (database, mysql_strings)
			create Result.make (backend)
		end

	create_sqlite_repository: PS_RELATIONAL_REPOSITORY
		-- Create an SQLite repository
		local
			database: PS_SQLITE_DATABASE
			sqlite_strings: PS_SQLITE_STRINGS
			backend: PS_GENERIC_LAYOUT_SQL_BACKEND
		do
			create database.make (sqlite_filename)
			create sqlite_strings
			create backend.make (database, sqlite_strings)
			create Result.make (backend)
		end
end
