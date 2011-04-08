note
	description: "Summary description for {SETUP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SETUP

create
	make

feature {NONE} -- Initialization

	make
		do
		end

feature -- Basic Operation

	create_world: attached WORLD
		local
			circles: attached LIST[attached CIRCLE]
		do
			create {LINKED_LIST[attached CIRCLE]}circles.make
			circles.extend (create_circle ( 25,  50,  25, create_color("#f00", 255, 0, 0)))
			circles.extend (create_circle (390,  50,  35, create_color("#0f0", 0, 255, 0)))
			circles.extend (create_circle (300,  50,  50, create_color("#00f", 0, 0, 255)))
			circles.extend (create_circle (300, 250, 100, create_color("#888", 136, 136, 136)))
			circles.extend (create_circle (100,  30,  30, create_color("#880", 136, 136, 0)))
			circles.extend (create_circle (145,  15,  15, create_color("#088", 0, 136, 136)))
			circles.extend (create_circle (200,  45,  45, create_color("#808", 136, 0, 136)))

			create Result.make (50, 5, 450, 600, circles)
		end

feature {NONE} -- Implementation

	create_circle (x, y, radius: DOUBLE; color:  attached COLOR): attached CIRCLE
		local
			l_position: VECTOR
		do
			create l_position.make (x, y)
			create Result.make (l_position, radius, color)
		end

	create_color (html: attached STRING_32; r,g,b: INTEGER): attached COLOR
		do
			create Result.make (html, r,g,b)
		end

end
