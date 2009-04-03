indexing
	description: "Summary description for {C}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	C

inherit
	A

create
	make

feature

	make (a_int: NATURAL)
		do

		end

	process (a_processor: !PROCESSOR)
		do
			a_processor.process_c (Current)
		ensure then
			(agent a_processor.process_c).postcondition([Current])
		end

end
