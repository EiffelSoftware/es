note
	description: "Base class for Blackboard control strategies."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EBB_CONTROL

inherit

	EBB_SHARED_ALL

feature {NONE} -- Initialization

	make
			-- Initialize basic control.
		do
		end

feature -- Access

	name: STRING
			-- Name of control.
		deferred
		end

feature -- Basic operations

	create_new_tool_executions
			-- Create new tool executions to be run later.
		deferred
		end

end
