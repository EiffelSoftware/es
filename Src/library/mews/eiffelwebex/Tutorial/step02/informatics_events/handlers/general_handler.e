indexing
	description: "handler for other general requests (aboutus, contacts... template based pages)"
	author: "Peizhu Li, <lip@student.ethz.ch>"
	date: "$05.02.2008$"
	revision: "$0.8.1$"

class
	GENERAL_HANDLER

inherit
	INFORMATICS_HANDLER
	APPLICATION_CONSTANTS

create
	make

feature -- process request

	handling_request is
			-- processing request - simply generate return page based on configured template, further updated by pre_process(), post_process() in INFORMATICS_HANDLER
		require else
			context /= void
		do
		end

feature {NONE} -- implementation

invariant
	invariant_clause: True -- Your invariant here

end
