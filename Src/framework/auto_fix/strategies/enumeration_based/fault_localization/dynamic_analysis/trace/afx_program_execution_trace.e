note
	description: "Summary description for {AFX_PROGRAM_STATE_TRACE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_EXECUTION_TRACE

inherit
	LINKED_LIST [AFX_PROGRAM_EXECUTION_STATE]
		rename make as make_list
		redefine out
		end

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

	derived_trace (a_derived_skeleton: EPA_STATE_SKELETON; a_use_aspect: BOOLEAN): AFX_PROGRAM_EXECUTION_TRACE
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
				Result.force (item_for_iteration.derived_state (a_derived_skeleton, a_use_aspect))
				forth
			end
		end

	derived_compound_trace (a_feature_to_skeleton_map: DS_HASH_TABLE [EPA_STATE_SKELETON, AFX_FEATURE_TO_MONITOR]; a_use_aspect: BOOLEAN): AFX_PROGRAM_EXECUTION_TRACE
		local
			l_state: AFX_PROGRAM_EXECUTION_STATE
			l_feature: AFX_FEATURE_TO_MONITOR
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
				l_state := item_for_iteration
				create l_feature.make (l_state.state.feature_, l_state.state.class_)
				if a_feature_to_skeleton_map.has (l_feature) then
					Result.force (l_state.derived_state (a_feature_to_skeleton_map.item (l_feature), a_use_aspect))
				end
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

	out: STRING
		local
		do
			if out_cache = Void then
				create out_cache.make (1024)
				out_cache.append ("================================%N")
				out_cache.append ("Test case: " + test_case.name + "%N")
				out_cache.append ("Execution successful: " + (execution_status = Execution_passing).out + "%N")
				if exception_signature /= Void then
					out_cache.append ("Exception signature: " + exception_signature.id + "%N")
				end
				from start
				until after
				loop
					out_cache.append ("----------------------------%N")
					out_cache.append (item_for_iteration.out + "%N")
					forth
				end
			end
			Result := out_cache
		end

	out_cache: STRING

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
