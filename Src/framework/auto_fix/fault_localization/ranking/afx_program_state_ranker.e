note
	description: "Summary description for {AFX_PROGRAM_STATE_RANKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_STATE_RANKER

inherit

	AFX_SHARED_DYNAMIC_ANALYSIS_REPORT

	AFX_SHARED_SESSION

	AFX_RANK_COMPUTATION_MEAN_TYPE_CONSTANT

	AFX_RANK_SORTER

	REFACTORING_HELPER

create
	default_create

feature -- Basic operation

	compute_ranks
			-- Compute ranks of program states according to statistics collected from traces.
			-- Make the result available in `fixing_target_list', sorted.
		require
			statistics_from_failing_attached: statistics_from_failing /= Void
			statistics_from_passing_attached: statistics_from_passing /= Void
		do
			compute_suspiciousness_values_of_targets

			if config.is_program_state_extended then
				-- In this case, we need to map the rankings of program state aspects
				--		to that of program state expressions.
				compute_suspiciousness_values_of_state_expressions
			end

			compute_ranks_of_state_expressions
			sort_ranking (fixing_target_list)
		end

	compute_ranks_of_state_expressions
			-- Compute and update the ranks of targets in `fixing_target_list'.
		local
			l_list_cursor: DS_ARRAYED_LIST_CURSOR [AFX_FIXING_TARGET]
			l_target: AFX_FIXING_TARGET
			l_max_control_distance, l_max_data_distance: INTEGER
		do
			from
				l_list_cursor := fixing_target_list.new_cursor
				l_list_cursor.start
			until
				l_list_cursor.after
			loop
				l_target := l_list_cursor.item

				compute_control_and_data_distance(l_target)
				if l_target.data_distance > l_max_data_distance then
					l_max_data_distance := l_target.data_distance
				end
				if l_target.control_distance > l_max_control_distance and then l_target.control_distance /= {EPA_CONTROL_DISTANCE_CALCULATOR}.Infinite_distance then
					l_max_control_distance := l_target.control_distance
				end

				l_list_cursor.forth
			end

			fixing_target_list.do_all (agent compute_rank_of_target (?, l_max_control_distance, l_max_data_distance))
		end

	compute_control_and_data_distance (a_target: AFX_FIXING_TARGET)
			-- Compute the control and data distance of the fixing target to the failure.
		local
			l_distances: TUPLE [control_relevance: INTEGER; data_relevance: INTEGER]
		do
			-- Compute control and data distance.
			static_distance_calculator.calculate_relevance (a_target)
			l_distances := static_distance_calculator.last_relevances
			a_target.set_data_distance (l_distances.data_relevance)
			a_target.set_control_distance (l_distances.control_relevance)
		end

	compute_rank_of_target (a_target: AFX_FIXING_TARGET; a_max_control_distance, a_max_data_distance: INTEGER)
			-- Compute the rank value, given `a_max_control_distance' and `a_max_data_distance'.
		require
			max_gt_zero: a_max_control_distance > 0 and then a_max_data_distance > 0
		local
			l_suspiciousness_contribution, l_data_distance_contribution, l_control_distance_contribution, l_rank: REAL_64
		do
			l_suspiciousness_contribution := a_target.suspiciousness_value
			l_data_distance_contribution := a_target.data_distance / a_max_data_distance

			-- Use a small enough value for zeros or negative numbers.
			if l_suspiciousness_contribution <= 0 then
				l_suspiciousness_contribution := 0.0001
			end

			if l_data_distance_contribution <= 0 then
				l_data_distance_contribution := 0.0001
			end

			if a_target.control_distance = {EPA_CONTROL_DISTANCE_CALCULATOR}.Infinite_distance then
				l_control_distance_contribution := 0.0001
			else
				l_control_distance_contribution := a_target.control_distance / a_max_control_distance
				if config.is_cfg_usage_optimistic then
					l_control_distance_contribution := 1 - l_control_distance_contribution
				end
				if l_control_distance_contribution <= 0 then
					l_control_distance_contribution := 0.0001
				end
			end

			inspect config.rank_computation_mean_type
			when Mean_type_arithmetic then
				l_rank := (l_suspiciousness_contribution + l_data_distance_contribution + l_control_distance_contribution) / 3
			when Mean_type_geometric then
				l_rank := (l_suspiciousness_contribution * l_data_distance_contribution * l_control_distance_contribution)
				l_rank := l_rank.power (1/3)
			when Mean_type_harmonic then
				l_rank := 1 / l_suspiciousness_contribution + 1 / l_data_distance_contribution + 1 / l_control_distance_contribution
				l_rank := 3 / l_rank
			end

			a_target.set_rank (l_rank.truncated_to_real)
		end


	static_distance_calculator: AFX_PROGRAM_STATE_STATIC_DISTANCE_CALCULATOR
			-- Shared static distance calculator.
		once
			create Result
		end


feature{NONE} -- Implementation

	compute_suspiciousness_values_of_targets
			-- Compute suspiciousness value of program states, and make the result
			--		available in `fixing_target_list'.
		require
			statistics_from_failing_attached: statistics_from_failing /= Void
			statistics_from_passing_attached: statistics_from_passing /= Void
		local
			l_failing_statistics_as_list: DS_ARRAYED_LIST [AFX_FIXING_TARGET]
			l_target_list: DS_ARRAYED_LIST [AFX_FIXING_TARGET]
			l_target: AFX_FIXING_TARGET
			l_failing_count, l_passing_count: INTEGER
			l_bp_index: INTEGER
			l_suspiciousness_value: REAL
			l_fixing_target: AFX_FIXING_TARGET
			l_expr_set: EPA_HASH_SET [AFX_FIXING_TARGET]
		do
			create l_target_list.make (100)

			l_failing_statistics_as_list := statistics_from_failing.as_list
			-- Pairs never hit in any failing execution would not be considered.
			from l_failing_statistics_as_list.start
			until l_failing_statistics_as_list.after
			loop
				l_target := l_failing_statistics_as_list.item_for_iteration
				l_bp_index := l_target.bp_index

				l_failing_count := l_target.suspiciousness_value.truncated_to_integer
				l_passing_count := statistics_from_passing.statistic_value (l_target).truncated_to_integer
				l_suspiciousness_value := suspiciousness_value (l_passing_count, l_failing_count)

				create l_fixing_target.make (l_target.expressions, l_target.bp_index, l_suspiciousness_value)
				l_target_list.force_last (l_fixing_target)

				l_failing_statistics_as_list.forth
			end

			set_fixing_target_list (l_target_list)
		end

	compute_suspiciousness_values_of_state_expressions
			-- Attribute program state aspect rankings to program state expressions,
			-- 		based on `fixing_target_list' where rankings of program state aspects are available.
		require
			fixing_target_list_attached: fixing_target_list /= Void
		local
			l_target_cursor: DS_ARRAYED_LIST_CURSOR [AFX_FIXING_TARGET]
			l_statistics_about_originates: AFX_EXECUTION_TRACE_STATISTICS
			l_target, l_new_target: AFX_FIXING_TARGET
			l_expr_set: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			l_expr: AFX_PROGRAM_STATE_EXPRESSION
			l_cursor: DS_HASH_SET_CURSOR [AFX_PROGRAM_STATE_EXPRESSION]
			l_originates: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			l_ranking_for_tuple: DS_LINKED_LIST [TUPLE [rank: REAL; expr: AFX_PROGRAM_STATE_EXPRESSION; bp_index: INTEGER]]
			l_ranking: DS_ARRAYED_LIST [AFX_FIXING_TARGET]
		do
			create l_statistics_about_originates.make_trace_unspecific (20)

			-- Compute ranking values for all ultimate originating program state expressions,
			--		based on the ranking values of program state aspects.
			from
				l_target_cursor := fixing_target_list.new_cursor
				l_target_cursor.start
			until
				l_target_cursor.after
			loop
				l_target := l_target_cursor.item

				-- Collect original expressions associated with the target.
				create l_originates.make (2)
				l_originates.set_equality_tester (breakpoint_unspecific_equality_tester)

				l_expr_set := l_target.expressions
				check only_one_target: l_expr_set.count = 1 end
				l_expr := l_expr_set.first
				check expr_of_boolean: l_expr /= Void and then l_expr.type.is_boolean end
				if l_expr.originate_expressions.count = 1 then
					-- For targets involving a single expression, use the original expression as the real fixing target.
					l_originates.append (l_expr.originate_expressions.first.ultimate_originate_expressions)
				else
					-- For targets involving more than one expression, we keep the expressions as they are.
					l_originates.append (l_expr.originate_expressions)
				end

				-- Use the original expressions as new targets.
				create l_new_target.make (l_originates, l_target.bp_index, l_target.suspiciousness_value)
				l_statistics_about_originates.update_statistic_info (l_new_target, l_target.suspiciousness_value,
						{AFX_EXECUTION_TRACE_STATISTICS_UPDATE_MODE}.Update_mode_replace, l_target)

				l_target_cursor.forth
			end

			set_fixing_target_list (l_statistics_about_originates.as_list)
		end

	suspiciousness_value (a_passing_count, a_failing_count: INTEGER): REAL
			-- Suspiciousness value based on the count of hits in passing and failing executions.
		require
			valid_counts: a_passing_count >= 0 and then a_failing_count >= 0
		local
			l_calculator: AFX_PROGRAM_STATE_SUSPICIOUSNESS_VALUE_CALCULATOR
		do
--			if config.*** then
				create l_calculator
				Result := l_calculator.suspiciousness_value (a_passing_count, a_failing_count)
--			end
		end


end
