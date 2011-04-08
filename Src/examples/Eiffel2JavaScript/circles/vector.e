note
	description : "A 2D Vector."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	VECTOR

inherit
	DOUBLE_MATH

create
	make

feature {NONE} -- Initialization

	make (a_x, a_y: DOUBLE)
		do
			x := a_x
			y := a_y
		end

feature -- Access

	x: DOUBLE assign set_x
	set_x (a_x: DOUBLE)
		do
			x := a_x
		end

	y: DOUBLE assign set_y
	set_y (a_y: DOUBLE)
		do
			y := a_y
		end

feature -- Basic Operation

	add alias "+" (a_other: attached VECTOR): attached VECTOR
		do
			create Result.make (x + a_other.x, y + a_other.y)
		end

	subtract alias "-" (a_other: attached VECTOR): attached VECTOR
		do
			create Result.make (x - a_other.x, y - a_other.y)
		end

	multiply alias "*" (a_scalar: DOUBLE): attached VECTOR
		do
			create Result.make (x * a_scalar, y * a_scalar)
		end

	divide alias "/" (a_scalar: DOUBLE): attached VECTOR
		do
			create Result.make (x / a_scalar, y / a_scalar)
		end

	magnitude: DOUBLE
		do
			Result := sqrt (x * x + y * y)
		end

	as_normalized: attached VECTOR
		do
			Result := Current / magnitude
		end

	dot (a_other: attached VECTOR): DOUBLE
		do
			Result := x * a_other.x + y * a_other.y
		end

end
