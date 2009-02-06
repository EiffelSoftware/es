indexing
	description: "Test class for cell example."
	date: "$Date$"
	revision: "$Revision$"

class
	CELL_TEST

create
	make

feature {NONE} -- Initialization

	make
		local
			c1, c2, c3: INTEGER_CELL
		do
			create c1.set_value (1)
			create c2.set_value (2)
			create c3.set_value (3)

			check
				c1.value = 1
				c2.value = 2
				c3.value = 3
			end

			c1.set_value (4)
			c2.set_value (5)
			c3.set_value (6)

			check
				c1.get_value = 4
				c2.get_value = 5
				c3.get_value = 6
			end
		end

	make_agent_test
		indexing
			proof: False
		local
			c1, c2: INTEGER_CELL
		do
			create c1.set_value (1)
			create c2.set_value (2)

			check
				c1.value = 1
				c2.value = 2
			end

			execute (agent c1.set_value (?), 3)
			execute (agent c2.set_value (?), 4)

			check
				c1.value = 3
				c2.value = 4
			end
		end

	execute (proc: !PROCEDURE [ANY, TUPLE [INTEGER]]; arg: INTEGER)
		require
			proc.precondition ([arg])
		do
			proc.call ([arg])
		ensure
			proc.postcondition ([arg])
		end

end
