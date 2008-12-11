indexing
	description : "Formatter example to show agent verification"
	date        : "$Date$"
	revision    : "$Revision$"

class APPLICATION_ARCHIVER

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
			c.log (agent t.store, "Hello, World!")
		end

end
