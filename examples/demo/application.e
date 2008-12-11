indexing
	description : "demo application root class"
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
			-- Run application.
		local
			l1: APPLICATION_ARCHIVER
			l2: APPLICATION_FORMATTER
			l3: SKIPPED_CLASS
			l4: VARIOUS
			l5: ERRORS
			l6: ROBUST [ANY]
		do
			--| Add your code here
		end


end
