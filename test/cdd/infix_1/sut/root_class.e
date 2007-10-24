indexing
	description	: "System's root class"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT_CLASS

create
	make

feature -- Initialization

	make is
			-- Creation procedure.
		local
			b: BOOLEAN
		do
			b := Current and Current
		end


	infix "and" (other: like Current): BOOLEAN is
		do
			check
				False
			end
		end

end -- class ROOT_CLASS
