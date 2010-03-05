note
	description: "Objects that represent action to perform during program execution monitoring"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_MONITORING_ACTION

feature -- Access

	location: EPA_PROGRAM_LOCATION
			-- Location associated with Current action

feature -- Status report

	is_enabled: BOOLEAN
			-- Is current action enabled?
			-- If False, `execute' will not happen even if `location' is reached
			-- during program execution.
		deferred
		end

feature -- Basic operation

	execute
			-- Execute Current action.
		deferred
		end

end
