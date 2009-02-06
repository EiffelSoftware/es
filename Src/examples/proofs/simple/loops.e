indexing
	description: "Summary description for {LOOPS}."
	date: "$Date$"
	revision: "$Revision$"

class
	LOOPS

feature

	lopp1
		local
			a, b: INTEGER
		do
			from
				a := 1
				b := 10
			invariant
				a + b = 11
			until
				a > b
			loop
				a := a + 1
				b := b - 1
			variant
				12 - a - b
			end

			check
				a = 6
				b = 5
			end

		end

	loop2
		local
			x, y: INTEGER
		do
			from
				x := 0
				y := 0
			invariant
				l_inv: y = x * 2
			until
				x = 5
			loop
				x := x + 1
				y := y + 2
			end

			check
				x = 5
				y = 10
			end
		end

	loop3
		local
			x: INTEGER
			y: INTEGER
		do
				-- this arithmetic progression cannot be proven (so far?)
			from
				x := 1
				y := 1
			invariant
				x <= 100
				closed_form: y = x * (x + 1) // 2
			until
				x = 100
			loop
				x := x + 1
				y := y + x
			variant
				100 - x
			end

			check
				y = 5050
			end
		end

end
