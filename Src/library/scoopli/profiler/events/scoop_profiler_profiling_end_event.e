note
	description: "Profiling end event, generated after flushing events to disk."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_PROFILING_END_EVENT

inherit
	SCOOP_PROFILER_PROFILING_EVENT

create
	make_now

feature -- Access

	code: STRING = "collection_end"
			-- Event code

feature -- Visit

	visit (a_visitor: SCOOP_PROFILER_EVENT_VISITOR)
			-- Let `a_visitor` visit the current event.
		do
			a_visitor.visit_profiling_end (Current)
		end

end
