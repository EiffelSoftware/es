note
	description: "MySQL Client Class (Interface to C Library)"
	author: "haroth@student.ethz.ch"
	date: "$Date$"
	revision: "$Revision$"

class
	MYSQL_CLIENT

inherit
	DISPOSABLE

create
	make,
	make_with_database

feature -- Initialization

	make
		do
			-- State
			is_connected := False
			has_result := False
			has_prepared_statement := False
			mysql_stmt := Void
			-- Defaults
			host := once "127.0.0.1"
			username := once "root"
			password := once ""
			database := once "test"
			port := 0
			-- C Datastructures
			create p_mysql.default_create
			create p_row.default_create
		end

	make_with_database (a_host: STRING; a_username: STRING; a_password: STRING; a_database: STRING; a_port: INTEGER)
			-- Initialize Current.
		do
			make
			set_host (a_host)
			set_username (a_username)
			set_password (a_password)
			set_database (a_database)
			set_port (a_port)
		end

feature -- Connect

	host: STRING
			-- Host name of the database server

	username: STRING
			-- User name used to connect to the database server

	password: STRING
			-- Password used to connect to the database server

	database: STRING
			-- Schema name of the database

	port: INTEGER
			-- Connection details

	set_host (a_host: STRING)
			-- Set MySQL hostname to `a_host'
		do
			host := a_host
		end

	set_username (a_username: STRING)
			-- Set MySQL username to `a_username'
		do
			username := a_username
		end

	set_password (a_password: STRING)
			-- Set MySQL password to `a_password'
		do
			password := a_password
		end

	set_database (a_database: STRING)
			-- Set MySQL database to `a_database'
		do
			database := a_database
		end

	set_port (a_port: INTEGER)
			-- Set MySQL port to `a_port'
		do
			port := a_port
		end

feature -- Connection

	connect
			-- Connects to a MySQL server at `host':`port' with
			-- `username' and `password'. Selects `database'.
		require
			host_not_void: host /= Void
			username_not_void: username /= Void
			password_not_void: password /= Void
			database_not_void: database /= Void
		local
			c_host, c_username, c_password, c_database: ANY
		do
			-- Close previous connection
			if is_connected then
				close
			end
			-- Pointers for C
			c_host := host.to_c
			c_username := username.to_c
			c_password := password.to_c
			c_database := database.to_c
			-- Defaults
			is_connected := False
			has_result := False
			has_prepared_statement := False
			mysql_stmt := Void
			-- Try to connect
			if c_real_connect ($p_mysql, $p_row, $c_host, $c_username, $c_password, $c_database, port) = 0 then
				is_connected := True
				-- Create result
				create mysql_result.make (Current, p_row)
			end
		end

	reinitialize
			-- Reinitialize Current connection
		do
			make_with_database(host, username, password, database, port)
			connect
		end

feature -- Status report

	is_connected: BOOLEAN
			-- Has the last connection attempt succeeded?

	has_result: BOOLEAN
			-- Has the last call to `execute_query' succeeded?

	has_prepared_statement: BOOLEAN
			-- Has the last call to `prepare_statement' succeeded?

feature -- Access

	last_prepared_statement: MYSQL_PREPARED_STATEMENT
			-- Current prepared statement, available after call to `prepare_statement'.
		require
			has_statement: has_prepared_statement
		do
			Result := mysql_stmt
		end

	last_result: MYSQL_RESULT
			-- Current result set, available after call to `execute_query'
		require
			has_result: has_result
		do
			Result := mysql_result
		end

	last_affected_rows: INTEGER
			-- The number of rows modified by the last call to `execute_query'
		require
			is_connected: is_connected
		do
			Result := c_affected_rows ($p_mysql)
		end

	last_error_number: INTEGER
			-- The error number for the most recently invoked MySQL API call
		require
			is_connected: is_connected
		do
			Result := c_errno ($p_mysql)
		end

	last_error: STRING
			-- The error message for the most recently invoked MySQL API call
		require
			is_connected: is_connected
		do
			Result := c_error ($p_mysql)
		end

	last_insert_id: INTEGER
			-- The ID generated for an AUTO_INCREMENT column by the last call to `execute_query'
		require
			is_connected: is_connected
		do
			Result := c_insert_id ($p_mysql)
		end


feature -- Commands

	prepare_statement (a_stmt: STRING)
			-- Prepare the SQL query in `a_stmt' for execution.
		require
			stmt_not_voud: a_stmt /= Void
			is_connected: is_connected
		local
			c_stmt: ANY
			p_stmt, p_bind, p_data: POINTER
		do
			-- Enforce single open statement
--			if stmt /= Void then
--				stmt.dispose
--			end
			-- Pointer for C
			c_stmt := a_stmt.to_c
			mysql_stmt := Void
			has_prepared_statement := False
			if c_stmt_prepare ($p_mysql, $p_stmt, $p_bind, $p_data, $c_stmt) = 0 then
				create mysql_stmt.make (Current, p_stmt, p_bind, p_data)
				has_prepared_statement := True
			end
		end

	execute_query (a_query: STRING)
			-- Execute the SQL query in `a_query'.
		require
			query_not_void: a_query /= Void
			is_connected: is_connected
		do
			mysql_result.execute_query (p_mysql, a_query)
			has_result := mysql_result.is_open
		end

	close
			-- Close a server connection.
		do
			if is_connected then
				mysql_result.dispose
				c_close ($p_mysql)
			end
			is_connected := False
			has_result := False
			has_prepared_statement := False
			mysql_stmt := Void
		end


	dispose
			-- Close a server connection.
		do
			close
		end


feature {NONE} -- Implementation

	mysql_stmt: MYSQL_PREPARED_STATEMENT
			-- Current prepared statement

	mysql_result: MYSQL_RESULT
			-- Current result set

feature{NONE} -- External

	p_mysql, p_row: POINTER
			-- Pointer to MYSQL, MYSQL_ROW structures

	c_real_connect (a_mysql, a_row, a_host, a_username, a_password, a_database: POINTER; a_port: INTEGER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_prepare (a_mysql, a_stmt, a_bind, a_data, a_statement: POINTER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_affected_rows (a_mysql: POINTER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_close (a_mysql: POINTER)
		external
			"C | %"eiffelmysql.h%""
		end

	c_errno (a_mysql: POINTER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_error (a_mysql: POINTER): STRING
		external
			"C | %"eiffelmysql.h%""
		end

	c_insert_id (a_mysql: POINTER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

end
