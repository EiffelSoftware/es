note
	description: "Summary description for {SCOOP_PROFILE_PROCESSOR_START_EVENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_PROCESSOR_START_EVENT

inherit
	SCOOP_PROFILER_PROCESSOR_EVENT

create
	make_now

feature -- Access

	code: STRING = "start"
			-- Event code

feature -- Visit

	visit (a_visitor: SCOOP_PROFILER_EVENT_VISITOR)
			-- Let `a_visitor` visit the current event.
		do
			a_visitor.visit_processor_start (Current)
		end

end
