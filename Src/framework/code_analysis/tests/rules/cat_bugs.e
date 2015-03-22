note
	description: "For testing bugs of the Eiffel Inspector"

class
	CAT_BUGS [G]

feature

	make_from_array (a: ARRAY [G])
			-- Create list from array `a'.
		require
			array_exists: a /= Void
		do
			index := 0
			area_v2 := a.area
		ensure
			shared: area = a.area
			correct_position: before
			filled: count = a.count
		end

	area: SPECIAL [G]

	area_v2: SPECIAL [G]

	index: INTEGER

	before: BOOLEAN

	count: INTEGER

end
