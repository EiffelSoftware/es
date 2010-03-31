note
	description: "Feature wait event, generated when the request is ready to be executed."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_FEATURE_WAIT_EVENT

inherit
	SCOOP_PROFILER_FEATURE_EVENT
		redefine
			make_now
		end

create
	make_now

feature {NONE} -- Creation

	make_now
			-- Creation procedure.
		do
			Precursor {SCOOP_PROFILER_FEATURE_EVENT}
			create requested_processor_ids.make
		ensure then
			requested_processor_ids /= Void
		end

feature -- Access

	code: STRING = "wait"
			-- Event code

	requested_processor_ids: LINKED_LIST [INTEGER]
			-- Requested processor ids

feature -- Visit

	visit (a_visitor: SCOOP_PROFILER_EVENT_VISITOR)
			-- Let `a_visitor` visit the current event.
		do
			a_visitor.visit_feature_wait (Current)
		end

invariant
	requested_processor_ids_not_void: requested_processor_ids /= Void

end
