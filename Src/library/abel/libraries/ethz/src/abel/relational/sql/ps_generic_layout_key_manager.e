note
	description: "Summary description for {PS_GENERIC_LAYOUT_KEY_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_GENERIC_LAYOUT_KEY_MANAGER

inherit
	PS_GENERIC_LAYOUT_SQL_STRINGS
	PS_EIFFELSTORE_EXPORT

create
	make

feature

	class_name_of_key (a_key: INTEGER):STRING
		do
			Result:= attach (class_key_to_name_map[a_key])
		end

	attribute_name_of_key (attribute_key: INTEGER):STRING
		do
		--	Result:= attach (attach (attribute_key_to_name_map[class_key]).item(attribute_key))
			Result:= attach (attribute_key_to_name_map[attribute_key])
		end

	key_of_class (class_name:STRING; active_connection: PS_SQL_CONNECTION_ABSTRACTION):INTEGER
		do
			if class_map.has (class_name) then
				Result:= class_map[class_name]
			else
				active_connection.execute_sql ("INSERT INTO ps_class (classname) VALUES ('" + class_name + "')")
				active_connection.execute_sql ("SELECT classid FROM ps_class WHERE classname = '" + class_name + "'")
				Result:= active_connection.last_result.item.get_value_by_index (1).to_integer
--				Result:= active_connection.last_insert_id
				class_map.extend (Result, class_name)
				class_key_to_name_map.extend (class_name, Result)

				attr_map.extend (create {HASH_TABLE[INTEGER, STRING]}.make (20), Result)
			end
		end


	key_of_attribute (attribute_name:STRING; class_id:INTEGER; active_connection: PS_SQL_CONNECTION_ABSTRACTION):INTEGER
		do
			if attach (attr_map[class_id]).has (attribute_name) then
				Result:= attach (attr_map[class_id]).item (attribute_name)
			else
				active_connection.execute_sql ("INSERT INTO ps_attribute (name, class) VALUES ('" + attribute_name + "', " + class_id.out +  ")")
				active_connection.execute_sql ("SELECT attributeid FROM ps_attribute WHERE name = '" + attribute_name + "' AND class = " +class_id.out)
				Result:= active_connection.last_result.item.get_value_by_index (1).to_integer
--				Result:= active_connection.last_insert_id
				add_attribute_key (attribute_name, Result, class_id)
			end
		end


feature {NONE} -- Implementation

	class_key_to_name_map: HASH_TABLE[STRING, INTEGER]

	attribute_key_to_name_map: HASH_TABLE[STRING, INTEGER]

	class_map: HASH_TABLE[INTEGER, STRING]

	attr_map: HASH_TABLE[HASH_TABLE[INTEGER, STRING], INTEGER]

	add_attribute_key (name:STRING; key, class_id: INTEGER)
		do
			if not attr_map.has (class_id) then
				attr_map.extend (create {HASH_TABLE[INTEGER, STRING]}.make (10), class_id)
			end
			attach (attr_map[class_id]).extend(key, name)

--			if not attribute_key_to_name_map.has (class_id) then
--				attribute_key_to_name_map.extend (create {HASH_TABLE[STRING, INTEGER]}.make (10), class_id)
--			end
--			attach (attribute_key_to_name_map[class_id]).extend (name, key)

			attribute_key_to_name_map.extend (name, key)

		end


feature {NONE} -- Initialization

	make (a_connection: PS_SQL_CONNECTION_ABSTRACTION)
			-- Initialization for `Current'.
		local
			all_tables: LINKED_LIST[STRING]
		do
			create class_map.make (20)
			create attr_map.make (20)
			create class_key_to_name_map.make(20)
			create attribute_key_to_name_map.make(20)


			-- Create all tables if they do not yet exist
			create all_tables.make

			a_connection.execute_sql ("SHOW TABLES")
			across a_connection as cursor loop
				all_tables.extend (cursor.item.get_value_by_index (1))
				print (all_tables.last)
			end

			if not all_tables.there_exists ( agent {STRING}.is_case_insensitive_equal ("ps_class")) then
				a_connection.execute_sql (Create_class_table)
			end
			if not all_tables.there_exists ( agent {STRING}.is_case_insensitive_equal  ("ps_attribute")) then
				a_connection.execute_sql (Create_attribute_table)
			end
			if not all_tables.there_exists ( agent {STRING}.is_case_insensitive_equal  ("ps_value")) then
				a_connection.execute_sql (Create_value_table)
			end

			-- Get the needed information from ps_class and ps_attribute table

			a_connection.execute_sql (Query_class_table)

			across a_connection as row_cursor loop
				class_map.extend (row_cursor.item.get_value ("classid").to_integer, row_cursor.item.get_value ("classname"))
			end

			a_connection.execute_sql (Query_attribute_table)

			across a_connection as row_cursor loop
				add_attribute_key (row_cursor.item.get_value ("name"), row_cursor.item.get_value ("attributeid").to_integer, row_cursor.item.get_value ("class").to_integer)
			end

		end
end
