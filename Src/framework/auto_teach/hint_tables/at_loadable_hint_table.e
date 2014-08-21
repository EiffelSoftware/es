note
	description: "A hint table supporting loading from file."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_LOADABLE_HINT_TABLE

inherit
	AT_HINT_TABLE

	AT_COMMON

create
	make_from_file_path

feature {NONE} -- Initialization

	make_from_file_path (a_path: STRING)
			-- Initialize `Current', loading its content from the specified file.
		require
			file_exists: hint_tables.file_exists (a_path)
		local
			l_file: PLAIN_TEXT_FILE
			l_words: LIST [STRING]
			i: INTEGER
			l_content: BOOLEAN
			l_block_type: AT_BLOCK_TYPE
			l_exception: DEVELOPER_EXCEPTION
			l_table: like table -- and like content_table
			l_table_row: ARRAY [AT_TRI_STATE_BOOLEAN]
			l_description: STRING
			l_tri_state: AT_TRI_STATE_BOOLEAN
		do
			create table.make (suggested_tables_initial_size)
			create content_table.make (suggested_tables_initial_size)

			create l_file.make_open_read (a_path)

				-- This loop is where I *really really* miss the 'continue' and 'break' instructions.
			from
				l_file.start
				advance_line (l_file)
			until
				not attached last_file_line or attached l_exception
			loop
				l_content := False

				check attached last_file_line end
				if attached last_file_line as l_line then
					l_words := broken_into_words (last_file_line)
					l_words.start
				else
					l_words := broken_into_words ("")
					l_words.start
				end

				if l_words.item.as_lower.same_string ("content") then
					l_content := True
					l_words.remove
				end

				if enum_block_type.is_valid_value_name (l_words.first.as_lower) then
					create l_block_type.make_with_value_name (l_words.first.as_lower)
					l_words.remove
				else
					create l_exception
					l_exception.set_description (at_strings.cht_invalid_block_type_name (file_line_number, l_words.first))
				end

				if l_block_type.initialized then
					if l_words.is_empty then
						create l_exception
						l_exception.set_description (at_strings.cht_empty_row (file_line_number))
					elseif l_content and then not enum_block_type.is_complex_block_type (l_block_type) then
						create l_exception
						l_exception.set_description (at_strings.cht_atomic_block_in_content_visibility_table (file_line_number, l_block_type.value_name))
					else
							-- Select the table to insert the line into.
						l_table := (if l_content then content_table else table end)

						if l_table.has_key (l_block_type) then
							create l_exception
							l_exception.set_description (at_strings.cht_duplicate_entry (file_line_number, l_block_type.value_name))
						end

						create l_table_row.make_filled (Tri_undefined, 1, l_words.count)
						from
							i := 1
							l_words.start
						until
							i > l_words.count or attached l_exception
						loop
							if l_table_row [i].is_valid_string_value (l_words.item) then
								l_tri_state.from_string (l_words.item)
								l_table_row [i] := l_tri_state
							else
								create l_exception
								l_exception.set_description (at_strings.cht_value_parse_error (file_line_number, l_words.item, "tri-state boolean"))
							end
							i := i + 1
							l_words.forth
						end
						l_table [l_block_type] := l_table_row
					end
				end

				advance_line (l_file)
			end

			if attached l_exception then
				l_exception.raise
			end
		end

		last_file_line: detachable STRING
				-- The last meaningful line read from the text file.

		file_line_number: INTEGER
				-- The number of the last read line in the text file.

		advance_line (a_file: PLAIN_TEXT_FILE)
				-- Advance to the next meaningful line in `a_file',
				-- skipping blank and comment lines.
			do
				from
					last_file_line := Void
				until
					a_file.after or attached last_file_line
				loop
					a_file.read_line
					file_line_number := file_line_number + 1

					check attached a_file.last_string end
					if attached a_file.last_string as l_line then
						l_line.adjust
						if not l_line.is_empty and then not l_line.starts_with_general ("#") then
							last_file_line := l_line
						end
					end
				end
			end

end
