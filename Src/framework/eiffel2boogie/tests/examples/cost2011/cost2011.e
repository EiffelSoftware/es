class
	COST2011

feature -- COST 2011: Maximum in an array

	max_in_array (a: ARRAY [INTEGER]): INTEGER
			-- Index of maximum element of `a'.
		require
			a_not_empty: a.count > 0
		local
			x, y: INTEGER
		do
			from
				x := 1
				y := a.count
			invariant
				1 <= x and y <= a.count
				y >= x
				across 1 |..| x as i all a[i.item] <= a[x] or a[i.item] <= a[y] end
				across y |..| a.count as i all a[i.item] <= a[x] or a[i.item] <= a[y] end
			until
				x = y
			loop
				if a[x] <= a[y] then
					x := x + 1
				else
					y := y - 1
				end
			variant
				y - x
			end
			Result := x
		ensure
			result_in_range: 1 <= Result and Result <= a.count
			result_is_max1: across 1 |..| a.count as i all a[i.item] <= a[Result] end
			result_is_max2: across a as i all i.item <= a[Result] end
		end

end
