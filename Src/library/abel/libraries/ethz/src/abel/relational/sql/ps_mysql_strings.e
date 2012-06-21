note
	description: "Summary description for {PS_MYSQL_STRINGS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_MYSQL_STRINGS

inherit
	PS_GENERIC_LAYOUT_SQL_STRINGS


feature {PS_GENERIC_LAYOUT_KEY_MANAGER} -- Table creation

	Auto_increment_keyword: STRING
		do
			Result:= " AUTO_INCREMENT "
		end

	Create_value_table: STRING
		do
			Result:= "[
					CREATE TABLE ps_value (
					objectid INTEGER NOT NULL
					]"
					 + Auto_increment_keyword + ", " +
					"[
					attributeid INTEGER,
					runtimetype INTEGER,
					value VARCHAR(128),

					PRIMARY KEY (objectid, attributeid),
					FOREIGN KEY (attributeid) REFERENCES ps_attribute (attributeid) ON DELETE CASCADE,
					FOREIGN KEY (runtimetype) REFERENCES ps_class (classid) ON DELETE CASCADE
					)
			]"
		end


	Create_class_table: STRING
		do
			Result:= "[

				CREATE TABLE ps_class (
					classid INTEGER NOT NULL
						]"
						 + Auto_increment_keyword +
						"[
						PRIMARY KEY, 
					classname VARCHAR(64)
				)
			]"
		end

	Create_attribute_table: STRING
		do
			Result:= "[
				CREATE TABLE ps_attribute (
					attributeid INTEGER NOT NULL
						]"
						 + Auto_increment_keyword +
						"[
						PRIMARY KEY,
					name VARCHAR(128),
					class INTEGER,

					FOREIGN KEY (class) REFERENCES ps_class (classid) ON DELETE CASCADE
				)
			]"
		end


feature {PS_GENERIC_LAYOUT_KEY_MANAGER} -- Data modification - Key manager

	Insert_class_use_autoincrement (class_name:STRING):STRING
		do
			Result:="INSERT INTO ps_class (classname) VALUES ('" + class_name + "')"
		end

	Insert_attribute_use_autoincrement (attribute_name:STRING; class_key:INTEGER):STRING
		do
			Result:= "INSERT INTO ps_attribute (name, class) VALUES ('" + attribute_name + "', " + class_key.out +  ")"
		end


feature {PS_GENERIC_LAYOUT_SQL_BACKEND} -- Data modification - Backend

	Insert_value_use_autoincrement (attribute_id, runtimetype:INTEGER;  value: STRING): STRING
		do
			Result:= "INSERT INTO ps_value (attributeid, runtimetype, value) VALUES (" + attribute_id.out + ", " + runtimetype.out + ", '" + value + "')"
		end


feature {PS_GENERIC_LAYOUT_SQL_BACKEND}

	For_update_appendix: STRING = " FOR UPDATE "


end
