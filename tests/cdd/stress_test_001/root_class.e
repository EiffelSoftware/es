indexing
	description	: "System's root class, starting recursion"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT_CLASS

create
	make

feature -- Initialization

	make is
		do
			bar(0)
		end

	bar(an_int: INTEGER) is
			-- Fail with a postcondition violation.
		require
			precondition: an_int < 990
		do
			bar(an_int + 1)
		ensure
			postcondition: True
		end

end
