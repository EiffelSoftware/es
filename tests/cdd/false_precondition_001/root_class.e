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
			-- Fail with a precondition violation.
		require
			false_precondition: False
		do

		ensure
			postcondition: True
		end

end
