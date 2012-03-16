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
			create return_view.make(context.config.template)

			if context.command_string.is_equal ("notfound") then
				return_view.replace_marker_with_string ("ERROR_TITLE", "Request not found")
				return_view.replace_marker_with_string ("ERROR_DESCRIPTION", "404 Not Found - Request is not defined in application.")
			end

		end

feature {NONE} -- implementation

invariant
	invariant_clause: True -- Your invariant here

end
