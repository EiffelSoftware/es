note
	description: "Profiling start event, generated before flushing events to disk."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_PROFILING_START_EVENT

inherit
	SCOOP_PROFILER_PROFILING_EVENT

create
	make_now

feature -- Access

	code: STRING = "collection_start"
			-- Event code

feature -- Visit

	visit (a_visitor: SCOOP_PROFILER_EVENT_VISITOR)
			-- Let `a_visitor` visit the current event.
		do
			a_visitor.visit_profiling_start (Current)
		end

end
