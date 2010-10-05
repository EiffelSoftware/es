note
	description: "Constants for semantic search"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_CONSTANTS

feature -- Queryable type names

	transition_field_value: STRING = "transition"

	snippet_field_value: STRING = "snippet"

	object_field_value: STRING = "object"

feature -- Type names

	string_field_type: INTEGER = 1

	boolean_field_type: INTEGER = 2

	integer_field_type: INTEGER = 3

	string_field_name: STRING = "STRING"

	boolean_field_name: STRING = "BOOLEAN"

	integer_field_name: STRING = "INTEGER"

	field_type_name (a_type: INTEGER): STRING
			-- Name of the field with `a_type'
		do
			if a_type = string_field_type then
				Result := string_field_name
			elseif a_type = boolean_field_type then
				Result := boolean_field_name
			elseif a_type = integer_field_type then
				Result := integer_field_name
			end
		end

	field_type_from_name (a_name: STRING): INTEGER
			-- Field type from `a_name'
		do
			Result := field_name_table.item (a_name)
		end

	field_name_table: HASH_TABLE [INTEGER, STRING]
			-- Table from field name to field type
		once
			create Result.make (3)
			Result.force (integer_field_type, integer_field_name)
			Result.force (boolean_field_type, boolean_field_name)
			Result.force (string_field_type, string_field_name)
		end

feature -- Default boost

	default_boost_value: DOUBLE = 1.0

end

