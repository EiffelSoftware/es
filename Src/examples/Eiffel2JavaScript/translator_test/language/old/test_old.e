class
	TEST_OLD

inherit
	TEST

create
	make

feature {NONE} -- Initialization

	make
		do
			invoke_test ("1", agent
				do
					v := 16
					do_square_root_on_v
					check v = 4 end
				end
			)
		end

feature {NONE} -- Implementation

	v: REAL
	do_square_root_on_v
		require v > 0
		do
			v := square_root (v)
		ensure
			v^4 + v^2 = old(v+1) * old(v)
		end

	square_root (x: REAL) : REAL
		require
			x_positive: x > 0
		local
		do
			from
				Result := x
			until
				Result * Result = x
			loop
				Result := (Result + x / Result) / 2
			end
		ensure
			result_is_square_root: Result * Result = x
		end

end
