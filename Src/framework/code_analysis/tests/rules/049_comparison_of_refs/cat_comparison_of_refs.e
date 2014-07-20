class
	CAT_COMPARISON_OF_REFS

feature {NONE} -- Test

	comparison (a_list: LINKED_LIST[BOOLEAN])
		-- Violates the comparison of object references rule.
		local
			l_bool: BOOLEAN
			l_list: LINKED_LIST [BOOLEAN]
			l_int1, l_int2: INTEGER
			l_ref_int1, l_ref_int2: INTEGER_REF
		do
			-- Initialize locals.
			l_ref_int1 := 1
			l_ref_int2 := 2
			l_int1 := 3
			l_int2 := 4

			-- Cases that should not violate the rule.

			l_bool := 4 = l_int1
			l_bool := "fa" = "gjladsö"
			l_bool := 5 = l_ref_int1 or a_list = Void and then l_ref_int2 = 65

			-- Cases that should violate the rule.
			if l_list = a_list then
				l_bool := l_ref_int1 = l_ref_int2
			else
				l_bool := l_int1 = l_ref_int2
				l_bool := l_int1 = l_int2
				l_bool := l_ref_int2 = l_int2
			end
		end

end
