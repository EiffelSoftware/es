indexing
	description:	"class that can be inherited to form an admin message"
					"which feature will be executed by the server."
	date		: "19.May.2006"
	author		: "Bernhard S. Buss"
	revision: "$Revision$"

class
	ADMIN_CMD
	
inherit
	EMU_MESSAGE
	
	
feature -- Execution

	execute (system: EMU_SERVER) is
			-- command that will be executed by the server upon receival of the message.
			-- parameter passed by the server will contain a reference to the server class.
		require
			system_not_void: system /= Void
		do
			-- to be implemented in the classes that inherit from ADMIN_CMD.
		end

end
