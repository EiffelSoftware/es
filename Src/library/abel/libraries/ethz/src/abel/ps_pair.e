note
	description: "Small helper utility (TUPLE is a bit awkward...)"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_PAIR [A,B]

create
	make

feature

	first:A
		-- First element of pair

	second:B
		-- Second element of pair

	set_first (a:A)
		-- Set the first element
	do
		first := a
	end

	set_second (b:B)
		-- Set the second element
	do
		second:=b
	end

feature {NONE} -- Initialization

	make (a:A; b:B)
			-- Initialization for `Current'.
		do
			first:=a
			second:=b
		end

end
