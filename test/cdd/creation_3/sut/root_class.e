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
			an_a: A
		do
			--| Add your code here
			create an_a.make
		end

end -- class ROOT_CLASS
