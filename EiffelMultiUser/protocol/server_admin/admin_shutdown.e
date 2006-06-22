indexing
	description: "This object uses the execute feature of ADMIN_CMD to shutdown the emu-server."
	author: "Bernhard S. Buss"
	date: "20.May.2006"
	revision: "$Revision$"

class
	ADMIN_SHUTDOWN

inherit
	ADMIN_CMD
		rename
			execute as shutdown
		redefine
			shutdown
		end

feature -- Execution

	shutdown (system: EMU_SERVER) is
			-- shut the server down.
		do
			system.shutdown
		ensure then
			system_is_down: system.is_shutdown
		end
		

end
