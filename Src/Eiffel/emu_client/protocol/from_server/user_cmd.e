indexing
	description: "Parent class for a user message which feature will be executed by the server"
	author: "Ramon Schwammberger, Andrea Zimmermann, Domenic Schroeder"
	date: "$Date$"
	revision: "$Revision$"
	
deferred class
	USER_CMD

inherit
	EMU_MESSAGE
	
	
feature -- Execution

	execute () is
			-- command that will be executed by the client upon receival of the message.
		require
			--system_not_void: system /= Void
		deferred
		end

end
