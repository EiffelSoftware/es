indexing
	description:
		"[
			Event handler which used to add proof events to the event service.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_EVENT_HANDLER

feature -- Access

	frozen event_context: UUID
			-- Proof event list context identifier
		once
			create Result.make_from_string ("E1FFE100-2357-1113-1719-232931374143")
		ensure
			result_attached: Result /= Void
			not_result_is_default: not Result.is_equal (create {UUID})
		end

feature -- Basic operations

	clear_events
			-- Clears display of any stored events.
		do
			service.prune_event_items (event_context)
		end

	add_proof_successful_event (a_class: CLASS_C; a_feature: FEATURE_I; a_milliseconds: NATURAL)
			-- Add a successful proof event.
		local
			l_event: EVENT_LIST_PROOF_SUCCESSFUL_ITEM
		do
			create l_event.make (a_class, a_feature)
			l_event.set_milliseconds_used (a_milliseconds)
			service.put_event_item (event_context, l_event)
		end

	add_proof_failed_event (a_class: CLASS_C; a_feature: FEATURE_I; a_error: EP_ERROR; a_milliseconds: NATURAL)
			-- Add a failed proof event.
		local
			l_event: EVENT_LIST_PROOF_FAILED_ITEM
		do
			create l_event.make (a_class, a_feature, a_error)
			l_event.set_milliseconds_used (a_milliseconds)
			service.put_event_item (event_context, l_event)
		end

	add_proof_skipped_event (a_class: CLASS_C; a_feature: FEATURE_I; a_reason: STRING)
			-- Add a skipped proof event.
		do
			service.put_event_item (event_context, create {EVENT_LIST_PROOF_SKIPPED_ITEM}.make (a_class, a_feature, a_reason))
		end

feature {NONE} -- Implementation

	service: EVENT_LIST_S
			-- Event service
		local
			l_consumer: SERVICE_CONSUMER [EVENT_LIST_S]
		once
			create l_consumer
			check l_consumer.is_service_available end
			Result := l_consumer.service
		end

end
