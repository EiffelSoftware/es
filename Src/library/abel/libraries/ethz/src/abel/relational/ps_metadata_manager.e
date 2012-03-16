note
	description: "Central manager for object metadata"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

	fixme: "Make storing and retrieving metadata from the database optional, and take that functionality out of get_metadata"

class
	PS_METADATA_MANAGER
inherit
	PS_EIFFELSTORE_EXPORT

create
	make

feature {PS_EIFFELSTORE_EXPORT}

	get_metadata (object: ANY): PS_METADATA
			-- Returns the metadata of the class if already known to the system.
			-- If metadata is unknown, it will generate the metadata through reflection, store
			-- this information into the database, and then return the result.
		local
			reflection: INTERNAL
			class_name: STRING
			i: INTEGER
			type: INTEGER
			type_name: STRING
			temp: PS_METADATA
		do
			create reflection
			class_name := reflection.class_name (object)
			if metadata_list.has (class_name) then
				Result := metadata_list [class_name].as_attached
			else
				create Result.make (class_name, false)
				metadata_list.put (Result, class_name)
				from
					i := 1
				until
					i > reflection.field_count (object)
				loop
					type := reflection.field_static_type_of_type (i, reflection.dynamic_type (object))
					type_name := reflection.class_name_of_type (type)
						-- TODO
						-- Expand this check statement, add some dummy values instead of always creating new one...
					if type_name.has_substring ("STRING") or type_name.has_substring ("INTEGER") then
						create temp.make (type_name, true)
						Result.add_attribute (reflection.field_name (i, object), temp)
					else
						-- call recursive function to first generate metadata of other type
					end
						--print (reflection.field_name (i, object) + reflection.field_count (object).out + i.out)
						-- TODO: inheritance...
					i := i + 1
				end
					-- insert this into database					
				connection.execute_query ("INSERT INTO ps_class (classname) VALUES ('" + Result.name + "')")
				print (connection.last_error_message)
				Result.set_class_id (connection.last_result.last_insert_id)
				from
					Result.attributes.start
				until
					Result.attributes.after
				loop
					connection.execute_query ("INSERT INTO ps_attribute (name, attributetype, class) VALUES ('" + Result.attributes.item + "', 0, " + Result.class_id.out + ") ") -- TODO attributetype
					Result.set_attribute_id (connection.last_result.last_insert_id, Result.attributes.item)
					Result.attributes.forth
				end
			end
		end



feature {NONE} -- Initialization

	make (a_connection: MYSQLI_CLIENT)
			-- Initialize `Current'
		do
			connection := a_connection
			create metadata_list.make (capacity)
			initialize
		end

	initialize
			-- This function fetches all metadata from the tables in the database.
		do
			-- check if scheme is present in database. if not, create it
			connection.execute_query ("SHOW tables")
			if connection.last_result.there_exists (agent are_metadata_tables_present) then
				-- load all metadata about classes and inheritance structure
				-- TODO
			else
					-- Create tables. Do not load anything.
				connection.execute_query (Class_table_sql)
				connection.execute_query (Inheritance_table_sql)
				connection.execute_query (Attributetype_table_sql)
				connection.execute_query (Attribute_table_sql)
				print (connection.last_error_message)
			end
		end


feature {NONE} -- Implementation

	metadata_list: HASH_TABLE [PS_METADATA, STRING]
	capacity: INTEGER = 100

	connection: MYSQLI_CLIENT

	are_metadata_tables_present (row: MYSQLI_ROW): BOOLEAN
			-- Are the tables used for storing metadata present in the database?
		do
			Result := row.at (1).as_string.is_case_insensitive_equal ("ps_class")
		end

feature {NONE} -- SQL strings

	Class_table_sql: STRING = "CREATE TABLE ps_class (classid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY, classname VARCHAR(64))"

	Inheritance_table_sql: STRING = "[
			
			CREATE TABLE ps_inheritance (
			superclass INTEGER, 
			subclass INTEGER, 
			
			PRIMARY KEY (superclass, subclass), 
			FOREIGN KEY (superclass) REFERENCES ps_class (classid) ON DELETE CASCADE,
			FOREIGN KEY (subclass) REFERENCES ps_class (classid) ON DELETE CASCADE
			 )
		]"

	Attributetype_table_sql: STRING = "CREATE TABLE ps_attributetype (attributetypeid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY, description VARCHAR(64))"

	Attribute_table_sql: STRING = "[
			CREATE TABLE ps_attribute (
			attributeid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
			name VARCHAR(128),
			attributetype INTEGER,
			class INTEGER,
			
			FOREIGN KEY (attributetype) REFERENCES ps_attributetype (attributetypeid) ON DELETE CASCADE,
			FOREIGN KEY (class) REFERENCES ps_class (classid) ON DELETE CASCADE
			)
		]"

end
