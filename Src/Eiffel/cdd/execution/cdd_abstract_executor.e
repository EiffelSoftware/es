indexing
	description: "Objects that are used to execute cdd test cases"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CDD_ABSTRACT_EXECUTOR

feature -- Access

	can_start: BOOLEAN is
			-- Can `Current' be executed?
		do
			Result := not is_executing
		end

	is_executing: BOOLEAN is
			-- Are we currently executing?
		deferred
		end

feature -- Status setting

	start is
			-- Run `Current'.
		require
			can_start: can_start
		deferred
		end

	stop is
			-- Stop current execution.
		deferred
		end

end
