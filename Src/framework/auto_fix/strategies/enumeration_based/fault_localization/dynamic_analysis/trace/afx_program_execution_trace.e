note
	description: "Summary description for {AFX_PROGRAM_STATE_TRACE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_EXECUTION_TRACE

inherit
	LINKED_LIST [AFX_PROGRAM_EXECUTION_STATE]

	AFX_SHARED_PROGRAM_STATE_EXPRESSION_EQUALITY_TESTER

create
	make_with_id

feature -- Initialization

	make_with_id (a_id: STRING)
			-- Initialize an execution trace with `a_id'.
		do
			make
			id := a_id
		end

feature -- Access

	id: STRING
			-- Execution trace id.

	execution_status: INTEGER
			-- Status of the execution related with current trace.

feature -- Trace interpretation

	interpretation: AFX_PROGRAM_EXECUTION_TRACE
			-- Interpret the current trace using the skeleton associated with each feature, and return the result trace.
		local
			l_state: AFX_PROGRAM_EXECUTION_STATE
		do
			create Result.make_with_id (id)
			if is_passing then
				Result.set_status_as_passing
			elseif is_failing then
				Result.set_status_as_failing
			end

			from start
			until after
			loop
				Result.force (item_for_iteration.interpretation)
				forth
			end
		end

feature -- Statistic

	statistics: AFX_EXECUTION_TRACE_STATISTICS
			-- Statistic based on current execution trace.
		local
			l_state: AFX_PROGRAM_EXECUTION_STATE
			l_statistic: AFX_EXECUTION_TRACE_STATISTICS
		do
			create Result.make_trace_specific (30, Current)
			from start
			until after
			loop
				l_state := item_for_iteration

				l_statistic := l_state.statistics
				Result.merge (l_statistic, {AFX_EXECUTION_TRACE_STATISTICS_UPDATE_MODE}.Update_mode_merge_presence)

				forth
			end
		end

feature -- Status report

	is_passing: BOOLEAN
			-- Is current trace corresponding to a passing test case?
		do
			Result := execution_status = Execution_passing
		end

	is_failing: BOOLEAN
			-- Is current trace corresponding to a failing test case?
		do
			Result := execution_status = Execution_failing
		end

feature -- Status set

	set_status_as_failing
			-- Set `execution_status' as `Execution_failing'.
		do
			execution_status := Execution_failing
		end

	set_status_as_passing
			-- Set `execution_status' as `Execution_passing'.
		do
			execution_status := Execution_passing
		end

feature -- Constant

	Execution_unknown: INTEGER = 0
	Execution_passing: INTEGER = 1
	Execution_failing: INTEGER = 2

end
