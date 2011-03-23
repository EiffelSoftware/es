note
	description : "Circles deom root class."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	JS_OBJECT

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			--| Add your code here
			console.info ("Hello Eiffel World!%N")

			reset
		end

feature {NONE} -- Implementation

	create_circle (x, y, radius: DOUBLE; color: attached STRING): attached CIRCLE
		local
			l_position: VECTOR
		do
			create l_position.make (x, y)
			create Result.make (l_position, radius, color)
		end

	reset
		local
			l_circles: LINKED_LIST[attached CIRCLE]
		do
			create l_circles.make
			l_circles.extend (create_circle ( 25,  50,  25, "#f00"))
			l_circles.extend (create_circle (390,  50,  35, "#0f0"))
			l_circles.extend (create_circle (300,  50,  50, "#00f"))
			l_circles.extend (create_circle (300, 250, 100, "#888"))
			l_circles.extend (create_circle (100,  30,  30, "#880"))
			l_circles.extend (create_circle (145,  15,  15, "#088"))
			l_circles.extend (create_circle (200,  45,  45, "#808"))

			create world.make (100, 5, 500, 500, l_circles)
			world.render
		end

	world: attached WORLD

end
