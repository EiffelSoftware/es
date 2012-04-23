note
	description: "This class maps objects to a generic table layout structure."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_GENERIC_LAYOUT_STRATEGY

inherit
	PS_MAPPING_STRATEGY

inherit {NONE}
	REFACTORING_HELPER

create
	make

feature {PS_EIFFELSTORE_EXPORT} -- CRUD operations

	retrieve_an_object (query: PS_QUERY [ANY]; metadata: PS_METADATA; transaction: PS_TRANSACTION): detachable HASH_TABLE [STRING, STRING] --attribute name is the hash key
			-- Retrieves an object in a query. It will remember the query and return the next object that matches the criteria
			-- If not possible to compile to SQL completely (agents...), it will just do a "best effort" compile and might return some that don't fit.
			-- It will return void if there are no more objects.
			-- The function will also search for descendants of the class denoted in the generic argument of PS_QUERY (not ANY, the actual type...)
		local
			i: INTEGER
			fieldname_value_hash: HASH_TABLE [STRING, STRING]
		do
			create_values_table_if_nonexistent
			if query.backend_identifier = 0 then
				query.set_identifier (new_identifier)
				database.execute_query (sql_select (metadata.name))
				print (database.last_error_message)
					--print (database.last_error_message)
					--print (sql_select (metadata.name))
				query_to_mysqlresult_map.put (database.last_result.as_attached, query.backend_identifier)
				database.last_result.start
			end
			check attached query_to_mysqlresult_map [query.backend_identifier] as mysql_result then
				if mysql_result.after then
					Result := Void
				else
					from -- loop through metadata.attributes.count rows to retrieve the values of a single object (object id's are sorted...)
						create Result.make (metadata.attributes.count)
						i := 1
					until
						i > metadata.attributes.count
					loop
						Result.put (mysql_result.item.at_field ("value").as_string_8.as_attached, mysql_result.item.at_field ("field").as_string_8.as_attached)
							--print (mysql_result.item.at_field ("value").as_string_8.as_attached)
						mysql_result.forth
						i := i + 1
					end
				end
			end
		end

	insert (object: HASH_TABLE [STRING, STRING]; metadata: PS_METADATA; transaction: PS_TRANSACTION): INTEGER
			-- Inserts `object' into `database' and returns the primary key of the newly inserted object.
			-- In hashtable `object' everey referenced item needs to have the correct foreign key
		do
			create_values_table_if_nonexistent
				-- grab a new primary key for the object
			from
				metadata.attributes.start
				check attached object [metadata.attributes.item] as val then
					database.execute_query ("INSERT INTO ps_value (attributeid, value) VALUES ( " + metadata.get_attribute_id (metadata.attributes.item).out + ", '" + val + "')")
				end
				print (database.last_error_message)
				Result := database.last_result.last_insert_id
				metadata.attributes.forth
				-- insert all values with this correct primary key
			until
				metadata.attributes.after
			loop
				check attached object [metadata.attributes.item] as val then
					database.execute_query ("INSERT INTO ps_value VALUES (" + Result.out + ", " + metadata.get_attribute_id (metadata.attributes.item).out + ", '" + val + "')")
				end
				print (database.last_error_message)
				metadata.attributes.forth
			end
		end

	update (object: ARRAY [PS_PAIR [STRING, STRING]]; metadata: PS_METADATA; transaction: PS_TRANSACTION)
			-- Updates `object' in the database. `Object' is assumed to have the correct primary key, and the name/value pairs to be updated
		do
		end

	delete (object: ARRAY [PS_PAIR [STRING, STRING]]; metadata: PS_METADATA; transaction: PS_TRANSACTION)
			-- Delete `object', identified by the primary key in the hashtable, from the database
		do
		end

feature {NONE} -- Implementation

	create_values_table_if_nonexistent
			-- Create table ps_value in the database, in case it doesn't exist already
		do
			database.execute_query ("SHOW tables")
			if not database.last_result.there_exists (agent  (row: MYSQLI_ROW): BOOLEAN
				do
					Result := row.at (1).as_string.is_case_insensitive_equal ("ps_value")
				end) then
				database.execute_query (sql_create_table_value)
				print (database.last_error_message)
			end
		end

	sql_create_table_value: STRING = "[
					CREATE TABLE ps_value (
					objectid INTEGER NOT NULL AUTO_INCREMENT,
					attributeid INTEGER, 
					value VARCHAR(128),
			
					PRIMARY KEY (objectid, attributeid),		
					FOREIGN KEY (attributeid) REFERENCES ps_attribute (attributeid) ON DELETE CASCADE
					)
		]"

	sql_select (a_class: STRING): STRING
			-- The SQL command to get all objects of type `a_class'
		do
			fixme ("TODO: This should be a prepared statement")
			Result := "[
				SELECT objectid, value, a.name AS field
				FROM ps_value v, ps_attribute a, ps_class c
				WHERE v.attributeid = a.attributeid
					AND a.class = c.classid
					AND c.classname = '
			]"
			Result := Result + a_class + "' ORDER BY objectid"
		end


	query_to_mysqlresult_map: HASH_TABLE [MYSQLI_RESULT, INTEGER]
		-- Maps the query to a mysqli_result


	new_identifier: INTEGER
			-- Get a new identifier for a query
		do
			fixme ( "TODO: make this fault free...")
			Result := identifier_number
			identifier_number := identifier_number + 1
		end
	identifier_number: INTEGER


feature {NONE} -- Initialization

	make
			-- Initialize `Current'
		do
			identifier_number := 1
			create query_to_mysqlresult_map.make (100)
		end

end
