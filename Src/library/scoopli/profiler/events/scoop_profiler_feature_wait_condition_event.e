note
	description: "Wait condition try event."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_FEATURE_WAIT_CONDITION_EVENT

inherit
	SCOOP_PROFILER_FEATURE_EVENT

create
	make_now

feature -- Access

	code: STRING = "wait_condition"
			-- Event code

feature -- Visit

	visit (a_visitor: SCOOP_PROFILER_EVENT_VISITOR)
			-- Let `a_visitor` visit the current event.
		do
			a_visitor.visit_feature_wait_condition (Current)
		end

end
