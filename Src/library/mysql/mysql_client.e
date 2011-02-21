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
	make

feature -- Initialization

	make (host, username, password, database: STRING; port: INTEGER)
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

	last_errno: INTEGER
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

	dispose
			-- Close a server connection.
		do
			if is_connected then
				mysql_result.dispose
				c_close ($p_mysql)
			end
			is_connected := False
			has_result := False
		end


feature {NONE} -- Implementation

	mysql_stmt: MYSQL_PREPARED_STATEMENT
			-- Current prepared statement

	mysql_result: MYSQL_RESULT
			-- Current result set

feature{NONE} -- External

	p_mysql, p_row: POINTER
			-- Pointer to MYSQL, MYSQL_ROW structures

	c_real_connect (a_mysql, a_row, a_host, a_username, a_password, a_database: POINTER; port: INTEGER): INTEGER
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
