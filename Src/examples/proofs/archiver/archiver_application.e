indexing
	description : "Formatter example to show agent verification"
	date        : "$Date$"
	revision    : "$Revision$"

class ARCHIVER_APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
		end

	main (c: !CLIENT)
		local
			t: TAPE_ARCHIVE
		do
			create t.make
--			t.eject
			c.log (agent t.store, "Hello, World!")
		end

end
