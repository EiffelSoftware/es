indexing
	description	: "some class"
	date: "$Date$"
	revision: "$Revision$"

class
	SOME_CLASS

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
			do_nothing
		ensure
			false_postcondition: False
		end

end
