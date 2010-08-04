note
	description: "Feature application event, generated before the execution of the body."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_FEATURE_APPLICATION_EVENT

inherit
	SCOOP_PROFILER_FEATURE_EVENT

create
	make_now

feature -- Access

	code: STRING = "application"
			-- Code of the event

feature -- Basic operations

	visit (a_visitor: SCOOP_PROFILER_EVENT_VISITOR)
			-- Let `a_visitor` visit the current event.
		do
			a_visitor.visit_feature_application (Current)
		end

end
