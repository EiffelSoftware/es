note
	description: "MySQL Client Class (Interface to C Library)"
	author: "haroth@student.ethz.ch"
	date: "$Date$"
	revision: "$Revision$"

class
	MYSQL_CLIENT

create
	make

feature -- Initialization

	make (host, username, password, database: STRING)
			-- Connects to a MySQL server (mysql_real_connect)
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
			has_statement := False
			mysql_stmt := Void
			-- Try to connect
			if c_real_connect ($p_mysql, $p_row, $c_host, $c_username, $c_password, $c_database) = 0 then
				is_connected := True
				-- Create result
				create mysql_result.make (Current, p_row)
			end
		end

feature -- Access

	is_connected: BOOLEAN
			-- Whether this client is connected to a server (mysql_real_connect)

	has_result: BOOLEAN
			-- Whether the last query succeeded (mysql_query)

	has_statement: BOOLEAN
			-- Whether the last prepare statement succeeded (mysql_stmt_prepare)

	prepare_statement (a_stmt: STRING)
			-- Prepares an SQL statement string for execution (mysql_stmt_prepare)
		require
			stmt_not_voud: a_stmt /= Void
			is_connected: is_connected
		local
			c_stmt: ANY
			p_stmt, p_bind, p_data: POINTER
		do
--			-- Enforce single open statement
--			if stmt /= Void then
--				stmt.dispose
--			end
			-- Pointer for C
			c_stmt := a_stmt.to_c
			mysql_stmt := Void
			has_statement := False
			if c_stmt_prepare ($p_mysql, $p_stmt, $p_bind, $p_data, $c_stmt) = 0 then
				create mysql_stmt.make (Current, p_stmt, p_bind, p_data)
				has_statement := True
			end
		end

	last_statement: MYSQL_STMT
			-- Prepares an SQL statement string for execution (mysql_stmt_prepare)
		require
			has_statement: has_statement
		do
			Result := mysql_stmt
		end

	execute_query (a_query: STRING)
			-- Executes an SQL query specified as a null-terminated string (mysql_query)
		require
			query_not_void: a_query /= Void
			is_connected: is_connected
		do
			has_result := mysql_result.execute_query (p_mysql, a_query)
		end

	last_result: MYSQL_RESULT
			-- Retrieves a complete result set to the client (mysql_store_result)
		require
			has_result: has_result
		do
			Result := mysql_result
		end

	last_affected_rows: INTEGER
			-- Returns the number of rows changed/deleted/inserted
			-- by the last UPDATE, DELETE, or INSERT query (mysql_affected_rows)
		require
			is_connected: is_connected
		do
			Result := c_affected_rows ($p_mysql)
		end

	close
			-- Closes a server connection (mysql_close)
		require
			is_connected: is_connected
		do
			is_connected := False
			has_result := False
			c_close ($p_mysql)
		end

	last_errno: INTEGER
			-- Returns the error number for the most recently
			-- invoked MySQL function (mysql_errno)
		require
			is_connected: is_connected
		do
			Result := c_errno ($p_mysql)
		end

	last_error: STRING
			-- Returns the error message for the most recently
			-- invoked MySQL function (mysql_error)
		require
			is_connected: is_connected
		do
			Result := c_error ($p_mysql)
		end

	last_insert_id: INTEGER
			-- Returns the ID generated for an AUTO_INCREMENT column
			-- by the previous query (mysql_insert_id)
		require
			is_connected: is_connected
		do
			Result := c_insert_id ($p_mysql)
		end

feature {NONE} -- Implementation

	mysql_stmt: MYSQL_STMT

	mysql_result: MYSQL_RESULT

feature{NONE} -- External

	p_mysql, p_row: POINTER
			-- Pointer to MYSQL, MYSQL_ROW structures

	c_real_connect (a_mysql, a_row, a_host, a_username, a_password, a_database: POINTER): INTEGER
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
