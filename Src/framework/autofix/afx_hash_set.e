note
	description: "Summary description for {AFX_HASH_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_HASH_SET [G -> HASHABLE]

inherit
	DS_HASH_SET [G]

	AFX_UTILITY
		undefine
			is_equal,
			copy
		end

create
	make,
	make_equal,
	make_default

feature -- Access

	permutations: LINKED_LIST [ARRAYED_LIST [G]]
			-- Permutations of current set
		local
			i: INTEGER
			c: INTEGER
			l_per: ARRAYED_LIST [G]
		do
			create Result.make
			from
				i := 0
				c := factorial (count)
			until
				i = c
			loop
				create l_per.make (count)
				do_all (agent l_per.extend)
				permute (l_per, i)
				Result.extend (l_per)
				i := i + 1
			end
		end

	combinations (k: INTEGER): LINKED_LIST [like Current]
			-- `k' combinations of current set.
		local
			l_temp: like Current
		do
			create l_temp.make (count)
			l_temp.set_equality_tester (equality_tester)
			Result := binom (Current, k, l_temp)
		end

feature{NONE} -- Implementation

	binom (a_include_set: like Current; k: INTEGER; a_result_set: like Current): LINKED_LIST [like Current]
			-- `k' combinations of `a_include_set'
		require
			k_non_negative: k >= 0
		local
			l_exclude_set: like Current
			l_cursor: DS_HASH_SET_CURSOR [G]
			l_set: like Current
			l_rset: like Current
		do
			if k = 0 then
				create Result.make
				Result.extend (a_result_set)
			else
				create Result.make
				create l_exclude_set.make (count)
				l_exclude_set.set_equality_tester (equality_tester)

				from
					l_cursor := a_include_set.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					l_exclude_set.force_last (l_cursor.item)
					create l_set.make (count)
					l_set.set_equality_tester (equality_tester)
					a_include_set.do_all (agent l_set.force_last)
					l_exclude_set.do_all (agent l_set.remove)

					create l_rset.make (count)
					l_rset.set_equality_tester (equality_tester)
					a_result_set.do_all (agent l_rset.force_last)
					l_rset.force_last (l_cursor.item)
					binom (l_set, k - 1, l_rset).do_all (agent Result.extend)

					l_cursor.forth
				end
			end
		end

end
