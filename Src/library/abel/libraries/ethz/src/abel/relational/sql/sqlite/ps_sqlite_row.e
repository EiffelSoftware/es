note
	description: "Wrapper for a row in a SQLite result."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_SQLITE_ROW

inherit
	PS_SQL_ROW_ABSTRACTION

create
	make

feature {PS_EIFFELSTORE_EXPORT}

	get_value (column_name: STRING): STRING
		-- Get the value in column `column_name'
		do
			Result:= internal_row.string_value (name_to_index_map[column_name])
		end


	get_value_by_index (index:INTEGER):STRING
		-- Get the value at index `index'
		do
			Result:= internal_row.string_value (index.as_natural_32)
		end


feature {NONE} -- Initialization

	make (sqlite_row: SQLITE_RESULT_ROW)
			-- Initialization for `Current'.
		local
			i:NATURAL
		do
			internal_row:= sqlite_row
			create name_to_index_map.make (sqlite_row.count.as_integer_32 * 2)
			from i:= 1
			until i< sqlite_row.count
			loop
				name_to_index_map.extend (i, sqlite_row.column_name (i))
			end
		end

	internal_row: SQLITE_RESULT_ROW

	name_to_index_map: HASH_TABLE[NATURAL, STRING]

end
