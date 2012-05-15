note
	description: "{PS_ONE_TO_ONE_MAPPING} objects provide a mapping from one object to one table and vice-versa."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_ONE_TO_ONE_MAPPING

--inherit

--	PS_MAPPING

create
	make

feature {NONE} --Creation

	make (a_class_name, a_table_name: STRING)
			-- Initialize `Current' with a class name and a table name.
		require
			class_name_exists: not a_class_name.is_empty
			table_name_exists: not a_table_name.is_empty
		do
			domain_class_name := a_class_name
			table_name := a_table_name
			create {LINKED_LIST [PS_COLUMN_TO_ATTRIBUTE_MAP]} column_maps.make
		ensure
			domain_class_name_set: domain_class_name = a_class_name
			table_name_set: table_name = a_table_name
		end

feature -- Access

	domain_class_name: STRING
			-- The name of the domain class involved in the mapping.

	table_name: STRING
			-- The name of the database table involved in the mapping.

	column_maps: LIST [PS_COLUMN_TO_ATTRIBUTE_MAP]
			-- A collection of column maps mapping table columns to attributes.

feature -- Basic Operations

	associate_column_to_attribute (a_column_name, a_column_type, a_attribute_name: STRING_8)
			-- Associate `a_column_name' having `a_column_type' with `a_attribute_name'.
		local
			l_column_map: PS_COLUMN_TO_ATTRIBUTE_MAP
		do
			create l_column_map.make (a_column_name, a_column_type, a_attribute_name, Current)
			column_maps.extend (l_column_map)
		end

end
