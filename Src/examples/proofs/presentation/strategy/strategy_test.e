indexing
	description: "Summary description for {STRATEGY_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STRATEGY_TEST

feature

	test
		local
			c: CONTEXT
			t: INTEGER
		do

			create c.set_strategy (create {ADDITION_STRATEGY})

			c.execute (1, 2)

			check
				c.last_result = 3
			end

			c.set_strategy (create {SUBTRACTION_STRATEGY})

			c.execute (1, 2)

			check
				c.last_result = -1
			end

		end

end
