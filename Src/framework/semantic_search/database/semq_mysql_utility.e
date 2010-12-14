note
	description: "Utilities to interface with MySQL client library from within semantic search library"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_MYSQL_UTILITY

feature -- Access

	mysql_type_from_eiffel_type (a_type: TYPE_A): INTEGER
			-- MySQL type id from Eiffel type `a_type'
		do
			if a_type.is_boolean then
				Result := mysql_boolean_type
			elseif a_type.is_integer then
				Result := mysql_integer_type
			else
				Result := mysql_integer_type
			end
		end

feature -- Type constants

	mysql_boolean_type: INTEGER = 1
			-- Type ID for boolean type in MySQL

	mysql_integer_type: INTEGER = 2
			-- Type ID for integer type in MySQL

	mysql_string_type: INTEGER = 3
			-- Type ID for string in MySQL

	mysql_real_type: INTEGER = 4
			-- Type ID for real in MySQL

end
