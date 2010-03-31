note
	description: "External call event, generated on caller processor."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_FEATURE_EXTERNAL_CALL_EVENT

inherit
	SCOOP_PROFILER_FEATURE_EVENT

create
	make_now

feature -- Access

	code: STRING = "external_call"
			-- Code of the event

	called_id: INTEGER
			-- Caller processor

	synchronous: BOOLEAN
			-- Is this a synchronous call?

feature -- Basic operations

	set_called_id (a_id: like called_id)
			-- Set `called_id` to `a_id`.
		require
			id_positive: a_id > 0
		do
			called_id := a_id
		ensure
			called_id_set: called_id = a_id
		end

	set_synchronous (a_sync: like synchronous)
			-- Set `synchronous` to `a_sync`.
		do
			synchronous := a_sync
		ensure
			synchronous_set: synchronous = a_sync
		end

feature -- Visit

	visit (a_visitor: SCOOP_PROFILER_EVENT_VISITOR)
			-- Let `a_visitor` visit the current event.
		do
			a_visitor.visit_feature_external_call (Current)
		end

invariant
	asynchronous_implies_different_called: not synchronous implies processor_id /= called_id

end
