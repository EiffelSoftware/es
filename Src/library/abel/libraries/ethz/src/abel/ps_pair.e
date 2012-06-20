note
	description: "Small helper utility (TUPLE is a bit awkward...)"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_PAIR [A,B]

create
	make,
	make_from_tuple

convert
	to_tuple: {TUPLE[first:A; second:B]},
	make_from_tuple ({TUPLE[first:A; second:B]})

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

	to_tuple: TUPLE[ first: A; second:B ]
		do
			create Result.make
			Result.first := first
			Result.second := second
		end

feature {NONE} -- Initialization

	make (a:A; b:B)
			-- Initialization for `Current'.
		do
			first:=a
			second:=b
		end

	make_from_tuple (tup:TUPLE[first:A; second:B])
		do
			first:= tup.first
			second:= tup.second
		end

end
