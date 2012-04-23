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

	is_criterion_fitting_strategy (criterium: PS_CRITERION; strategy: PS_REPOSITORY): BOOLEAN
			-- Is `criterium' fitting `strategy'?
		do
		--	if attached {PS_SQL_CRITERION} criterium and attached {PS_RDB_REPOSITORY} strategy then
		--		Result := True
		--	end
		--	if attached {PS_AGENT_CRITERION} criterium and attached {PS_IN_MEMORY_REPOSITORY_OLD} strategy then
		--		Result := True
		--	end
		end

	are_criteria_fitting_strategy (criteria: LIST [PS_CRITERION]; strategy: PS_REPOSITORY): BOOLEAN
			-- Are all `criteria' fitting `strategy'?
		do
			Result := across criteria as crit all is_criterion_fitting_strategy (crit.item, strategy) end
		end

end
