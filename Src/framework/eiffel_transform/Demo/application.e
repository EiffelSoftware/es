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
			dummy: ETR_DUMMY
		do
			create dummy
			dummy.test (-1)
			dummy.test (1)
			io.read_line
		end
		
	hmm: INTEGER

end
