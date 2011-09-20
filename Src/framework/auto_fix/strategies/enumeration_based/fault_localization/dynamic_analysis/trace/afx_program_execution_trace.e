note
	description: "Summary description for {AFX_PROGRAM_STATE_TRACE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_EXECUTION_TRACE

inherit
	LINKED_LIST [AFX_PROGRAM_EXECUTION_STATE]
		rename make as make_list end

create
	make

feature -- Initialization

	make (a_tc: EPA_TEST_CASE_INFO)
			-- Initialize an execution trace for `a_tc'.
		do
			make_list
			test_case := a_tc
		end

feature -- Access

	test_case: EPA_TEST_CASE_INFO
			-- Test case of the trace.

	execution_status: NATURAL
			-- Status of the execution related with current trace.

	exception_signature: AFX_EXCEPTION_SIGNATURE assign set_exception_signature
			-- Exception signature in case of a failing execution.

feature -- Trace interpretation

	derived_trace (a_derived_skeleton: EPA_STATE_SKELETON): AFX_PROGRAM_EXECUTION_TRACE
			-- Trace derived from the current, based on `a_derived_skeleton'.
		do
			create Result.make (test_case)
			if is_passing then
				Result.set_status_as_passing
			elseif is_failing then
				Result.set_status_as_failing
			end

			from start
			until after
			loop
				Result.force (item_for_iteration.derived_state (a_derived_skeleton))
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
			-- Set the trace status as failing.
		do
			execution_status := Execution_failing
		end

	set_status_as_passing
			-- Set the trace status as passing.
		do
			execution_status := Execution_passing
		end

	set_exception_signature (a_signature: AFX_EXCEPTION_SIGNATURE)
			-- Set `exception_signature'.
		do
			exception_signature := a_signature
		end

feature -- Constant

	Execution_unknown: NATURAL = 0
	Execution_passing: NATURAL = 1
	Execution_failing: NATURAL = 2

end
