indexing
	description : "project application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.

		local
			d_sep_class: separate D[X]
			d: D[X]
			x: X
			y: Y
			a: D[separate X]

		do
			create d.make
			create d_sep_class.make
			try(a)

		end

	try(test:D[separate X])is
			-- testin...
			do

			end


end
