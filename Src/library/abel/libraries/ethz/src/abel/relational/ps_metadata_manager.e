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
	make, make_new

feature {PS_EIFFELSTORE_EXPORT}

	create_metadata_from_type (a_type: TYPE[detachable ANY]): PS_TYPE_METADATA
		do
			if metadata_cache.has (a_type.type_id) then
				Result:= attach (metadata_cache[a_type.type_id])
			else
				create Result.make(a_type, Current)
				metadata_cache.extend (Result, a_type.type_id)
				Result.initialize
			end
		end

	create_metadata_from_object (object: ANY): PS_TYPE_METADATA
			-- Returns the metadata of the class if already known to the system.
			-- If metadata is unknown, it will generate the metadata through reflection, store
			-- this information into the database, and then return the result.
		do
			Result:= create_metadata_from_type (object.generating_type)
		end



feature {NONE} -- Initialization

	make (a_connection: MYSQLI_CLIENT)
			-- Initialize `Current'
		do
--			connection := a_connection
			create metadata_cache.make (capacity)
			--initialize
		end

	make_new
		do
			create metadata_cache.make (capacity)
		end

--	initialize
			-- This function fetches all metadata from the tables in the database.
--		do
--			-- check if scheme is present in database. if not, create it
--			connection.execute_query ("SHOW tables")
--			if connection.last_result.there_exists (agent are_metadata_tables_present) then
--				-- load all metadata about classes and inheritance structure
--				-- TODO
--			else
--					-- Create tables. Do not load anything.
--				connection.execute_query (Class_table_sql)
--				connection.execute_query (Inheritance_table_sql)
--				connection.execute_query (Attributetype_table_sql)
--				connection.execute_query (Attribute_table_sql)
--				print (connection.last_error_message)
--			end
--		end


feature {NONE} -- Implementation

	metadata_cache: HASH_TABLE[PS_TYPE_METADATA, INTEGER]
	capacity: INTEGER = 100

--	connection: MYSQLI_CLIENT

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
