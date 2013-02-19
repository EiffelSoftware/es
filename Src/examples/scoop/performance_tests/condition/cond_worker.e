note
	description: "Summary description for {COND_WORKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COND_WORKER

create
	make

feature
	num_iterations: INTEGER

	-- Each worker shares a separate VAR.
	make (v: separate VAR; max: INTEGER)
		do
			var := v
      num_iterations := max
		end

	var: separate VAR

	-- Producers wait for the number in var to be odd many times.
	produce
		local
			i: INTEGER
		do
			from i := 1
			until i > num_iterations
			loop
				produce_odd (var)
				i := i + 1
			end
		end

	produce_odd (v: separate VAR)
		require
			v.i \\ 2 = 1
		do
			v.inc
		end

	-- Consumers wait for the number in var to be even many times.
	consume
		local
			i: INTEGER
		do
			from i := 1
			until i > num_iterations
			loop
				consume_even (var)
				i := i + 1
			end
		end

	consume_even (v: separate VAR)
		require
			v.i \\ 2 = 0
		do
			v.inc
		end
end
