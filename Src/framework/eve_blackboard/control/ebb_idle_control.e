note
	description: "Blackboard control which doesn't do anything."
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_IDLE_CONTROL

inherit

	EBB_CONTROL

create
	make

feature -- Access

	name: STRING = "Idle"
			-- <Precursor>

feature -- Basic operations

	create_new_tool_executions
			-- <Precursor>
		do
		end

	start_waiting_tool_executions
			-- <Precursor>
		do
			if running_executions.is_empty and not waiting_executions.is_empty then
				start_tool_execution (waiting_executions.first)
			end
		end

end
