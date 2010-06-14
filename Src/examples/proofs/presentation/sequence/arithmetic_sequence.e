indexing
	description: "Summary description for {FIBONACCI_SEQUENCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ARITHMETIC_SEQUENCE

inherit
	INTEGER_SEQUENCE

create
	make

feature

	make (a_start, a_difference: INTEGER)
		do
			item := a_start
			difference := a_difference
		ensure
			item = a_start
			difference = a_difference
		end

	difference: INTEGER

	forth
		do
			item := item + difference
		ensure then
			item = old item + difference
			difference = old difference -- remove from modifies
		end

end
