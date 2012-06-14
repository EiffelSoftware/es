note
	description: "Summary description for {PS_GENERIC_LAYOUT_SQL_STRINGS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_GENERIC_LAYOUT_SQL_STRINGS

feature {PS_EIFFELSTORE_EXPORT} -- Table creation


	Create_value_table: STRING = "[
					CREATE TABLE ps_value (
					objectid INTEGER NOT NULL AUTO_INCREMENT,
					attributeid INTEGER,
					runtimetype INTEGER,
					value VARCHAR(128),

					PRIMARY KEY (objectid, attributeid),
					FOREIGN KEY (attributeid) REFERENCES ps_attribute (attributeid) ON DELETE CASCADE,
					FOREIGN KEY (runtimetype) REFERENCES ps_class (classid) ON DELETE CASCADE
					)
		]"


	Create_class_table: STRING = "[
		
			CREATE TABLE ps_class (
				classid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY, 
				classname VARCHAR(64)
			)

		]"

--	Create_inheritance_table: STRING = "[

--			CREATE TABLE ps_inheritance (
--				superclass INTEGER,
--				subclass INTEGER,
--				
--				PRIMARY KEY (superclass, subclass),
--				FOREIGN KEY (superclass) REFERENCES ps_class (classid) ON DELETE CASCADE,
--				FOREIGN KEY (subclass) REFERENCES ps_class (classid) ON DELETE CASCADE
--			 )
		--]"

--	Attributetype_table_sql: STRING = "[
--			CREATE TABLE ps_attributetype (
--				attributetypeid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
--				description VARCHAR(64)
--			)
--		]"

--	Attribute_table_sql: STRING = "[
--			CREATE TABLE ps_attribute (
--				attributeid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
--				name VARCHAR(128),
--				attributetype INTEGER,
--				class INTEGER,

--				FOREIGN KEY (attributetype) REFERENCES ps_attributetype (attributetypeid) ON DELETE CASCADE,
--				FOREIGN KEY (class) REFERENCES ps_class (classid) ON DELETE CASCADE
--			)
--		]"

	Create_attribute_table: STRING = "[
			CREATE TABLE ps_attribute (
				attributeid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
				name VARCHAR(128),
				class INTEGER,

				FOREIGN KEY (class) REFERENCES ps_class (classid) ON DELETE CASCADE
			)
		]"

feature {PS_EIFFELSTORE_EXPORT} -- Data querying

	Show_tables: STRING = "SHOW TABLES"

	Query_class_table: STRING = "[
			SELECT classid, classname 
			FROM ps_class
		]"

	Query_attribute_table:STRING = "[
			SELECT attributeid, name, class
			FROM ps_attribute
		]"

	Query_new_id_of_class (class_name:STRING):STRING
		do
			Result:= "SELECT classid FROM ps_class WHERE classname = '" + class_name + "'"
		end

	Query_new_id_of_attribute (attribute_name:STRING; class_key:INTEGER):STRING
		do
			Result:= "SELECT attributeid FROM ps_attribute WHERE name = '" + attribute_name + "' AND class = " +class_key.out
		end

	Query_values_from_class (class_id:INTEGER) : STRING
		do
			Result:= "[
				SELECT objectid, attributeid, runtimetype, value
				FROM ps_value
				WHERE objectid IN (
					SELECT v.objectid
					FROM ps_value v, ps_attribute a
					WHERE v.attributeid = a.attributeid AND a.class =
			]"
			Result := Result + class_id.out + " ) ORDER BY objectid "
		end


	Query_values_from_class_new (attributes: STRING) :STRING
		do
			Result:= "[
				SELECT objectid, attributeid, runtimetype, value
				FROM ps_value
				WHERE attributeid IN
			]"
			Result := Result + attributes  + " ORDER BY objectid "
		end


	convert_to_sql (primary_keys: LIST[INTEGER] ):STRING
		-- Convert `primary_keys' to a string with format `( 0, 1, 2 )'.
		-- If empty, the result is `( 0 )'.
		do
			Result:= " ( 0, "
			across primary_keys as key
			loop
				Result.append (key.item.out + ", ")
			end
			Result.remove_tail (2)
			Result.append (" )")
		end

feature {PS_EIFFELSTORE_EXPORT} -- Data modification

	Insert_class_use_autoincrement (class_name:STRING):STRING
		do
			Result:="INSERT INTO ps_class (classname) VALUES ('" + class_name + "')"
		end

	Insert_attribute_use_autoincrement (attribute_name:STRING; class_key:INTEGER):STRING
		do
			Result:= "INSERT INTO ps_attribute (name, class) VALUES ('" + attribute_name + "', " + class_key.out +  ")"
		end

feature {PS_EIFFELSTORE_EXPORT} -- Table and column names

	Class_table: STRING = "ps_class"

	Class_table_id_column: STRING = "classid"
	Class_table_name_column: STRING = "classname"


	Attribute_table: STRING = "ps_attribute"

	Attribute_table_id_column: STRING = "attributeid"
	Attribute_table_name_column: STRING = "name"
	Attribute_table_class_column: STRING = "class"


	Value_table: STRING = "ps_value"

end
