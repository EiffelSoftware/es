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

	after: BOOLEAN
		do
			Result :=input.end_of_input
		end

 	input: KI_TEXT_INPUT_STREAM


feature -- Status setting
	set_handler(a_handler: EVENT_PARSER_HANDLER)
		do
			handler := a_handler
		end

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	parse_event
		require
			handler_not_void: handler /= Void
			not_after: not after
		deferred
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
