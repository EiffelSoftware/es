indexing
	description	: "System's entry class derived from CGI_INTERFACE, takes care of requests and sends back responses"
	author: "Peizhu Li <lip@student.ethz.ch>"
	date: "November 2007"
	revision: "$0.3.1$"

class
	ZEN_DISPATCHER

inherit
	REQUEST_DISPATCHER

redefine
	make
end

create
	make

feature -- creation
	make is
		-- simply call make parent's make procedure, but try list used handlers here so that all handlers get compiled and linked
		-- in the program, ensure polymophism works ok with reflection in webex.REQUEST_DISPATCHER.lookup_and_instantiate_handler
	local
		user_handler: ZENGARDEN_HANDLER
		simple_handler: TEST_HANDLER
	do
		PRECURSOR {REQUEST_DISPATCHER}
	end

feature -- parent deferred

--	pre_execute is
--			-- common tasks to be executed before starting process user request
--			-- if necessary, set 'processing_finished' tag and return_page to premature processing
--		do
--		end

--	post_execute is
--			-- common tasks to be executed after request processed
--		do
--		end



invariant
	invariant_clause: True

end -- class ZEN_DISPATCHER
