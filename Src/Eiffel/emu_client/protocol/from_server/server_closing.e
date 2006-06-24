indexing
	description: "server is shutting down"
	author: "Ramon Schwammberger, Andrea Zimmermann, Domenic Schroeder"
	date: "$Date$"
	revision: "$Revision$"

class
	SERVER_CLOSING

inherit 
	USER_CMD

feature -- Execution

	execute () is
			-- command that will be executed by the client upon receival of the message.
		do
			-- to be implemented according to server side messages
		end

invariant
	invariant_clause: True -- Your invariant here

end
