class
	CAT_MERGEABLE_CONDITIONALS

feature {NONE} -- Test

	conditionals
		local
			l_b1, l_b2, l_b3: BOOLEAN
		do
			if l_b1 and l_b2 or else l_b3 then
				do_nothing
			end

			if l_b1 and l_b2 or else l_b3 then
				do_nothing
			end

			if not l_b3 and l_b2 then
				do_nothing
			end

			if not l_b3 and l_b2 then
				do_nothing
			end
		end

end
