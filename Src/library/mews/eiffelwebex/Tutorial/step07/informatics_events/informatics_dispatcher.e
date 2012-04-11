indexing
	description	: "System's entry class derived from CGI_INTERFACE, takes care of requests and sends back responses"
	author: "Peizhu Li <lip@student.ethz.ch>"
	date: "$05.02.2008$"
	revision: "$0.8.1$"

class
	INFORMATICS_DISPATCHER

inherit
	REQUEST_DISPATCHER

redefine
	make
end

create
	make

feature -- creation
	make is
		-- simply call parent's make procedure, but define a local variable for each handler
		-- to ensure respective handler classes will be included in the application		
	local
		event_handler: EVENT_HANDLER
		user_handler: USER_HANDLER
		general_handler: GENERAL_HANDLER
	do
		PRECURSOR {REQUEST_DISPATCHER}
	end


invariant
	invariant_clause: True

end -- class INFORMATICS_DISPATCHER
