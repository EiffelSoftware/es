note
	description: "Summary description for {AT_HINT_TABLE}." -- TODO
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AT_HINT_TABLE

inherit {NONE}
	AT_COMMON

feature -- Access

	entry (a_block_type: AT_BLOCK_TYPE; a_hint_level: INTEGER): TUPLE [visibility: BOOLEAN; explicitly_defined: BOOLEAN]
			-- Access the visibility table, looking for the specified block type and hint level.
		require
			valid_hint_level: is_valid_hint_level (a_hint_level)
		local
			l_table_row: ARRAY [BOOLEAN]
		do
				-- Guaranteed by the invariant:
			check table.has (a_block_type.value_name) end

			l_table_row := table [a_block_type.value_name]

				-- Guaranteed by the invariant:
			check l_table_row.count > 0 end

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
		end

feature {AT_HINT_TABLE} -- Implementation

	table: STRING_TABLE [ARRAY [BOOLEAN]]

invariant
	all_block_types_present: across enum_block_type.value_names as ic all table.has (ic.item) end
	all_rows_non_empty: across table as ic all ic.item.count > 0  end

end
