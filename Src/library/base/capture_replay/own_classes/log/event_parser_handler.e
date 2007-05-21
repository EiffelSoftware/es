indexing
	description: "[
				Common interface for handlers of EVENT_PARSER - events.
				]"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EVENT_PARSER_HANDLER

feature -- Access

	parser: EVENT_PARSER

feature -- Basic operations

	set_parser(a_parser: EVENT_PARSER)
			--Create the event factory with parser `a_parser'
		require
			a_parser_not_void: a_parser /= Void
		do
			parser := a_parser
			parser.set_handler(Current)
		end

	handle_incall_event(target: ENTITY; feature_name: STRING; arguments: LIST[ENTITY])
			-- Handle an incall event (`target'.`feature_name'(`arguments')).
		deferred
		end

	handle_outcall_event(target: ENTITY; feature_name: STRING; arguments: LIST[ENTITY])
			-- Handle an outcall event (`target'.`feature_name'(`arguments'))
		deferred
		end

	handle_incallret_event(return_value: ENTITY)
			-- Handle an incallret event with return value `return_value'
		deferred
		end

	handle_outcallret_event(return_value: ENTITY)
			-- Handle an outcallret event with return value `return_value'
		deferred
		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here
end
