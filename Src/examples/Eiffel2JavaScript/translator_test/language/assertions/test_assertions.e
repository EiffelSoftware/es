class
	TEST_ASSERTIONS

inherit
	TEST

create
	make

feature {NONE} -- Initialization

	make
		do
			invoke_test ("1", agent
				do
					assert (correct_square_root (9)=3)
				end
			)
			invoke_test ("2", agent
				do
					expects_exception := true
					assert (buggy_square_root (9)=3)
				end
			)
			invoke_test ("3", agent
				local
					b: ASSERTIONS_B
					r: INTEGER
				do
					create b
					r := b.foo (1)
					r := b.foo (0)
				end
			)
		end

feature {NONE} -- Implementation

	correct_square_root (x: REAL) : REAL
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

	buggy_square_root (x: REAL) : REAL
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
			-- Add 1 to result
			Result := Result + 1
		ensure
			result_is_square_root: Result * Result = x
		end

end
