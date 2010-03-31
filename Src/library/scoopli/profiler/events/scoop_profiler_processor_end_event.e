note
	description: "Processor end event, generated when disposing the processor."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_PROCESSOR_END_EVENT

inherit
	SCOOP_PROFILER_PROCESSOR_EVENT

create
	make_now

feature -- Access

	code: STRING = "end"
			-- Event code

feature -- Visit

	visit (a_visitor: SCOOP_PROFILER_EVENT_VISITOR)
			-- Let `a_visitor` visit the current event.
		do
			a_visitor.visit_processor_end (Current)
		end

end
