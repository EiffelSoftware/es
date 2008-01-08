indexing
	description	: "System's root class"
	date: "$Date$"
	revision: "$Revision$"

class
	SOME_GENERIC_CLASS[G]

create
	make

feature -- Initialization


	make is
		do
		end

	foo is
			-- Fail with a postcondition violation.
		require
			precondition: True
		do
		
		ensure
		  false_postcondition: False
		end

end
