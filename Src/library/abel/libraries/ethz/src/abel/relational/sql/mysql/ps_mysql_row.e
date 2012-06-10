note
	description: "Summary description for {PS_MYSQL_ROW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_MYSQL_ROW

inherit
	PS_SQL_ROW_ABSTRACTION

create
	make


feature

	get_value (table_header: STRING): STRING
		do
			Result:= internal_row.at_field (table_header).as_string_8
		end



feature {NONE} -- Initialization

	make (a_row: MYSQLI_ROW)
			-- Initialization for `Current'.
		do
			internal_row:= a_row
		end

	internal_row: MYSQLI_ROW

end
