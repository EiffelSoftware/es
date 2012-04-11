indexing
	description: "handler for user related requests"
	author: "Peizhu Li, <lip@student.ethz.ch>"
	date: "$05.02.2008$"
	revision: "$0.8.1$"

class
	USER_HANDLER

inherit
	INFORMATICS_HANDLER
	APPLICATION_CONSTANTS

create
	make

feature -- process request

	handling_request is
			-- dispatching requests to relevant handling routines, processing request
		require else
			context /= void
		do
		end


feature {NONE} -- implementation


invariant
	invariant_clause: True -- Your invariant here

end
