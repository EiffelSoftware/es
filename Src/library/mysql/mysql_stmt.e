note
	description: "MySQL Stmt Class (Interface to C Library)"
	author: "haroth@student.ethz.ch"
	date: "$Date$"
	revision: "$Revision$"

class
	MYSQL_STMT

create
	make

feature{MYSQL_CLIENT}

	make (a_mysql: MYSQL_CLIENT; a_stmt, a_bind, a_data: POINTER)
			-- Initializer
		do
			-- MYSQL_CLIENT
			mysql := a_mysql
			-- Datastructures for C
			p_stmt := a_stmt
			p_bind := a_bind
			p_data := a_data
			-- State
			is_open := True
			is_executed := False
			-- List for string parameters (avoid Garbage Collection)
			create string_parameters.make_filled (Void, 0, param_count - 1)
		end

feature

	is_open: BOOLEAN
		-- Whether this statement was closed

	is_executed: BOOLEAN
		-- Whether this statement was executed successfully

	off: BOOLEAN
		-- Is there no more row?

	close
		-- Frees memory used by a prepared statement (mysql_stmt_close)
		-- Free the resources allocated to a statement handle (mysql_stmt_free)
		do
			is_open := False
			string_parameters.wipe_out
			c_stmt_free ($p_stmt, $p_bind, $p_data, $p_resbind, $p_resdata)
			c_stmt_close ($p_stmt)
		end

	param_count: INTEGER
		-- Returns the number of parameters in a prepared statement (mysql_stmt_param_count)
		require
			is_open: is_open
		do
			Result := c_stmt_param_count ($p_stmt)
		end

	set_null (a_pos: INTEGER)
		-- Set parameter at position to NULL (MYSQL_BIND)
		require
			is_open: is_open
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= param_count
		do
			string_parameters.put (Void, a_pos-1)
			c_stmt_set_null ($p_bind, $p_data, a_pos-1)
		end

	set_int (a_pos, a_value: INTEGER)
		-- Set parameter at position to value (MYSQL_BIND)
		require
			is_open: is_open
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= param_count
		do
			string_parameters.put (Void, a_pos-1)
			c_stmt_set_int ($p_bind, $p_data, a_pos-1, a_value)
		end

	set_double (a_pos: INTEGER; a_value: DOUBLE)
		-- Set parameter at position to value (MYSQL_BIND)
		require
			is_open: is_open
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= param_count
		do
			string_parameters.put (Void, a_pos-1)
			c_stmt_set_double ($p_bind, $p_data, a_pos-1, a_value)
		end

	set_string (a_pos: INTEGER; a_value: STRING)
		-- Set parameter at position to value (MYSQL_BIND)
		require
			is_open: is_open
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= param_count
		local
			c_value: ANY
		do
			string_parameters.put (a_value, a_pos-1)
		end

	execute
		-- Executes a prepared statement (mysql_stmt_execute)
		-- Associates application data buffers with columns in a result set (mysql_stmt_bind_result)
		require
			is_open: is_open
		local
			c_string: ANY
			i: INTEGER
		do
			is_executed := False
			from
				i := 0
			until
				i >= string_parameters.count
			loop
				if string_parameters.at (i) /= Void then
					c_string := string_parameters.at (i).to_c
					c_stmt_set_string ($p_bind, $p_data, i, $c_string, string_parameters.at (i).count)
				end
				i := i + 1
			end

			if c_stmt_execute ($p_stmt, $p_bind) = 0 then
				if c_stmt_bind_result ($p_stmt, $p_resbind, $p_resdata) = 0 then
					is_executed := True
				end
			end
		end

	num_rows: INTEGER
			-- Returns the number of rows in a result set (mysql_num_rows)
		require
			is_open: is_open
			is_executed: is_executed
		do
			Result := c_stmt_num_rows ($p_stmt)
		end

	affected_rows: INTEGER
			-- Returns the number of rows changed, deleted, or inserted by prepared UPDATE, DELETE, or INSERT statement (mysql_stmt_affected_rows)
		require
			is_open: is_open
			is_executed: is_executed
		do
			Result := c_stmt_affected_rows ($p_stmt)
		end

	last_insert_id: INTEGER
			-- Returns the ID generated for an AUTO_INCREMENT column by a prepared statement (mysql_stmt_insert_id)
		require
			is_open: is_open
			is_executed: is_executed
		do
			Result := c_stmt_insert_id ($p_stmt)
		end

	field_count: INTEGER
		-- Returns the number of result columns for the most recent statement (mysql_stmt_field_count)
		require
			is_open: is_open
		do
			Result := c_stmt_field_count ($p_stmt)
		end

	column_at (a_pos: INTEGER): STRING
			-- Returns the column name at pos
		require
			is_open: is_open
			not_off: not off
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= param_count
		do
			Result := c_stmt_column_at ($p_stmt, a_pos-1)
		end

	go_i_th (a_pos: INTEGER)
			-- Seeks to an arbitrary row in a query result set (mysql_stmt_data_seek)
		require
			is_open: is_open
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= num_rows
		do
			c_stmt_seek ($p_stmt, a_pos-1)
			forth
		end

	start
			-- Seeks to first row in a query result set (mysql_stmt_data_seek)
		require
			is_open: is_open
			is_executed: is_executed
		do
			go_i_th (1)
		end

	forth
			-- Fetches the next row of data from a result set and returns data for all bound columns (mysql_stmt_fetch)
		require
			is_open: is_open
			is_executed: is_executed
		do
			off := True
			if c_stmt_fetch ($p_stmt) = 0 then
				off := False
			end
		end

	is_int_at (a_pos: INTEGER): BOOLEAN
			-- Returns true if value at pos is an integer
		require
			mysql_client_is_connected: mysql.is_connected
			is_open: is_open
			is_executed: is_executed
			not_off: not off
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= field_count
		do
			Result := c_stmt_is_int_at ($p_resbind, a_pos-1) > 0
		end

	is_double_at (a_pos: INTEGER): BOOLEAN
			-- Returns true if value at pos is an integer
		require
			mysql_client_is_connected: mysql.is_connected
			is_open: is_open
			is_executed: is_executed
			not_off: not off
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= field_count
		do
			Result := c_stmt_is_double_at ($p_resbind, a_pos-1) > 0
		end

	is_string_at (a_pos: INTEGER): BOOLEAN
			-- Returns true if value at pos is an integer
		require
			mysql_client_is_connected: mysql.is_connected
			is_open: is_open
			is_executed: is_executed
			not_off: not off
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= field_count
		do
			Result := c_stmt_is_string_at ($p_resbind, a_pos-1) > 0
		end

	null_at (a_pos: INTEGER): BOOLEAN
			-- Returns true if value at pos is NULL
		require
			mysql_client_is_connected: mysql.is_connected
			is_open: is_open
			is_executed: is_executed
			not_off: not off
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= field_count
		do
			Result := c_stmt_null_at ($p_resbind, a_pos-1) > 0
		end

	int_at (a_pos: INTEGER): INTEGER
			-- Returns the integer value at pos
		require
			mysql_client_is_connected: mysql.is_connected
			is_open: is_open
			is_executed: is_executed
			not_off: not off
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= field_count
		do
			Result := c_stmt_int_at ($p_resdata, a_pos-1)
		end

	double_at (a_pos: INTEGER): DOUBLE
			-- Returns the integer value at pos
		require
			mysql_client_is_connected: mysql.is_connected
			is_open: is_open
			is_executed: is_executed
			not_off: not off
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= field_count
		do
			Result := c_stmt_double_at ($p_resdata, a_pos-1)
		end

	string_at (a_pos: INTEGER): STRING
			-- Returns the string value at pos
		require
			mysql_client_is_connected: mysql.is_connected
			is_open: is_open
			is_executed: is_executed
			not_off: not off
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= field_count
		do
			Result := c_stmt_string_at ($p_resdata, a_pos-1)
		end

feature -- Parents

	mysql: MYSQL_CLIENT

feature{NONE} -- Implementation

	string_parameters: ARRAY [STRING]
			-- Avoid garbage collection of string in parameters

feature{NONE} -- External

	p_stmt, p_bind, p_data, p_resbind, p_resdata: POINTER
			-- Pointer to MYSQL_STMT, MYSQL_BIND and STMT_DATA structures

	c_stmt_close (a_stmt: POINTER)
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_free (a_stmt, a_bind, a_data, a_resbind, a_resdata: POINTER)
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_field_count (a_stmt: POINTER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_num_rows (a_stmt: POINTER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_affected_rows (a_stmt: POINTER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_insert_id (a_stmt: POINTER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_fetch (a_stmt: POINTER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_execute (a_stmt, a_bind: POINTER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_bind_result (a_stmt, a_resbind, a_resdata: POINTER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_set_null (a_bind, a_data: POINTER; a_pos: INTEGER)
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_set_int (a_bind, a_data: POINTER; a_pos, a_value: INTEGER)
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_set_double (a_bind, a_data: POINTER; a_pos, a_value: DOUBLE)
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_set_string (a_bind, a_data: POINTER; a_pos: INTEGER; a_value: POINTER; a_len: INTEGER)
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_column_at (a_stmt: POINTER; a_pos: INTEGER): STRING
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_seek (a_stmt: POINTER; a_pos: INTEGER)
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_param_count (a_stmt: POINTER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_is_int_at (a_resbind: POINTER; a_pos: INTEGER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_is_double_at (a_resbind: POINTER; a_pos: INTEGER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_is_string_at (a_resbind: POINTER; a_pos: INTEGER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_null_at (a_resbind: POINTER; a_pos: INTEGER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_int_at (a_resdata: POINTER; a_pos: INTEGER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_double_at (a_resdata: POINTER; a_pos: INTEGER): DOUBLE
		external
			"C | %"eiffelmysql.h%""
		end

	c_stmt_string_at (a_resdata: POINTER; a_pos: INTEGER): STRING
		external
			"C | %"eiffelmysql.h%""
		end

end
