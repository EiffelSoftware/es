class
	VSTTE2010

feature -- VSTTE 2010: Sum & max

	sum_and_max (a: ARRAY [INTEGER]): TUPLE [sum, max: INTEGER]
			-- Calculate sum and maximum of array `a'.
		note
			framing: False
		require
			a_not_void: a /= Void
			a_not_empty: a.count > 0
			a_non_negative: across a as ai all ai.item >= 0 end
		local
			i: INTEGER
			sum, max: INTEGER
		do
			from
				i := 1
			invariant
				1 <= i and i <= a.count + 1
				across 1 |..| (i-1) as ai all a[ai.item] <= max end
				sum <= (i-1) * max
			until
				i > a.count
			loop
				sum := sum + a[i]
				if a[i] > max then
					max := a[i]
				end
				i := i + 1
			variant
				a.count - i + 1
			end

			Result := [sum, max]
		ensure
			sum_in_range: Result.sum <= a.count * Result.max
		end

end
