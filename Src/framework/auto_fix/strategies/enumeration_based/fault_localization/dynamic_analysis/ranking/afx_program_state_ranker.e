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
			fixing_target_list.do_all (agent (a_target: AFX_FIXING_TARGET) do a_target.set_rank (a_target.suspiciousness_value) end)
--			sort_ranking (fixing_target_list)
			compute_ranks_of_state_expressions
			sort_ranking (fixing_target_list)
		end

	compute_ranks_of_state_expressions
			-- Compute and update the ranks of targets in `fixing_target_list'.
		local
			l_list_cursor: DS_ARRAYED_LIST_CURSOR [AFX_FIXING_TARGET]
			l_target: AFX_FIXING_TARGET
			l_max_control_distance: INTEGER
			l_max_data_distance: REAL_64
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

			if l_max_control_distance = 0 then
				l_max_control_distance := 1
			end
			if l_max_data_distance = 0 then
				l_max_data_distance := 1
			end
			fixing_target_list.do_all (agent compute_rank_of_target (?, l_max_control_distance, l_max_data_distance))
		end

	compute_control_and_data_distance (a_target: AFX_FIXING_TARGET)
			-- Compute the control and data distance of the fixing target to the failure.
		local
			l_distances: TUPLE [control_relevance: INTEGER; data_relevance: REAL_64]
		do
			-- Compute control and data distance.
			static_distance_calculator.calculate_relevance (a_target)
			l_distances := static_distance_calculator.last_relevances
			a_target.set_data_distance (l_distances.data_relevance)
			a_target.set_control_distance (l_distances.control_relevance)
		end

	compute_rank_of_target (a_target: AFX_FIXING_TARGET; a_max_control_distance: INTEGER; a_max_data_distance: REAL_64)
			-- Compute the rank value, given `a_max_control_distance' and `a_max_data_distance'.
		require
			max_gt_zero: a_max_control_distance > 0 and then a_max_data_distance > 0
		local
			l_suspiciousness_contribution, l_data_distance_contribution, l_control_distance_contribution, l_rank: REAL_64
			l_delta: REAL_64
		do
			l_delta := 0.000001

			l_suspiciousness_contribution := a_target.suspiciousness_value
			if l_suspiciousness_contribution <= 0 then
				l_suspiciousness_contribution := l_delta
			end
			check l_suspiciousness_contribution > 0 end

			if a_max_data_distance < l_delta then
				l_data_distance_contribution := l_delta
			else
				l_data_distance_contribution := a_target.data_distance / a_max_data_distance
				if l_data_distance_contribution <= 0 then
					l_data_distance_contribution := l_delta
				end
			end
			check l_data_distance_contribution > 0 end

			if a_target.control_distance = {EPA_CONTROL_DISTANCE_CALCULATOR}.Infinite_distance then
				l_control_distance_contribution := l_delta
			else
				if a_max_control_distance = 0 then
					l_control_distance_contribution := 1
				else
					l_control_distance_contribution := a_target.control_distance / a_max_control_distance
					if config.is_cfg_usage_optimistic then
						l_control_distance_contribution := 1 - l_control_distance_contribution
					end
					l_control_distance_contribution := (l_control_distance_contribution + l_delta) / 3
				end
--				if l_control_distance_contribution <= 0 then
--					l_control_distance_contribution := 0.0001
--				end
			end

			if config.is_using_arithmetic_mean then
				l_rank := (l_suspiciousness_contribution + l_data_distance_contribution + l_control_distance_contribution) / 3
			elseif config.is_using_geometric_mean then
				l_rank := (l_suspiciousness_contribution * l_data_distance_contribution * l_control_distance_contribution)
				l_rank := l_rank.power (1/3)
			elseif config.is_using_harmonic_mean then
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

				create l_fixing_target.make (l_target.expression, l_target.bp_index, l_suspiciousness_value)
				l_target_list.force_last (l_fixing_target)

				l_failing_statistics_as_list.forth
			end

			set_fixing_target_list (l_target_list)
		end

	suspiciousness_value (a_passing_count, a_failing_count: INTEGER): REAL
			-- Suspiciousness value based on the count of hits in passing and failing executions.
		require
			valid_counts: a_passing_count >= 0 and then a_failing_count >= 0
		do
			if config.is_using_strategy_heuristiciii_old then
				calculator_heuristicIII_old.set_test_case_numbers (trace_repository.number_of_passing_traces, trace_repository.number_of_failing_traces)
				calculator_heuristicIII_old.set_state_specific_numbers (a_passing_count, a_failing_count)
				calculator_heuristicIII_old.calculate_suspiciousness_value
				Result := calculator_heuristicIII_old.last_suspiciousness_value
			else
				check config.is_using_strategy_heuristiciii_new end
				calculator_heuristicIII_new.set_passing_count (a_passing_count)
				calculator_heuristicIII_new.set_failing_count (a_failing_count)
				calculator_heuristicIII_new.calculate_suspiciousness_value
				Result := calculator_heuristicIII_new.last_suspiciousness_value
			end
		end

	calculator_heuristicIII_old: AFX_PROGRAM_STATE_SUSPICIOUSNESS_VALUE_CALCULATOR_HEURISTICIII_OLD
			-- Suspiciousness value calculator using heuristicIII-old.
		once
			create Result
			-- Using the smallest alpha value from the paper (sec. 3.4.6) for the best result.
			Result.set_alpha (0.0001)
		end

	calculator_heuristicIII_new: AFX_PROGRAM_STATE_SUSPICIOUSNESS_VALUE_CALCULATOR_HEURISTICIII_NEW
			-- Suspiciousness value calculator using heuristicIII-old.
		once
			create Result
		end


end
