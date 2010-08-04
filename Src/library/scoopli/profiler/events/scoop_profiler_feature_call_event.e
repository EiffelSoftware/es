note
	description: "Feature call event, generated on called processor."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_FEATURE_CALL_EVENT

inherit
	SCOOP_PROFILER_FEATURE_EVENT

create
	make_now

feature -- Access

	code: STRING = "call"
			-- Code of the event

	caller_id: INTEGER
			-- Caller processor id

	synchronous: BOOLEAN
			-- Is this a synchronous call?

feature -- Basic operations

	set_caller_id (a_id: like caller_id)
			-- Set `caller_id` to `a_id`.
		require
			id_positive: a_id > 0
		do
			caller_id := a_id
		ensure
			caller_id_set: caller_id = a_id
		end

	set_synchronous (a_sync: like synchronous)
			-- Set `synchronous` to `a_sync`.
		do
			synchronous := a_sync
		ensure
			synchronous_set: synchronous = a_sync
		end

	visit (a_visitor: SCOOP_PROFILER_EVENT_VISITOR)
			-- Let `a_visitor` visit the current event.
		do
			a_visitor.visit_feature_call (Current)
		end

invariant
	asynchronous_implies_different_caller: not synchronous implies processor_id /= caller_id

end
