indexing
	description: "Test class for account example."
	date: "$Date$"
	revision: "$Revision$"

class
	ACCOUNT_TEST

create
	make

feature {NONE} -- Initialization

	make
		local
			a1, a2, a3: ACCOUNT
		do
			create a1.make
			create a2.make

			check
				a1.balance = 0
				a2.balance = 0
			end

			a1.deposit (10)
			a2.deposit (20)

			check
				a1.balance = 10
				a2.balance = 20
			end

			a1.withdraw (5)
			a2.withdraw (10)

			check
				a1.balance = 5
				a2.balance = 10
			end

			a1.transfer (3, a2)

			check
				a1.balance = 2
				a2.balance = 13
			end

		end

--	make
--		local
--			i, j: INTEGER
--		do
--			from
--				i := 1
--				j := 10
--			invariant
--				(i - 1) <= j
--			until
--				i > j
--			loop
--				i := i + 1
--			end
--			check i - 1 = j end
--		end
--		
--	lopp1
--		local
--			a, b: INTEGER
--		do
--			from
--				a := 1
--				b := 10
--			invariant
--				a + b = 11
--			until
--				a > b
--			loop
--				a := a + 1
--				b := b - 1
--			variant
--				12 - a - b
--			end

--			check
--				a = 6
--				b = 5
--			end

--		end

--	loop2
--		local
--			x, y: INTEGER
--		do
--			from
--				x := 0
--				y := 0
--			invariant
--				l_inv: y = x * 2
--			until
--				x = 5
--			loop
--				x := x + 1
--				y := y + 2
--			end

--			check
--				x = 5
--				y = 10
--			end
--		end

--	loop3
--		local
--			x: INTEGER
--			y: INTEGER
--		do
--				-- this arithmetic progression cannot be proven (so far?)
--			from
--				x := 1
--				y := 1
--			invariant
--				x <= 100
--				closed_form: y = x * (x + 1) // 2
--			until
--				x = 100
--			loop
--				x := x + 1
--				y := y + x
--			variant
--				100 - x
--			end

--			check
--				y = 5050
--			end
--		end

end
