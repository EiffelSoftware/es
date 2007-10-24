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
			bar1
		end

	bar1 is
		do
			bar2
		end

feature {NONE}

	bar2 is
		do
			check False end
		end

end -- class ROOT_CLASS
