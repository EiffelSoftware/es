note
	description: "Class to build a table in Eiffel style from mysql results"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MYSQL_RESULT_BUILDER [G -> TUPLE create default_create end]

inherit
	MYSQL_CONSTANTS

feature -- Basic operations

	table_from_result (a_sql_result: MYSQL_RESULT): ARRAYED_LIST [G]
			-- Table from `a_sql_result'. Each item in the result represents a row in the
			-- original `a_sql_result'. The order of rows in `a_sql_table' is preserved in Result.
			-- Limitation: A NULL value will appear as the default value of the column's type.
			-- For example, a NULL integer will appear at 0 (the default value of integer type), so
			-- you cannot distinguish between a NULL value and a default value.
		local
			l_row: G
			l_columns: INTEGER
			i: INTEGER
			l_data: STRING

			l_row_data: ARRAY [STRING]
		do
			create Result.make (a_sql_result.row_count)
			l_columns := a_sql_result.column_count

			from
				a_sql_result.start
			until
				a_sql_result.off
			loop
				create l_row
				from
					i := 1
				until
					i > l_columns
				loop
					l_data := a_sql_result.at (i)
					if l_data ~ mysql_null_string then
						l_row.put (Void, i)
					elseif l_data.is_integer then
						l_row.put_integer (l_data.to_integer, i)
					elseif l_data.is_double then
						l_row.put_double (l_data.to_double, i)
					else
						l_row.put_reference (l_data, i)
					end
					i := i + 1
				end
				Result.extend (l_row)
				a_sql_result.forth
			end
		end

	trable_from_prepared_statement (a_statement: MYSQL_PREPARED_STATEMENT): ARRAYED_LIST [G]
			-- Table from `a_statement'. Each item in the result represents a row in the
			-- original `a_statement'. The order of rows in `a_sql_table' is preserved in Result.
			-- Limitation: A NULL value will appear as the default value of the column's type.
			-- For example, a NULL integer will appear at 0 (the default value of integer type), so
			-- you cannot distinguish between a NULL value and a default value.						
		require
			a_statement.is_executed
		local
			l_row: G
			i, c: INTEGER
			l_columns: INTEGER
		do
			create Result.make (a_statement.row_count)
			l_columns := a_statement.column_count
			from
				i := 1
				a_statement.start
			until
				a_statement.off
			loop
				create l_row
				from
					c := 1
				until
					c > l_columns
				loop
					if a_statement.is_integer_at (c) then
						l_row.put_integer (a_statement.integer_at (c), c)
					elseif a_statement.is_double_at (c) then
						l_row.put_double (a_statement.double_at (c), c)
					elseif a_statement.is_string_at (c) then
						l_row.put_reference (a_statement.string_at (c), c)
					end
					c := c + 1
				end
				Result.extend (l_row)
				a_statement.forth
				i := i + 1
			end
		end

end
