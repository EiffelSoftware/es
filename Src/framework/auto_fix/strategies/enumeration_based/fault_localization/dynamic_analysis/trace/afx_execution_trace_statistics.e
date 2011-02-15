note
	description:
		"[
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EXECUTION_TRACE_STATISTICS

inherit
	DS_HASH_TABLE [EPA_HASH_SET [AFX_FIXING_TARGET], INTEGER]

	AFX_EXECUTION_TRACE_STATISTICS_UPDATE_MODE

	AFX_SHARED_FIXING_TARGET_EQUALITY_TESTER

create
	make_trace_specific, make_trace_unspecific

feature -- Initialization

	make_trace_specific (a_size: INTEGER; a_trace: AFX_PROGRAM_EXECUTION_TRACE)
			-- Initialization.
		require
			size_valid: a_size > 0
			trace_attached: a_trace /= Void
		do
			make_trace_unspecific (a_size)
			trace := a_trace
		end

	make_trace_unspecific (a_size: INTEGER)
			-- Initialization.
		require
			size_valid: a_size > 0
		do
			make (a_size)
		end

feature -- Access

	trace: AFX_PROGRAM_EXECUTION_TRACE
			-- Trace from which the statistics is produced.

	id: STRING
			-- Id of the associated trace.
		require
			is_trace_specific: is_trace_specific
		do
			Result := trace.id
		end

feature -- Status report

	is_trace_specific: BOOLEAN
			-- Is current statistic specific to a particular trace?
		do
			Result := trace /= Void
		end

	is_passing: BOOLEAN
			-- Is current statistic for a passing execution?
		require
			is_trace_specific: is_trace_specific
		do
			Result := trace.is_passing
		end

	is_failing: BOOLEAN
			-- Is current statistic for a failing execution?
		require
			is_trace_specific: is_trace_specific
		do
			Result := trace.is_failing
		end

feature -- Basic operation

	statistic_value (a_target: AFX_FIXING_TARGET): REAL
			-- Statistic value regarding the fixing target `a_target'.
			-- If no data available, return 0.
		local
			l_bp_index: INTEGER
			l_set: EPA_HASH_SET [AFX_FIXING_TARGET]
			l_target: AFX_FIXING_TARGET
			l_found: BOOLEAN
		do
			l_bp_index := a_target.bp_index
			if has (l_bp_index) then
				l_set := item (l_bp_index)
				from l_set.start
				until l_found or else l_set.after
				loop
					l_target := l_set.item_for_iteration

					if l_target.is_about_the_same_target (a_target) then
						Result := l_target.suspiciousness_value
						l_found := True
					end

					l_set.forth
				end
			end
		end

	update_statistic_info (a_target: AFX_FIXING_TARGET; a_change: REAL; a_update_mode: INTEGER; a_cond: AFX_FIXING_TARGET)
			-- Update the statistic information for `a_target'.
			-- Applying `a_change' to the statistic value of `a_target', according to `a_update_mode'.
			-- Adopt `a_cond' as the most relevant fixing condition, if it is more relevant than the one already in statistic.
		require
			valid_mode: is_valid_update_mode (a_update_mode)
		local
			l_bp_index: INTEGER
			l_set: EPA_HASH_SET [AFX_FIXING_TARGET]
			l_found: BOOLEAN
			l_target: AFX_FIXING_TARGET
			l_table: DS_HASH_TABLE [REAL_32, AFX_PROGRAM_STATE_EXPRESSION]
			l_number: REAL
		do
			l_bp_index := a_target.bp_index
			if has (l_bp_index) then
				l_set := item (l_bp_index)
				from l_set.start
				until l_set.after or else l_found
				loop
					l_target := l_set.item_for_iteration

					if l_target.is_about_the_same_target (a_target) then
						l_target.set_suspiciousness_value (statistic_value_after_update (l_target.suspiciousness_value, a_change, a_update_mode))
						l_target.update_most_relevant_fixing_condition (a_cond)
						l_found := True
					end

					l_set.forth
				end
			else
				create l_set.make (10)
				l_set.set_equality_tester (tester_based_on_expressions_and_bp_index)
				force (l_set, l_bp_index)
			end

			if not l_found then
				create l_target.make (a_target.expressions, l_bp_index, statistic_value_after_update (0, a_change, a_update_mode))
				l_target.update_most_relevant_fixing_condition (a_cond)
				l_set.force (l_target)
			end
		end

	merge (a_statistic: like Current; a_merge_mode: INTEGER)
			-- Merge the statistic data into the Current, using mode `a_merge_mode'.
			-- Other information of the current statistic, like `trace', is not affected.
		require
			merge_mode_valid: is_valid_merge_mode (a_merge_mode)
			statistic_attached: a_statistic /= Void
		local
			l_list: DS_ARRAYED_LIST [AFX_FIXING_TARGET]
			l_target: AFX_FIXING_TARGET
			l_table_src, l_table_dest: DS_HASH_TABLE [REAL, AFX_PROGRAM_STATE_EXPRESSION]
			l_entry: TUPLE [rank: REAL; expr: AFX_PROGRAM_STATE_EXPRESSION; index: INTEGER]
			l_current_rank, l_delta_rank, l_new_rank: REAL
		do
			l_list := a_statistic.as_list
			from l_list.start
			until l_list.after
			loop
				l_target := l_list.item_for_iteration

				update_statistic_info (l_target, l_target.suspiciousness_value, a_merge_mode, l_target.most_relevant_fixing_condition)

				l_list.forth
			end
		end

feature -- Transformation

	as_list: DS_ARRAYED_LIST [AFX_FIXING_TARGET]
			-- Statistic data as a list.
		local
			l_set: EPA_HASH_SET [AFX_FIXING_TARGET]
		do
			create Result.make (100)
			from start
			until after
			loop
				l_set := item_for_iteration

				l_set.do_all (agent Result.force_last)

				forth
			end
		ensure
			result_attached: Result /= Void
		end

feature{NONE} -- Implementation

	statistic_value_after_update (a_old_value, a_change: REAL; a_update_mode: INTEGER): REAL
			-- Statistic value of `a_old_value' after applying `a_change', in `a_update_mode'.
		do
			if a_update_mode = Update_mode_replace then
				Result := a_change
			elseif a_change > 0 then
				if a_update_mode = Update_mode_merge_presence then
					Result := a_old_value + 1
				elseif a_update_mode = Update_mode_merge_occurrence then
					Result := a_old_value + a_change
				end
			end
		end

end
