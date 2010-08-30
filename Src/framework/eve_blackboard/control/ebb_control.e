note
	description: "Base class for Blackboard control strategies."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EBB_CONTROL

inherit

	ROTA_TIMED_TASK_I

	EBB_SHARED_ALL

feature {NONE} -- Initialization

	make
			-- Initialize basic control.
		do
			create waiting_executions.make
			create running_executions.make
			create finished_executions.make

			sleep_time := 500
		ensure
			not_running: not is_running
		end

feature -- Access

	name: STRING
			-- Name of control.
		deferred
		end

	waiting_executions: LINKED_LIST [EBB_TOOL_EXECUTION]
			-- Tool executions waiting to be started.

	running_executions: LINKED_LIST [EBB_TOOL_EXECUTION]
			-- Tool executions running at the moment.

	finished_executions: LINKED_LIST [EBB_TOOL_EXECUTION]
			-- Tool executions that finished.

	sleep_time: NATURAL
			-- <Precursor>

feature -- Status report

	is_interface_usable: BOOLEAN = True
			-- <Precursor>

	has_next_step: BOOLEAN
			-- <Precursor>
		do
			Result := internal_is_active or not running_executions.is_empty
		end

	is_running: BOOLEAN
			-- Is control running at the moment?
		do
			Result := internal_is_active
		end

feature -- Status setting

	start
			-- Start task.
		do
			internal_is_active := True
		ensure
			has_next_step: has_next_step
		end

	cancel
			-- <Precursor>
		do
			internal_is_active := False
		end

feature -- Basic operations

	step
			-- <Precursor>
		do
			if not running_executions.is_empty then
				check_running_tool_executions
			end
			if internal_is_active then
				create_new_tool_executions
				if not waiting_executions.is_empty then
					start_waiting_tool_executions
				end
			end
		end

	check_running_tool_executions
			-- Check running tools and move them to finished list if necessary.
		require
			has_running_execution: not running_executions.is_empty
		local
			l_execution: EBB_TOOL_EXECUTION
		do
			from
				running_executions.start
			until
				running_executions.after
			loop
				l_execution := running_executions.item
				if not l_execution.is_running and not l_execution.is_finished then
					l_execution.set_finished
				end
				if l_execution.is_finished then
					finished_executions.put_front (l_execution)
					running_executions.remove
					blackboard.tool_execution_changed_event.publish ([])
				else
					running_executions.forth
				end
			end
		end

	create_new_tool_executions
			-- Create new tool executions to be run later.
		deferred
		end

	start_waiting_tool_executions
			-- Start waiting tool executions.
		require
			has_waiting_execution: not waiting_executions.is_empty
		deferred
		end

	start_tool_execution (a_execution: EBB_TOOL_EXECUTION)
			-- Start `a_execution' and move it to the running list.
		do
			if waiting_executions.has (a_execution) then
				waiting_executions.prune_all (a_execution)
			end

			a_execution.start

			running_executions.extend (a_execution)
			blackboard.tool_execution_changed_event.publish ([])
		ensure
			not_waiting: not waiting_executions.has (a_execution)
			executing: running_executions.has (a_execution)
		end

	handle_changed_class (a_class: CLASS_I)
			-- Handle fact that `a_class' changed.
		local
			l_execution: EBB_TOOL_EXECUTION
			l_input: EBB_TOOL_INPUT
			l_class_overlap: BOOLEAN
		do
			across running_executions as l_cursor loop
				l_execution := l_cursor.item
				if l_execution.is_running then
					l_input := l_execution.input
					l_class_overlap := across l_input.features as l_features some l_features.item.written_class.name.is_equal (a_class.name) end
					if l_class_overlap then
						l_execution.cancel
					end
				end
			end
		end

feature {NONE} -- Implementation

	internal_is_active: BOOLEAN
			-- Is control active?

invariant
	consistent_waiting: across waiting_executions as c all not c.item.is_running and not c.item.is_finished end
	consistent_running: across running_executions as c all c.item.is_running xor c.item.is_finished end
	consistent_finished: across finished_executions as c all not c.item.is_running and c.item.is_finished end

end
