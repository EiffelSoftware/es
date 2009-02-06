indexing
	description: "Test class for arrayed stack example."
	date: "$Date$"
	revision: "$Revision$"

class
	ARRAYED_STACK_TEST

create
	make

feature {NONE} -- Initialization

	make
		local
			stack: SIMPLE_ARRAYED_STACK [INTEGER]
		do
			create stack.make (10)
			stack.push (4)
			stack.push (7)
			stack.push (1)

			check
				stack.top = 1
			end

			stack.pop

			check
				stack.top = 7
				stack.count = 2
			end
		end

end
