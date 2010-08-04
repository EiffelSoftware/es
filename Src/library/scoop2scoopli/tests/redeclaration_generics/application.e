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
			-- Used to test redeclaration in an generic environment
		local
			d_sep_class: attached separate D[X]
			d: D[X]
			x: X
			y: Y
			a: D[attached separate X]

		do
			create d.make
			create d_sep_class.make

		end


end
