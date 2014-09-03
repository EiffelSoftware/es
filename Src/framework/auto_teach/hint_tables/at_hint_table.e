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

	visibility_for (a_block_type: AT_BLOCK_TYPE; a_hint_level: NATURAL): TUPLE [visibility: AT_TRI_STATE_BOOLEAN; explicitly_defined: BOOLEAN]
			-- The default visibility for block type `a_block_type' at hint level `a_hint_level'.
			-- If `a_block_type' is present in the table, but no value is defined for `a_hint_level',
			-- then the highest defined value (or the lowest in case `a_hint_level' is below the lower
			-- bound of the row) is returned.
		local
			l_table_row: ARRAY [AT_TRI_STATE_BOOLEAN]
			l_hint_level: INTEGER
		do
			Result := visibility_from_table (table, a_block_type, a_hint_level)
		end

	content_visibility_for (a_block_type: AT_BLOCK_TYPE; a_hint_level: NATURAL): TUPLE [visibility: AT_TRI_STATE_BOOLEAN; explicitly_defined: BOOLEAN]
			-- The default content visibility for complex block type `a_block_type' at hint level `a_hint_level'.
			-- If `a_block_type' is present in the table, but no value is defined for `a_hint_level',
			-- then the highest defined value (or the lowest in case `a_hint_level' is below the lower
			-- bound of the row) is returned.
		require
			complex_block_type: enum_block_type.is_complex_block_type (a_block_type)
		local
			l_table_row: ARRAY [AT_TRI_STATE_BOOLEAN]
			l_hint_level: INTEGER
		do
			Result := visibility_from_table (content_table, a_block_type, a_hint_level)
		end

feature {AT_HINT_TABLE} -- Implementation

	table: HASH_TABLE [ARRAY [AT_TRI_STATE_BOOLEAN], AT_BLOCK_TYPE]
			-- Contains the visibility defaults for all blocks.

	content_table: HASH_TABLE [ARRAY [AT_TRI_STATE_BOOLEAN], AT_BLOCK_TYPE]
			-- Contains the content visibility defaults for complex blocks.

	visibility_from_table (a_table: like table; a_block_type: AT_BLOCK_TYPE; a_hint_level: NATURAL): TUPLE [visibility: AT_TRI_STATE_BOOLEAN; explicitly_defined: BOOLEAN]
			-- The visibility for block type `a_block_type' at hint level `a_hint_level' in table `a_table'.
			-- This routine will be called by `visibility_for' and `content_visibility_for', respectively providing
			-- `table' and `content_table' as the `a_table' argument, and is here for avoiding code duplication.
			-- If `a_block_type' is present in the table, but no value is defined for `a_hint_level',
			-- then the highest defined value (or the lowest in case `a_hint_level' is below the lower
			-- bound of the row) is returned.
		local
			l_table_row: ARRAY [AT_TRI_STATE_BOOLEAN]
			l_hint_level: INTEGER
		do
				-- The following conversion is guaranteed to succeed, this is
				-- promised by the postcondition of `is_valid_hint_level'.
			l_hint_level := a_hint_level.as_integer_32

			if a_table.has (a_block_type) then
				l_table_row := a_table [a_block_type]

					-- Guaranteed by the invariant:
				check
					l_table_row.count > 0
				end
				create Result
				if l_hint_level < l_table_row.lower then
						-- If the level is below the lower bound, take the first entry in the row.
					Result.visibility := l_table_row [l_table_row.lower]
					Result.explicitly_defined := False
				elseif l_hint_level > l_table_row.upper then
						-- If the level is below the lower bound, take the last entry in the row
					Result.visibility := l_table_row [l_table_row.upper]
					Result.explicitly_defined := False
				else
					Result.visibility := l_table_row [l_hint_level]
					Result.explicitly_defined := True
				end
			else
					-- This is the default for missing blocks.
				Result := [Tri_undefined, False]
			end
		end

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
