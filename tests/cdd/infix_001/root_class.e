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
		local
			b: BOOLEAN
		do
			b := Current < Current
		end

	infix "<" (other: like Current): BOOLEAN is
		do
		ensure
			false_postcondition: False
		end

end
