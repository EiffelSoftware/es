indexing
	description: "handler for event related requests"
	author: "Peizhu Li, <lip@student.ethz.ch>"
	date: "$05.02.2008$"
	revision: "$0.8.1$"

class
	EVENT_HANDLER

inherit
	INFORMATICS_HANDLER
	APPLICATION_CONSTANTS

create
	make

feature -- access

	event_dao: EVENT_DAO
		-- all events

feature -- creation / initialization


feature -- process request

	handling_request is
			-- dispatching requests to relevant handling routines, processing request
		require else
			context /= void
		do
			create {EVENT_DAO_FILE_IMPL}event_dao.make("data_path", "event_file", "id_file" )
		end

feature {NONE} -- implementation


invariant
	invariant_clause: True -- Your invariant here

end
