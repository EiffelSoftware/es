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
		do
			bar
		end

	bar is
			-- Fail with a postcondition violation.
		require
			precondition: True
		do
		
		ensure
			false_postcondition: False
		end

end
