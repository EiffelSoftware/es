indexing
	description: "[
				Common interface for parsers of event log -files.
				]"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EVENT_PARSER

feature -- Access

	handler: EVENT_PARSER_HANDLER
			-- Handler for the parse - events.

	end_of_input: BOOLEAN
			-- Already read beyond the end of the input?
		do
			Result := input.end_of_input
		end

 	input: KI_TEXT_INPUT_STREAM
		-- Input where the parser reads from

	event_number: INTEGER is
			-- The number of the last treated event
		deferred end

	has_error: BOOLEAN
			-- Did an error occur when parsing the current line?

	error_message: STRING
			-- Message for the error (only valid if `has_error')

feature -- Status setting
	set_handler(a_handler: EVENT_PARSER_HANDLER)
		do
			handler := a_handler
		end

feature -- Basic operations

	parse_event
			-- Parse the next event.
		require
			handler_not_void: handler /= Void
			not_end_of_input: not end_of_input
		deferred
		end

invariant
	invariant_clause: True -- Your invariant here

end
