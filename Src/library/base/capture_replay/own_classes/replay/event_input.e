indexing
	description: "[
				Input that reads events from an EVENT_PARSER.
				]"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	EVENT_INPUT

inherit
	EVENT_PARSER_HANDLER

feature -- Access

	last_event: EVENT is
			-- The last read event.
		require
			not_end_of_input: not end_of_input
		do
			Result := internal_last_event
		ensure
			result_not_void: Result /= Void
		end

	end_of_input: BOOLEAN
			-- Already read beyond the last event?
		do
			Result := parser.end_of_input
		end

	event_number: INTEGER is
			-- Sequence number of `last_event'
		do
			Result := parser.event_number
		end


feature -- Basic operations

	read_next_event
			-- Read the next event.
		require
			parser_not_void: parser /= Void
			event_available: not parser.end_of_input
		do
				parser.parse_event
		end

	handle_incall_event(target: NON_BASIC_ENTITY; feature_name: STRING; arguments: DS_LIST[ENTITY])
			-- Create an incall event.
		do
			create {INCALL_EVENT}internal_last_event.make(target,feature_name,arguments)
		end

	handle_outcall_event(target: NON_BASIC_ENTITY; feature_name: STRING; arguments: DS_LIST[ENTITY])
			-- Create an outcall event.
		do
			create {OUTCALL_EVENT}internal_last_event.make(target, feature_name, arguments)
		end

	handle_incallret_event(return_value: ENTITY)
			-- Create an incallret event
		do
			create {INCALLRET_EVENT}internal_last_event.make(return_value)
		end

	handle_outcallret_event(return_value: ENTITY)
			-- Create an outcallret event
		do
			create {OUTCALLRET_EVENT}internal_last_event.make(return_value)
		end

feature {NONE} -- Implementation
	internal_last_event: EVENT
invariant
	invariant_clause: True

end
