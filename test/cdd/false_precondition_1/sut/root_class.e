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
		do
			bar
		end

	bar is
		require
			False
		do
		end

end -- class ROOT_CLASS
