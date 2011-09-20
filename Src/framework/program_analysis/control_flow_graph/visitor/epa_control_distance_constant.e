note
	description: "Summary description for {EPA_CONTROL_DISTANCE_CONSTANT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_CONTROL_DISTANCE_CONSTANT
		
feature -- Constant

	Infinite_distance: INTEGER_32 = 1_000_000
			-- Infinite distance for unreachable control positions.

end
