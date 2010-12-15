note
	description: "Importer for SSQL files"
	author: "haroth@student.ethz.ch"
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_DATABASE_IMPORTER

inherit
	SEMQ_DATABASE

create
	make

feature -- Basic operations

	execute
			-- Import files
		local
			file_searcher: EPA_FILE_SEARCHER
		do
			-- Initialize
			create queryables.make (config)
			queryables.load_empty
			create types.make (config)
			types.load_from_database
			create properties.make (config)
			properties.load_from_database

			-- Field names and MySQL Prepared Statements
			make_sem_field_names
			prepare_statements

			-- Walk directories
			create file_searcher.make_with_pattern (once "ssql")
			file_searcher.file_found_actions.extend (agent import_file (?, ?))
			file_searcher.set_is_search_recursive (true) -- CAREFUL
			file_searcher.search (config.mysql_file_directory)

			-- Cleanup
			queryables.close_mysql
			types.close_mysql
			properties.close_mysql
			close_mysql
		end

feature{NONE} -- Implementation

	queryables: SEMQ_DATABASE_QUERYABLES
	types: SEMQ_DATABASE_TYPES
	properties: SEMQ_DATABASE_PROPERTIES

	import_file (location, name: STRING)
			-- Import file with absolute path "location" and filename "name"
		require
			location /= Void
			name /= Void
		local
			uuid: STRING
			file: PLAIN_TEXT_FILE
			qry_id: INTEGER
		do
--			print ("SEMQ_DATABASE_IMPORTER.import_file: location = "+name+"%N")
			uuid := uuid_from_filename(location)
			qry_id := queryables.new_queryable(uuid) -- Reserve an ID (AUTO_INCREMENT)
			if qry_id > 0 then
				print (once "SEMQ_DATABASE_IMPORTER.import_file: qry_id = ")
				print (qry_id)
				print ('%N')
				from
					create file.make_open_read (location)
				until
					file.end_of_file
				loop
					file.readline
					if file.last_string.count > 0 then
						-- Fix carriage return
						if file.last_string.code (file.last_string.count) = 13 then
							file.last_string.remove_tail (1)
						end
						if file.last_string.starts_with (once "  property: ") or
							file.last_string.starts_with (once "  variable: ") then
							handle_property (qry_id, file.last_string)
						else
							handle_attribute (qry_id, file.last_string)
						end
					end
				end
				file.close
				-- Save attributes to database
				queryables.save_queryable(qry_id)
			end
		end

	uuid_from_filename (filename: STRING): STRING
			-- Extract UUID from filename
		do
			Result := filename.substring (filename.last_index_of ('_', filename.count) + 1, filename.count - 5)
		end

	handle_attribute (qry_id: INTEGER; a_line: STRING)
			-- Handle a line that contains an attribute
		local
			separator: INTEGER
		do
			if a_line.count > 0 then
				separator := a_line.index_of (':', 1)
				queryables.set_attribute (qry_id, a_line.substring (3, separator - 1),
					a_line.substring (separator + 2, a_line.count))
			end
		end

	handle_property (qry_id: INTEGER; a_line: STRING)
			-- Handle a line that contains a property binding
		local
			data, operands, operand_types: LIST [STRING]
			i, operands_count, prop_id, type_id: INTEGER
			stmt_insert_binding: MYSQL_STMT
		do
			data := a_line.split ('%T')
			operands := data.at (5).split (';')
			operand_types := data.at (6).split (';')
			operands_count := data.at (4).to_integer

			if operands_count > 0 and operands_count < 10 then
				stmt_insert_binding := stmt_insert_bindings.at (operands_count)

				stmt_insert_binding.set_int (1, properties.get_id (data.at (2)).to_integer) -- `prop_id` int(10) unsigned NOT NULL
				stmt_insert_binding.set_int (2, qry_id) -- `qry_id` int(10) unsigned NOT NULL

				from
					i := 1
				until
					i > operands_count
				loop
					stmt_insert_binding.set_int (1+i*2, operands.at (i).to_integer) -- `varX` smallint(5) unsigned NOT NULL
					stmt_insert_binding.set_int (2+i*2, types.get_id (operand_types.at (i)))  -- `typeX` int(10) unsigned NOT NULL
					i := i + 1
				end

				i := ( operands_count + 1 ) * 2

				stmt_insert_binding.set_int (i + 1, data.at (8).to_integer) -- `value` int(11) NOT NULL
				stmt_insert_binding.set_int (i + 2, data.at (9).to_integer) -- `equal_value` int(11) NOT NULL
				stmt_insert_binding.set_int (i + 3, data.at (10).to_integer) -- `boost` double unsigned NOT NULL
				stmt_insert_binding.set_int (i + 4, sem_field_names.property_types.at (data.at (3))) -- `prop_kind` int(5) unsigned NOT NULL
				stmt_insert_binding.set_int (i + 5, data.at (7).to_integer) -- `value_type_kind` tinyint(3) unsigned NOT NULL
				stmt_insert_binding.set_int (i + 6, data.at (11).to_integer) -- `position` int(10) unsigned
				stmt_insert_binding.set_string (i + 7, data.at (5)) -- `vars` varchar(256) NOT NULL

				stmt_insert_binding.execute
			end
		end

feature{SEMQ_DATABASE} -- MySQL Client

	cleanup_mysql
			-- Close statements
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > 9
			loop
				stmt_insert_bindings.at (i).close
				i := i + 1
			end
		end

feature{NONE} -- Prepared Statements

	prepare_statements
			-- Prepare statements
		do
			open_mysql
			create stmt_insert_bindings.make_filled (Void, 1, 9)
			mysql.prepare_statement (once "INSERT INTO `semantic_search`.`PropertyBindings1` VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")
			stmt_insert_bindings.put (mysql.last_statement, 1)
			mysql.prepare_statement (once "INSERT INTO `semantic_search`.`PropertyBindings2` VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")
			stmt_insert_bindings.put (mysql.last_statement, 2)
			mysql.prepare_statement (once "INSERT INTO `semantic_search`.`PropertyBindings3` VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")
			stmt_insert_bindings.put (mysql.last_statement, 3)
			mysql.prepare_statement (once "INSERT INTO `semantic_search`.`PropertyBindings4` VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")
			stmt_insert_bindings.put (mysql.last_statement, 4)
			mysql.prepare_statement (once "INSERT INTO `semantic_search`.`PropertyBindings5` VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")
			stmt_insert_bindings.put (mysql.last_statement, 5)
			mysql.prepare_statement (once "INSERT INTO `semantic_search`.`PropertyBindings6` VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")
			stmt_insert_bindings.put (mysql.last_statement, 6)
			mysql.prepare_statement (once "INSERT INTO `semantic_search`.`PropertyBindings7` VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")
			stmt_insert_bindings.put (mysql.last_statement, 7)
			mysql.prepare_statement (once "INSERT INTO `semantic_search`.`PropertyBindings8` VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")
			stmt_insert_bindings.put (mysql.last_statement, 8)
			mysql.prepare_statement (once "INSERT INTO `semantic_search`.`PropertyBindings9` VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")
			stmt_insert_bindings.put (mysql.last_statement, 9)
		end

	stmt_insert_bindings: ARRAY [MYSQL_STMT]

end
