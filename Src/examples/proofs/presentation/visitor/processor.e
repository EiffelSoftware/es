indexing
	description: "Summary description for {PROCESSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PROCESSOR

create
	make

feature

	make
		do
			sum := 0
		ensure
			sum = 0
		end

feature -- Access

	sum: INTEGER

feature -- Processing

	process_b (a_b: !B)
		do
			sum := sum + a_b.value
		ensure
			sum = old sum + a_b.value
			a_b.value = old a_b.value -- remove from modifies
		end

	process_c (a_c: !C)
		do

		end

end
