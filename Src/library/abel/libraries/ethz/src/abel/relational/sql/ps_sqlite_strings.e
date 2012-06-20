note
	description: "Summary description for {PS_SQLITE_STRINGS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_SQLITE_STRINGS

inherit
	PS_GENERIC_LAYOUT_SQL_STRINGS
	redefine
		Show_tables,
		Auto_increment_keyword
	end

feature

	Auto_increment_keyword: STRING
		do
			Result:= " AUTOINCREMENT "
		end

	Show_tables: STRING = "SELECT name FROM sqlite_master WHERE type = 'table'"

end
