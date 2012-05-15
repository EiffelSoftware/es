note
	description: "Objects of {PS_RELATION_SCOPE} represent a relational database table."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_RELATION_SCOPE

create
	make_with_table_name, make_with_class_name

feature {NONE} -- Initialization

	make_with_table_name (tab_name: STRING)
			-- Create a relation scope with `tab_name'.
		require
			tab_name_exists: not tab_name.is_empty
		do
			table_name := tab_name
			create column_value_pairs.make (20)
		end

	make_with_class_name (class_name: STRING)
			-- Create a relation scope having the same name and columns as `class_name'.
		do
			create column_value_pairs.make (20)
			table_name := class_name
			-- Get all the attributes from the class name and put them in the hash table.
		ensure
			--	attributes_consistent_with_columns: column_value_pairs.count = <number of attributes from class with name `class_name'>.
		end

feature -- Access

	table_name: STRING
			-- The associated table name.

feature -- Status report

feature -- Status setting

feature -- Element change

feature -- Removal

feature -- Transformation

feature -- Conversion

feature -- Basic operations

	associate_value_to_column (val: ANY; col_name: STRING)
			-- Associates a value to a table column.
		do
			column_value_pairs.extend (val, col_name)
		end

feature {NONE} -- Implementation

	column_value_pairs: HASH_TABLE [ANY, STRING]

invariant
	invariant_clause: True -- Your invariant here

end
