indexing
	description: "Summary description for {SCOOP_WORKBENCH}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_WORKBENCH_ACCESS

feature -- Access

	scoop_workbench_objects: SCOOP_WORKBENCH_OBJECTS is
			-- Current scoop workbench
		once
			create Result.make
		ensure
			scoop_workbench_objects_not_void: Result /= Void
		end

	scoop_visitor_factory: SCOOP_VISITOR_FACTORY is
			-- A factory for visitors
		once
			create Result
		ensure
			scoop_workbench_objects_not_void: Result /= Void
		end

end
