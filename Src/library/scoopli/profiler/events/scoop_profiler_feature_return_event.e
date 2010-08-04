note
	description: "Feature return event, generated after feature body execution."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_FEATURE_RETURN_EVENT

inherit
	SCOOP_PROFILER_FEATURE_EVENT

create
	make_now

feature -- Access

	code: STRING = "return"
			-- Event code

feature -- Visit

	visit (a_visitor: SCOOP_PROFILER_EVENT_VISITOR)
			-- Let `a_visitor` visit the current event.
		do
			a_visitor.visit_feature_return (Current)
		end

end
