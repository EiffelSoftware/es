note
	description: "Visibility table for code block types. Each row represents a block type, each column a hint level."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AT_HINT_TABLE

inherit

	AT_COMMON

feature -- Access

	visibility_for (a_block_type: AT_BLOCK_TYPE; a_hint_level: INTEGER): TUPLE [visibility: AT_TRI_STATE_BOOLEAN; explicitly_defined: BOOLEAN]
			-- Access the visibility table, looking for the specified block type and hint level.
			-- If `a_block_type' is present in the table, but no value is defined for `a_hint_level',
			-- then the highest defined value (or the lowest in case `a_hint_level' is below the lower
			-- bound of the row) is returned.
		require
			valid_hint_level: is_valid_hint_level (a_hint_level)
		local
			l_table_row: ARRAY [AT_TRI_STATE_BOOLEAN]
		do
			if table.has (a_block_type) then
				l_table_row := table [a_block_type]

					-- Guaranteed by the invariant:
				check
					l_table_row.count > 0
				end
				create Result
				if a_hint_level < l_table_row.lower then
						-- If the level is below the lower bound, take the first entry in the row.
					Result.visibility := l_table_row [l_table_row.lower]
					Result.explicitly_defined := False
				elseif a_hint_level > l_table_row.upper then
						-- If the level is below the lower bound, take the last entry in the row
					Result.visibility := l_table_row [l_table_row.upper]
					Result.explicitly_defined := False
				else
					Result.visibility := l_table_row [a_hint_level]
					Result.explicitly_defined := True
				end
			else
					-- This is the default for missing blocks.
				Result := [tri_undefined, False]
			end
		end

	content_visibility_for (a_block_type: AT_BLOCK_TYPE; a_hint_level: INTEGER): TUPLE [visibility: AT_TRI_STATE_BOOLEAN; explicitly_defined: BOOLEAN]
			-- The default content visibility for the complex block type `a_block_type'.
		require
			valid_hint_level: is_valid_hint_level (a_hint_level)
			complex_block_type: enum_block_type.is_complex_block_type (a_block_type)
		local
			l_table_row, l_temp: ARRAY [AT_TRI_STATE_BOOLEAN]
		do
			if content_table.has (a_block_type) then
				l_table_row := content_table [a_block_type]

					-- Guaranteed by the invariant:
				check
					l_table_row.count > 0
				end
				create Result
				if a_hint_level < l_table_row.lower then
						-- If the level is below the lower bound, take the first entry in the row.
					Result.visibility := l_table_row [l_table_row.lower]
					Result.explicitly_defined := False
				elseif a_hint_level > l_table_row.upper then
						-- If the level is below the lower bound, take the last entry in the row
					Result.visibility := l_table_row [l_table_row.upper]
					Result.explicitly_defined := False
				else
					Result.visibility := l_table_row [a_hint_level]
					Result.explicitly_defined := True
				end
			else
				Result := [Tri_undefined, False]
			end
		end

feature {AT_HINT_TABLE} -- Implementation

	table: HASH_TABLE [ARRAY [AT_TRI_STATE_BOOLEAN], AT_BLOCK_TYPE]
			-- Contains the visibility defaults for all blocks.

	content_table: HASH_TABLE [ARRAY [AT_TRI_STATE_BOOLEAN], AT_BLOCK_TYPE]
			-- Contains the content visibility defaults for complex blocks.

	suggested_tables_initial_size: INTEGER = 32
			-- What is the suggested initial size for the two tables?
			-- This is a suggestion to descendants that may or may not be followed.

		-- Abbreviations for tri-state constants for better table readability.

	T: AT_TRI_STATE_BOOLEAN
			-- True
		once ("PROCESS")
			Result := Tri_true
		end

	F: AT_TRI_STATE_BOOLEAN
			-- False
		once ("PROCESS")
			Result := Tri_false
		end

	U: AT_TRI_STATE_BOOLEAN
			-- Undefined
		once ("PROCESS")
			Result := Tri_undefined
		end

invariant
	content_table_has_only_complex_blocks: across content_table.current_keys as ic all enum_block_type.is_complex_block_type (ic.item) end
	both_tables_all_rows_non_empty: (across table as ic all ic.item.count > 0 end) and (across content_table as ic all ic.item.count > 0 end)

end
