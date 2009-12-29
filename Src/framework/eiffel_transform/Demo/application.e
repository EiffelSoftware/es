indexing
	description : "account application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application
		local
			a1: A1
			a2: A2
		do
			create a1
			create a2
		
			a1.test(1)
			a1.test(-1)
			a2.test(1)
			a2.test(-1)
			
			io.read_line
		end
		
	hmm: INTEGER

end
