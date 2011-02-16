note
	description: "Class to build a table in Eiffel style from mysql results"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MYSQL_RESULT_BUILDER [G -> TUPLE create default_create end]

feature -- Basic operations

	table (a_sql_table: MYSQL_RESULT): ARRAY [G]
			-- Table from `a_sql_table'. Each item in the result represents a row in the
			-- original `a_sql_table'. The order of rows in `a_sql_table' is preserved in Result.
		local
			l_row: G
			l_columns: INTEGER
			i: INTEGER
			l_data: STRING
			l_row_index: INTEGER
		do
			create Result.make (1, a_sql_table.row_count)
			l_columns := a_sql_table.field_count
			from
				l_row_index := 1
				a_sql_table.start
			until
				a_sql_table.off
			loop
				create l_row
				from
					i := 1
				until
					i > l_columns
				loop
					l_data := a_sql_table.at (i)
					if l_data ~ null_string then
						l_row.put (Void, i)
					elseif l_data.is_integer then
						l_row.put (l_data.to_integer, i)
					elseif l_data.is_double then
						l_row.put (l_data.to_double, i)
					else
						l_row.put (l_data, i)
					end
					i := i + 1
				end
				Result.put (l_row, l_row_index)
				a_sql_table.forth
				l_row_index := l_row_index + 1
			end
		end

feature{NONE} -- Implementation

	null_string: STRING = "NULL"
			-- Null string

end
