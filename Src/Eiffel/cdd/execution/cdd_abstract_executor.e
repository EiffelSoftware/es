indexing
	description: "Objects that are used to execute cdd test cases"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CDD_ABSTRACT_EXECUTOR

feature {NONE} -- Initialization

	make_with_manager (a_manager: CDD_MANAGER) is
			-- Set `manager' to `a_manager'.
		require
			a_manager_not_void: a_manager /= Void
		do
			manager := a_manager
		ensure
			manager_set: manager = a_manager
		end

feature -- Access

	manager: CDD_MANAGER
			-- Manager responsible for running `Current'.

	can_execute: BOOLEAN is
			-- Can `Current' be executed?
		deferred
		end

	is_executing: BOOLEAN is
			-- Are we currently executing?
		deferred
		end


feature -- Measurement

feature -- Status report

feature -- Status setting

	execute is
			-- Run `Current'.
		require
			can_execute: can_execute
		deferred
		end

	stop is
			-- Stop current execution.
		deferred
		end

invariant
	manager_no_void: manager /= Void

end
