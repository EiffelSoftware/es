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
			if attached values.item (name_to_index_map[column_name]) as val then
				Result:= val
			else
				Result:= ""
			end
		end


	get_value_by_index (index:INTEGER):STRING
		-- Get the value at index `index'
		do
			if attached values.item (index.as_natural_32) as val then
				Result:= val
			else
				Result:= ""
			end
		end


feature {NONE} -- Initialization

	make (sqlite_row: SQLITE_RESULT_ROW)
			-- Initialization for `Current'.
		local
			i:NATURAL
		do
			internal_row:= sqlite_row
			create name_to_index_map.make (sqlite_row.count.as_integer_32 * 2)
			create values.make (sqlite_row.count.as_integer_32 * 2)
			from i:= 1
			until i> sqlite_row.count
			loop
				--print (sqlite_row.string_value (i))
				--print (sqlite_row.column_name (i))
	--			print ( sqlite_row.column_name (i) + "%N")
				name_to_index_map.extend (i, sqlite_row.column_name (i))
				values.extend (sqlite_row.string_value (i), i)
--				check false end
				i:= i+1
			end
		end


	values:HASH_TABLE[STRING, NATURAL]


	internal_row: SQLITE_RESULT_ROW
		-- Actually, don't store the internal row - it gets deleted in the background...

	name_to_index_map: HASH_TABLE[NATURAL, STRING]

end
