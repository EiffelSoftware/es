note
	description : "A circle."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	CIRCLE

inherit
	DOUBLE_MATH

create
	make

feature {NONE} -- Initialization

	make (a_position: attached VECTOR; a_radius: DOUBLE; a_color: attached COLOR)
			-- Initialize
		do
			position := a_position
			radius := a_radius
			mass := Pi * radius * radius
			color := a_color
			create velocity.make (0, 0.001 * mass)
		end

feature -- Access

	color: attached COLOR

	position: attached VECTOR assign set_position
	set_position (a_position: attached VECTOR)
		do
			position := a_position
		end

	velocity: attached VECTOR assign set_velocity
	set_velocity (a_velocity: attached VECTOR)
		do
			velocity := a_velocity
		end

	radius, mass: DOUBLE

end
