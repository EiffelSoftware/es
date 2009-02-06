indexing
	description: "Test class for counter example."
	date: "$Date$"
	revision: "$Revision$"

class
	COUNTER_TEST

create
	make

feature {NONE} -- Initialization

	make
		local
			c1, c2: COUNTER
		do
			create c1.make_zero
			create c2.make_zero

			c1.increment

			check
				c1.value = 1
				c2.value = 0
			end

			c2.increment
			c2.increment

			check
				c1.value = 1
				c2.value = 2
			end

			c1.add (c2)

			check
				c1.value = 3
				c2.value = 2	-- violated due to automatic generated frame of `add'
			end
		end

end
