indexing
	description: "[
				Factory that generates events for the replay phase.
				]"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	EVENT_FACTORY

inherit
	EVENT_PARSER_HANDLER

feature -- Creation

feature -- Access

	last_event: EVENT

	after: BOOLEAN
		--no event left.

feature -- Basic operations



	create_next_event
		require
			parser_not_void: parser /= Void
			event_available: not parser.after
		do
			if not parser.after then
				parser.parse_event
				after := False
			else
				last_event := Void
				after := True
			end

		end

	handle_incall_event(target: NON_BASIC_ENTITY; feature_name: STRING; arguments: LIST[ENTITY])
		do
			create {INCALL_EVENT}last_event.make(target,feature_name,arguments)
		end

	handle_outcall_event(target: NON_BASIC_ENTITY; feature_name: STRING; arguments: LIST[ENTITY])
		do
			create {OUTCALL_EVENT}last_event.make(target, feature_name, arguments)
		end

	handle_incallret_event(return_value: ENTITY)
		do
			create {INCALLRET_EVENT}last_event.make(return_value)
		end

	handle_outcallret_event(return_value: ENTITY)
		do
			create {OUTCALLRET_EVENT}last_event.make(return_value)
		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True

end
