note
	description: "MySQL Result Class (Interface to C Library)"
	author: "haroth@student.ethz.ch"
	date: "$Date$"
	revision: "$Revision$"

class
	MYSQL_RESULT

inherit
	ITERABLE [ARRAY [STRING]]

	DISPOSABLE

create
	make

feature{MYSQL_CLIENT} -- Initialization

	make (a_client: MYSQL_CLIENT; a_row: POINTER)
			-- Create an empty query result set for a MySQL client in `a_client'.
			-- `a_row' is the pointer to the C datastructure for a row.
		do
				-- Client
			mysql_client := a_client
				-- Datastructures for C
			p_row := a_row
			create p_result.default_create
			-- State
			is_open := False
		end

feature{MYSQL_CLIENT} -- Commands

	execute_query (p_mysql: POINTER; a_query: STRING)
			-- Execute the SQL query in `a_query'.
			-- `p_mysql' is the pointer to the C datastructure
			-- containing the client connection state.
		require
			query_not_void: a_query /= Void
			mysql_client_is_connected: mysql_client.is_connected
		local
			c_a_query: ANY
		do
			is_open := False
			c_a_query := a_query.to_c
			if c_query ($p_mysql, $c_a_query) = 0 then
				if c_store_result ($p_mysql, $p_result) = 0 then
					is_open := True
				end
			end
		end

feature -- Access: Cursor

	new_cursor: MYSQL_RESULT_CURSOR
			-- <Precursor>
		do
			create Result.make (Current)
		end

feature -- Status report

	is_open: BOOLEAN
			-- Has the last call to `execute_query' succeeded,
			-- and has this query result set not yet been `disposed'?

	off: BOOLEAN
			-- Are there no more rows?

	after: BOOLEAN
			-- Are there no more rows?
		do
			Result := off
		end

feature -- Access

	row_count: INTEGER
			-- The number of rows in this query result set
		require
			is_open: is_open
		do
			Result := c_num_rows ($p_result)
		end

	column_count: INTEGER
			-- The number of columns in this query result set
		require
			is_open: is_open
		do
			Result := c_num_fields ($p_result)
		end

	column_name_at (a_pos: INTEGER): STRING
			-- The column name at column index `a_pos'
		require
			mysql_client_is_connected: mysql_client.is_connected
			is_open: is_open
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= column_count
		local
			c_ptr: POINTER
			c_length: INTEGER
		do
			create c_ptr.default_create
			c_length := c_column_at_new ($p_result, a_pos-1, $c_ptr)
			create Result.make (c_length+1)
			Result.from_c_substring (c_ptr, 1, c_length)
--			Result := c_column_at ($p_result, a_pos-1)
		end

	at (a_pos: INTEGER): STRING
			-- The string value at column index `a_pos'
		require
			mysql_client_is_connected: mysql_client.is_connected
			is_open: is_open
			not_off: not off
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= column_count
		local
			c_ptr: POINTER
			c_length: INTEGER
		do
			create c_ptr.default_create
			c_length := c_at_new ($p_result, $p_row, a_pos-1, $c_ptr)
			create Result.make (c_length+1)
			Result.from_c_substring (c_ptr, 1, c_length)
--			Result := c_at ($p_result, $p_row, a_pos-1)
		end

	data_as_table: HASH_TABLE [STRING, STRING]
			-- The string value at column index `a_pos'
		require
			mysql_client_is_connected: mysql_client.is_connected
			is_open: is_open
			not_off: not off
		do
			create Result.make (column_count)
			Result.compare_objects
			across 1 |..| column_count as l_indexes loop
				Result.force (at (l_indexes.item), column_name_at (l_indexes.item))
			end
		end

	column_names: ARRAY [STRING]
			-- List of column names
		require
			mysql_client_is_connected: mysql_client.is_connected
			is_open: is_open
		do
			create Result.make_filled (Void, 1, column_count)
			across 1 |..| column_count as l_indexes loop
				Result.put (column_name_at (l_indexes.item), l_indexes.item)
			end
		end

	all_data: ARRAY [ARRAY [STRING]]
			-- All data in all rows
			-- The outer array represents rows, the inner array represents a single row.
		require
			mysql_client_is_connected: mysql_client.is_connected
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

feature -- Commands

	go_i_th (a_pos: INTEGER)
			-- Seek to row index `a_pos' in this query result set
		require
			is_open: is_open
			valid_position_lower: a_pos > 0
			valid_position_upper: a_pos <= column_count
		do
			c_seek ($p_result, a_pos-1)
			forth
		end

	start
			-- Seeks to the first row in this query result set
		do
			go_i_th (1)
		end

	forth
			-- Fetch the next row from this query result set
		require
			is_open: is_open
		do
			off := True
			if c_fetch_row ($p_result, $p_row) = 0 then
				off := False
			end
		end

	dispose
			-- Dispose of this result set
		do
			if is_open then
				c_free_result ($p_result)
			end
			is_open := False
		end

feature -- Access

	mysql_client: MYSQL_CLIENT
			-- MySQL client reference from which Current result is retrieved

feature{NONE} -- External

	p_result, p_row: POINTER
			-- Pointer to MYSQL_RES, MYSQL_ROW structures

	c_query (a_mysql, a_query: POINTER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_store_result (a_mysql, a_result: POINTER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_num_rows (a_result: POINTER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_num_fields (a_result: POINTER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_seek (a_result: POINTER; a_pos: INTEGER)
		external
			"C | %"eiffelmysql.h%""
		end

	c_column_at (a_result: POINTER; a_pos: INTEGER): STRING
		external
			"C | %"eiffelmysql.h%""
		end

	c_column_at_new (a_result: POINTER; a_pos: INTEGER; a_str: POINTER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_fetch_row (a_result, a_row: POINTER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

	c_free_result (a_result: POINTER)
		external
			"C | %"eiffelmysql.h%""
		end

	c_at (a_result, a_row: POINTER; a_pos: INTEGER): STRING
		external
			"C | %"eiffelmysql.h%""
		end

	c_at_new (a_result, a_row: POINTER; a_pos: INTEGER; a_str: POINTER): INTEGER
		external
			"C | %"eiffelmysql.h%""
		end

end
