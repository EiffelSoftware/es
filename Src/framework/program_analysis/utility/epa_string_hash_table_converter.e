note
	description: "Summary description for {}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class EPA_STRING_HASH_TABLE_CONVERTER [G, S -> READABLE_STRING_GENERAL]

feature

	string_table_from_hash_table (a_table: HASH_TABLE[G, S]): STRING_TABLE[G]
			-- {STRING_TABLE} object from `a_table'.
		require
			table_attached: a_table /= Void
		local
		do
			create Result.make_equal (a_table.count + 1)
			from a_table.start
			until a_table.after
			loop
				Result.put (a_table.item_for_iteration, a_table.key_for_iteration)

				a_table.forth
			end
		end


end
