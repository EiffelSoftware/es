note
	description: "Wrapper for a row in a MySQL result."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_MYSQL_ROW
inherit
	PS_SQL_ROW_ABSTRACTION

create
	make

feature {PS_EIFFELSTORE_EXPORT}

	get_value (column_name: STRING): STRING
		-- Get the value in column `column_name'
		do
			Result:= internal_row.at_field (column_name).as_string_8
		end

	get_value_by_index (index:INTEGER):STRING
		-- Get the value at index `index'
		do
			Result:= internal_row.at (index).as_string_8
		end


feature {NONE} -- Initialization

	make (a_row: MYSQLI_ROW)
			-- Initialization for `Current'.
		do
			internal_row:= a_row
		end

	internal_row: MYSQLI_ROW
		-- The actual row that gets wrapped here

end
