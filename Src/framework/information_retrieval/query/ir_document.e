note
	description: "Class that represents a document used in information retrieval system"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IR_DOCUMENT

inherit
	EPA_HASH_SET [IR_FIELD]
		redefine
			make
		end

	IR_SHARED_EQUALITY_TESTERS
		undefine
			copy,
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (n: INTEGER)
			-- Create an empty container and allocate
			-- memory space for at least `n' items.
		do
			Precursor (n)
			set_equality_tester (ir_field_equality_tester)
		end

feature -- Access

	table_by_name: HASH_TABLE [LINKED_LIST [IR_FIELD], STRING]
			-- Table from field name to fields with that particular name
			-- Key is field name, value is a list of fields with the same name.
			-- Note: Create a new table each time when this query is called.
		local
			l_cursor: like new_cursor
			l_field: IR_FIELD
			l_field_name: STRING
			l_fields: LINKED_LIST [IR_FIELD]
		do
			create Result.make (count)
			Result.compare_objects

			from
				l_cursor := new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_field := l_cursor.item
				l_field_name := l_field.name
				Result.search (l_field_name)
				if Result.found then
					l_fields := Result.found_item
				else
					create l_fields.make
					Result.put (l_fields, l_field_name)
				end
				l_fields.extend (l_field)
				l_cursor.forth
			end
		end

end
