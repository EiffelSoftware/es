note
	description: "Tracks types"
	author: "haroth@student.ethz.ch"
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_DATABASE_TYPES

inherit
	SEMQ_DATABASE

create
	make

feature -- Initialization

	load_empty
			-- Don't load any types
		do
			create types.make (100)

			make_type_conformance_calc
			type_conformance_calc.type_added_actions.extend (agent add_type (?))
			type_conformance_calc.conformance_added_actions.extend (agent add_conformance (?, ?))

			prepare_statements
		end

	load_from_database
			-- Loads all types from database
		local
			type_id: INTEGER
			type: STRING
		do
			prepare_statements

			make_type_conformance_calc

			mysql.execute_query (once "SELECT `type_id`, `type_name` FROM `semantic_search`.`Types`")
			if mysql.last_result.row_count > 0 then
				create types.make (mysql.last_result.row_count)
				from
					mysql.last_result.forth
				until
					mysql.last_result.off
				loop
					type_id := mysql.last_result.at (0).to_integer
					type := mysql.last_result.at (1)
					types.put (type_id, type)
					-- Conformance
					type_conformance_calc.add_type (create {SQL_TYPE}.make_with_type_name (type, type_id))
					mysql.last_result.forth
				end
			else
				create types.make (100)
			end
			mysql.last_result.free_result

			-- Only for new types
			type_conformance_calc.type_added_actions.extend (agent add_type (?))
			type_conformance_calc.conformance_added_actions.extend (agent add_conformance (?, ?))
		end

feature -- Basic operations

	get_id (a_type: STRING): INTEGER
			-- Returns ID for a type (insert if not in database yet)
		require
			types /= Void
		local
			is_new: BOOLEAN
		do
			is_new := FALSE
			if types.has (a_type) then
				Result := types.at (a_type)
			else
				-- Double check (cache might be outdated)
--				stmt_find_type.set_string (0, a_type)
--				stmt_find_type.execute
--				if stmt_find_type.num_rows > 0 then
--					stmt_find_type.forth
--					Result := stmt_find_type.int_at (0)
--				else
					is_new := True
					stmt_insert_type.set_string (0, a_type)
					stmt_insert_type.execute
					Result := stmt_insert_type.last_insert_id
--				end
				types.put (Result, a_type)
				-- Conformance
				if is_new then
					type_conformance_calc.add_type (create {SQL_TYPE}.make_with_type_name (a_type, Result))
				end
			end
		end

	add_type (a_type: SQL_TYPE)
		local
			type_id: INTEGER
		do
			type_id := get_id (a_type.name)
		end

	add_conformance (a_conformant_type, a_type: SQL_TYPE)
		local
			conf_type_id, type_id: INTEGER
		do
			conf_type_id := get_id (a_conformant_type.name)
			type_id := get_id (a_type.name)
			stmt_insert_conformance.set_int (0, conf_type_id)
			stmt_insert_conformance.set_int (1, type_id)
			stmt_insert_conformance.execute
		end

feature -- Access

	types: HASH_TABLE [INTEGER, STRING]
			-- Stores IDs of already seen types (cache)

feature{SEMQ_DATABASE} -- MySQL Client

	cleanup_mysql
			-- Close statements
		do
			stmt_find_type.close
			stmt_insert_type.close
			stmt_insert_conformance.close
		end

feature{NONE} -- Prepared Statements

	prepare_statements
			-- Prepare statements
		do
			open_mysql
			mysql.prepare_statement (once "SELECT `type_id` FROM `semantic_search`.`Types` WHERE `type_name` = ?")
			stmt_find_type := mysql.last_statement
			mysql.prepare_statement (once "INSERT INTO `semantic_search`.`Types` VALUES (NULL, ?)")
			stmt_insert_type := mysql.last_statement
			mysql.prepare_statement (once "INSERT INTO `semantic_search`.`Conformances` VALUES (?, ?)")
			stmt_insert_conformance := mysql.last_statement
		end

	stmt_find_type: MYSQL_STMT
	stmt_insert_type: MYSQL_STMT
	stmt_insert_conformance: MYSQL_STMT

end
