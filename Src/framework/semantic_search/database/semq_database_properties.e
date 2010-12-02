note
	description: "Tracks properties"
	author: "haroth@student.ethz.ch"
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_DATABASE_PROPERTIES

inherit
	SEMQ_DATABASE

create
	make

feature -- Initialization

	load_empty
			-- Don't load any properties
		do
			create properties.make (500)

			prepare_statements
		end

	load_from_database
			-- Loads all properties from database
		local
			i, prop_id: INTEGER
			prop: STRING
		do
			prepare_statements

			mysql.execute_query (once "SELECT `prop_id`, `text` FROM `semantic_search`.`Properties`")
			if mysql.last_result.row_count > 0 then
				create properties.make (mysql.last_result.row_count)
				from
					mysql.last_result.forth
				until
					mysql.last_result.off
				loop
					prop_id := mysql.last_result.at (0).to_integer
					prop := mysql.last_result.at (1)
					properties.put (prop_id, prop)
					mysql.last_result.forth
				end
			else
				create properties.make (1000)
			end
			mysql.last_result.free_result
		end

feature -- Basic operations

	get_id (a_property: STRING): INTEGER
			-- Returns ID for a property (insert if not in database yet)
		require
			properties /= Void
		do
			if properties.has (a_property) then
				Result := properties.at (a_property)
			else
				-- Double check (cache might be outdated)
--				stmt_find_property.set_string (0, a_property)
--				stmt_find_property.execute
--				if stmt_find_property.num_rows > 0 then
--					stmt_find_property.forth
--					Result := stmt_find_property.int_at (0)
--				else
					stmt_insert_property.set_string (0, a_property)
					stmt_insert_property.execute
					Result := stmt_insert_property.last_insert_id
--				end
				properties.put (Result, a_property)
			end
		end

feature -- Access

	properties: HASH_TABLE [INTEGER, STRING]
			-- Stores IDs of already seen properties (cache)

feature{SEMQ_DATABASE} -- MySQL Client

	cleanup_mysql
			-- Close statements
		do
			stmt_find_property.close
			stmt_insert_property.close
		end

feature{NONE} -- Prepared Statements

	prepare_statements
			-- Prepare statements
		do
			open_mysql
			mysql.prepare_statement (once "SELECT `prop_id` FROM `semantic_search`.`Properties` WHERE `text` = ?")
			stmt_find_property := mysql.last_statement
			mysql.prepare_statement (once "INSERT INTO `semantic_search`.`Properties` VALUES (NULL, ?)")
			stmt_insert_property := mysql.last_statement
		end

	stmt_find_property: MYSQL_STMT
	stmt_insert_property: MYSQL_STMT

end
