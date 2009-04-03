indexing
	description: "Summary description for {B}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	B

inherit
	A

create
	make

feature

	make (a_int: INTEGER)
		do
			value := a_int
		ensure
			value = a_int
		end

	value: INTEGER

	process (a_processor: !PROCESSOR)
		do
			a_processor.process_b (Current)
		ensure then
			(agent a_processor.process_b).postcondition([Current])

			value = old value -- Bug of Boogie needs this
		end

end
