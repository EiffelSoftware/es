note
	description: "Objects of this class represent mappings of one column of a relational table to one attribute of a class."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_COLUMN_TO_ATTRIBUTE_MAP

create
	make

feature {NONE} -- Initialization

	make (a_column_name, a_column_type, a_attribute_name: STRING; a_data_map: PS_ONE_TO_ONE_MAPPING)
			-- Initialize `Current' with a column name, an attribute name and a data map.
		require
			a_column_name_exists: not a_column_name.is_empty
			a_column_type_exists: not a_column_type.is_empty
			a_attribute_name_exists: not a_attribute_name.is_empty
		do
			column_name := a_column_name
			column_type := a_column_type
			attribute_name := a_attribute_name
			data_mapper := a_data_map
		ensure
			column_name_set: column_name = a_column_name
			column_type_set: column_type = a_column_type
			attribute_name_set: attribute_name = a_attribute_name
			data_mapper_set: data_mapper = a_data_map
		end

feature -- Access

	column_name: STRING
			-- The column name associated to `attribute_name'.

	attribute_name: STRING
			-- The `attribute_name' associated to `column_name'.

	column_type: STRING
			-- The column type.

	data_mapper: PS_ONE_TO_ONE_MAPPING
			-- The associated data mapper.

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
