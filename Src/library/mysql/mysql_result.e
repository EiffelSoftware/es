note
	description: "MySQL Result Class (Interface to C Library)"
	author: "haroth@student.ethz.ch"
	date: "$Date$"
	revision: "$Revision$"

class
	MYSQL_RESULT

create
	make

feature{MYSQL_CLIENT}

	make (a_client: MYSQL_CLIENT; a_row: POINTER)
			-- Initializer
		do
			-- MYSQL_CLIENT
			mysql_client := a_client
			-- Datastructures for C
			p_row := a_row
			-- State
			is_open := False
		end

	execute_query (p_mysql: POINTER; a_query: STRING): BOOLEAN
			-- Executes an SQL query specified as a null-terminated string (mysql_query)
		require
			a_query /= Void
			mysql_client.is_connected
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
			Result := is_open
		end

feature

	is_open: BOOLEAN
			-- Whether this result set was freed (mysql_free_result)

	off: BOOLEAN
			-- Is there no more row?

	row_count: INTEGER
			-- Returns the number of rows in a result set (mysql_num_rows)
		require
			is_open
		do
			Result := c_num_rows ($p_result)
		end

	field_count: INTEGER
			-- Returns the number of columns in a result set (mysql_num_fields)
		require
			is_open
		do
			Result := c_num_fields ($p_result)
		end

	forth
		-- Fetches the next row from the result set (mysql_fetch_row)
		require
			is_open
		do
			off := True
			if c_fetch_row ($p_result, $p_row) = 0 then
				off := False
			end
		end

	at (pos: INTEGER): STRING
			-- Returns the value at pos
		require
			mysql_client.is_connected
			is_open
			not off
			pos > 0
			pos <= field_count
		do
			Result := c_at ($p_result, $p_row, pos)
		end

	free_result
			-- Frees memory used by a result set (mysql_free_result)
		do
			c_free_result ($p_result)
		end

feature -- Parents

	mysql_client: MYSQL_CLIENT

feature {NONE} -- External

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

end
