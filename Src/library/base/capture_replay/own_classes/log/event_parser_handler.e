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

	has_error: BOOLEAN
			-- Has an error occurred?
		require
			parser_not_void: parser /= Void
		do
			Result := parser.has_error
		end

	error_message: STRING is
			-- Error message to the last error
		require
			has_error: has_error
		do
			Result := parser.error_message
		ensure
			result_not_void: Result /= Void
		end

	handle_incall_event(target: ENTITY; feature_name: STRING; arguments: DS_LIST[ENTITY])
			-- Handle an incall event (`target'.`feature_name'(`arguments')).
		deferred
		end

	handle_outcall_event(target: ENTITY; feature_name: STRING; arguments: DS_LIST[ENTITY])
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
