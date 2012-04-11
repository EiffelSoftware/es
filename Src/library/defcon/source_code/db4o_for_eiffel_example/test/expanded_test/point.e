indexing
	description: "Two-dimensional points"
	author: "Ruihua Jin"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	POINT

create
	default_create,
	make_with_x_y

feature {NONE}  -- Initialization

	make_with_x_y (a: INTEGER; b: INTEGER) is
			-- Initialize `x' with `a', `y' with `b'.
		do
			x := a
			y := b
		end

feature  -- Access

	x, y: INTEGER

	x_is_greater_than (v: INTEGER): BOOLEAN is
			-- Is `x' greater than `v'?
			-- Used as an agent in a Native Query.
		do
			Result := x > v
		end

feature  -- Print

	to_string: SYSTEM_STRING is
			-- The string representation of the current POINT instance to the console.
		do
			Result := "Point (" + x.out + ", " + y.out + ")"
		end


end
