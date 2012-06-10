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
					FOREIGN KEY (attributeid) REFERENCES ps_attribute (attributeid) ON DELETE CASCADE
					FOREIGN KEY (runtimetype) REFERECES ps_class (classid) ON DELETE CASCADE
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

	Query_class_table: STRING = "[
			SELECT classid, classname 
			FROM ps_class
		]"

	Query_attribute_table:STRING = "[
			SELECT attributeid, name, class
			FROM ps_attribute
		]"

	Query_values_from_class (class_id:INTEGER) : STRING
		do
			Result:= "[
				SELECT objectid, attributeid, runtimetype, value
				FROM ps_value
				WHERE objectid IN (
					SELECT v.objectid
					FROM ps_value v, ps_attribute a
					WHERE a.class = ]" + class_id + "[
				)
				ORDER BY objectid
			]"
		end

end
