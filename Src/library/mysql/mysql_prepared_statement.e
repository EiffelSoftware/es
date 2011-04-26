note
	description: "MySQL Stmt Class (Interface to C Library)"
	author: "haroth@student.ethz.ch"
	date: "$Date$"
	revision: "$Revision$"

class
	MYSQL_PREPARED_STATEMENT

inherit
	ITERABLE [ARRAY [STRING]]

	DISPOSABLE

	MYSQL_CONSTANTS

create
	make

feature{MYSQL_CLIENT} -- Initialization

	make (a_mysql: MYSQL_CLIENT; a_stmt, a_bind, a_data: POINTER)
			-- Create an empty prepared statement for a MySQL client in `a_client'.
			-- `a_stmt', `a_bind' and `a_data' are pointers
			-- to the C datastructures for a prepared statement.
		do
			-- Client
			mysql := a_mysql
			-- Datastructures for C
			p_stmt := a_stmt
			p_bind := a_bind
			p_data := a_data
			create p_resbind.default_create
			create p_resdata.default_create
			-- State
			is_open := True
			is_executed := False
			has_result_set := False
			-- List for string parameters (avoid Garbage Collection)
			create string_parameters.make_filled (Void, 0, param_count - 1)
		end

feature -- Access: Cursor

	new_cursor: MYSQL_PREPARED_STATEMENT_CURSOR
			-- <Precursor>
		do
			create Result.make (Current)
		end

feature -- Access

	param_count: INTEGER
		-- The number of parameters in this prepared statement
		require
			is_open: is_open
		do
			Result := c_stmt_param_count ($p_stmt)
		end

	row_count: INTEGER
			-- The number of rows in this result set
		require
			is_open: is_open
			has_result_set: has_result_set
		do
			Result := c_stmt_num_rows ($p_stmt)
		end

	affected_rows: INTEGER
			-- The number of rows modified by the last call to `execute'
		require
			is_open: is_open
			is_executed: is_executed
		do
			Result := c_stmt_affected_rows ($p_stmt)
		end

	last_insert_id: INTEGER
			-- The ID generated for an AUTO_INCREMENT column by the last call to `execute'
		require
			is_open: is_open
			is_executed: is_executed
		do
			Result := c_stmt_insert_id ($p_stmt)
		end

	column_count: INTEGER
		-- The number of  columns in the result set of the most recent call to `execute'
		require
			is_open: is_open
		do
			Result := c_stmt_field_count ($p_stmt)
		end

	column_name_at (a_pos: INTEGER): STRING
			-- The column name at column index `a_pos'
		require
			is_open: is_open
			not_off: not off
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= column_count
		local
			c_ptr: POINTER
			c_length: INTEGER
		do
			create c_ptr.default_create
			c_length := c_stmt_column_at_new ($p_stmt, a_pos-1, $c_ptr)
			create Result.make (c_length+1)
			Result.from_c_substring (c_ptr, 1, c_length)
--			Result := c_stmt_column_at ($p_stmt, a_pos-1)
		end

	integer_at (a_pos: INTEGER): INTEGER
			-- The integer value in the current row at column index `a_pos'
		require
			mysql_client_is_connected: mysql.is_connected
			is_open: is_open
			has_result_set: has_result_set
			not_off: not off
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= column_count
		do
			Result := c_stmt_int_at ($p_resdata, a_pos-1)
		end

	double_at (a_pos: INTEGER): DOUBLE
			-- The double value in the current row at column index `a_pos'
		require
			mysql_client_is_connected: mysql.is_connected
			is_open: is_open
			has_result_set: has_result_set
			not_off: not off
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= column_count
		do
			Result := c_stmt_double_at ($p_resdata, a_pos-1)
		end

	string_at (a_pos: INTEGER): STRING
			-- The string value in the current row at column index `a_pos'
		require
			mysql_client_is_connected: mysql.is_connected
			is_open: is_open
			has_result_set: has_result_set
			not_off: not off
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= column_count
		local
			c_ptr: POINTER
			c_length: INTEGER
		do
			create c_ptr.default_create
			c_length := c_stmt_string_at_new ($p_resdata, a_pos-1, $c_ptr)
			create Result.make (c_length+1)
			Result.from_c_substring (c_ptr, 1, c_length)
--			Result := c_stmt_string_at ($p_resdata, a_pos-1)
		end

	at (a_pos: INTEGER): STRING
			-- String representation of the value at `a_pos'
			-- For NULL data value, return the string "NULL".
		require
			mysql_client_is_connected: mysql.is_connected
			is_open: is_open
			has_result_set: has_result_set
			not_off: not off
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= column_count
		do
			if is_null_at (a_pos) then
				Result := mysql_null_string
			elseif is_integer_at (a_pos) then
				Result := integer_at (a_pos).out
			elseif is_double_at (a_pos) then
				Result := double_at (a_pos).out
			elseif is_string_at (a_pos) then
				Result := string_at (a_pos)

			end
		end

	all_data: ARRAY [ARRAY [STRING]]
			-- All data in all rows
			-- The outer array represents rows, the inner array represents a single row.
		require
			mysql_is_connected: mysql.is_connected
			is_open: is_open
		local
			l_row: INTEGER
		do
			create Result.make_filled (create{ARRAY [STRING]}.make_empty, 1, row_count)
			l_row := 1
			across Current as l_rows loop
				Result.put (l_rows.item, l_row)
				l_row := l_row + 1
			end
		end

feature -- Status report

	is_open: BOOLEAN
		-- Has this query result set not yet been `disposed'?

	is_executed: BOOLEAN
		-- Has the last call to `execute' succeeded?

	has_result_set: BOOLEAN
		-- Has the last call to `execute' returned a result set?

	is_integer_at (a_pos: INTEGER): BOOLEAN
			-- Is the value in the current row at column index `a_pos' an integer?
		require
			mysql_client_is_connected: mysql.is_connected
			is_open: is_open
			has_result_set: has_result_set
			not_off: not off
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= column_count
		do
			Result := c_stmt_is_int_at ($p_resbind, a_pos-1) > 0
		end

	is_double_at (a_pos: INTEGER): BOOLEAN
			-- Is the value in the current row at column index `a_pos' a double/float?
		require
			mysql_client_is_connected: mysql.is_connected
			is_open: is_open
			has_result_set: has_result_set
			not_off: not off
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= column_count
		do
			Result := c_stmt_is_double_at ($p_resbind, a_pos-1) > 0
		end

	is_string_at (a_pos: INTEGER): BOOLEAN
			-- Is the value in the current row at column index `a_pos' a char/string/blob?
		require
			mysql_client_is_connected: mysql.is_connected
			is_open: is_open
			has_result_set: has_result_set
			not_off: not off
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= column_count
		do
			Result := c_stmt_is_string_at ($p_resbind, a_pos-1) > 0
		end

	is_null_at (a_pos: INTEGER): BOOLEAN
			-- Is the value in the current row at column index `a_pos' NULL?
		require
			mysql_client_is_connected: mysql.is_connected
			is_open: is_open
			has_result_set: has_result_set
			not_off: not off
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= column_count
		do
			Result := c_stmt_null_at ($p_resbind, a_pos-1) > 0
		end

	off: BOOLEAN
		-- Are there no more rows?

	after: BOOLEAN
			-- Are there no more rows?
		do
			Result := off
		end

feature -- Commands

	dispose
		-- Dispose of this prepared statenement
		do
			if is_open then
				c_stmt_free ($p_stmt, $p_bind, $p_data, $p_resbind, $p_resdata)
				c_stmt_close ($p_stmt)
			end
			is_open := False
		end

	set_null (a_pos: INTEGER)
		-- Set parameter `a_pos' to NULL
		require
			is_open: is_open
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= param_count
		do
			string_parameters.put (Void, a_pos-1)
			c_stmt_set_null ($p_bind, $p_data, a_pos-1)
		end

	set_integer (a_pos, a_value: INTEGER)
		-- Set integer parameter `a_pos' to `a_value'
		require
			is_open: is_open
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= param_count
		do
			string_parameters.put (Void, a_pos-1)
			c_stmt_set_int ($p_bind, $p_data, a_pos-1, a_value)
		end

	set_double (a_pos: INTEGER; a_value: DOUBLE)
		-- Set double parameter `a_pos' to `a_value'
		require
			is_open: is_open
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= param_count
		do
			string_parameters.put (Void, a_pos-1)
			c_stmt_set_double ($p_bind, $p_data, a_pos-1, a_value)
		end

	set_string (a_pos: INTEGER; a_value: STRING)
		-- Set char/string/blob parameter `a_pos' to `a_value'
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
		-- Execute this prepared statement with the parameters set by
		-- `set_null', `set_int', `set_double' and `set_string'
		require
			is_open: is_open
		local
			c_string: ANY
			i: INTEGER
		do
			is_executed := False
			has_result_set := False
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
				is_executed := True
				if c_stmt_bind_result ($p_stmt, $p_resbind, $p_resdata) = 0 then
					has_result_set := True
				end
			end
		end

	go_i_th (a_pos: INTEGER)
			-- Seek to row index `a_pos' in this statement's result set
		require
			is_open: is_open
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= row_count
		do
			c_stmt_seek ($p_stmt, a_pos-1)
			forth
		end

	start
			-- Seeks to the first row in this statement's result set
		require
			is_open: is_open
			has_result_set: has_result_set
		do
			go_i_th (1)
		end

	forth
			-- Fetch the next row from this statement's result set
		require
			is_open: is_open
			has_result_set: has_result_set
		do
			off := True
			if c_stmt_fetch ($p_stmt) = 0 then
				off := False
			end
		end

feature -- Implementation

	mysql: MYSQL_CLIENT

feature{NONE} -- Implementation	

	string_parameters: ARRAY [STRING]
			-- Avoid garbage collection of strings in parameters

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

	c_stmt_column_at_new (a_stmt: POINTER; a_pos: INTEGER; a_str: POINTER): INTEGER
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

	c_stmt_string_at_new (a_resdata: POINTER; a_pos: INTEGER; a_str: POINTER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

end
