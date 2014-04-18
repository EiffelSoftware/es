-- Calculating the sum and the maximum of array elements.
-- (From the VSTTE 2010 verification competition).

class SUM_AND_MAX

feature

	sum_and_max (a: V_ARRAY [INTEGER]): TUPLE [sum: INTEGER; max: INTEGER]
			-- Calculate sum and maximum of array `a'.
		note
			status: impure -- We do not intend to use this function in contracts
		require
			modify ([]) -- But it doesn't modify existing objects
		local
			i: INTEGER
			sum, max: INTEGER
		do
			from
				i := 1
			invariant
				i1: 1 <= i and i <= a.count + 1
				i2: sum <= (i-1) * max
			until
				i > a.count
			loop
				sum := sum + a[i]
				if a[i] > max then
					max := a[i]
				end
				i := i + 1 -- Try commenting this out
			end
			Result := [sum, max]
		ensure
			sum_in_range: Result.sum <= a.count * Result.max
		end

end
