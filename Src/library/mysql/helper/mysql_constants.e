note
	description: "Constants in MySQL library"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MYSQL_CONSTANTS

feature -- Access

	mysql_null_string: STRING = "NULL"
			-- String representation for NULL value
			-- Fixme: cannot distinguish between a string which
			-- contains the exact content "NULL".

end
