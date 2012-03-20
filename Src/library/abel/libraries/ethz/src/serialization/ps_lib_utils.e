note
	description: "Framework configuration values."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_LIB_UTILS

feature -- Serialization

	Default_dimension: INTEGER = 100
			-- Default dimension of data structures for retrieving multiple objects.

	Default_file_name: STRING = "ser_file.ser"
			-- Default file name used when a file name is not provided.

feature -- SQL operators

	Greater_than: STRING = " > "

	Less_than: STRING = " < "

	Greater_equal_than: STRING = " >= "

	Less_equal_than: STRING = " <= "

	Equals_to: STRING = " = "

feature -- MySQL

	Default_host: STRING = "127.0.0.1"
			-- Default host for MySQL.

	Default_user: STRING = "root"
			-- Default user for MySQL.

	Default_password: STRING = "pollo"
			-- Default password for MySQL.

	Default_port: INTEGER_32 = 3306
			-- Default port for MySQL.	

	Default_database: STRING = "test"
			-- Default database for MySQL.

feature -- Utilities


end
