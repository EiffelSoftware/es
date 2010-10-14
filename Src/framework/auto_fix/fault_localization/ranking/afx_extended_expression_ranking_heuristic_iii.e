note
	description: "Summary description for {AFX_FAULT_LOCALIZATION_HEURISTIC_III}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EXTENDED_EXPRESSION_RANKING_HEURISTIC_III

inherit
	AFX_EXECUTION_TRACE_ANALYZER

create
	make

feature{NONE} -- Initialization

	make (a_config: AFX_CONFIG)
			-- Initialization.
		do
			config := a_config
		end

feature -- Access

	config: AFX_CONFIG
			-- AutoFix configuration.

feature -- Basic operation

	compute_ranking
			-- <Precursor>
		local
			l_rank_values: like ranking
		do
			collect_number_of_hits (statistic_collection)

			compute_rank_values (number_of_hits_from_passing, number_of_hits_from_failing)
			sort_rank_values
		end

feature{NONE} -- Implementation

	collect_number_of_hits (a_statistic_collection: like statistic_collection)
			-- Collect the numbers of hits from all traces.
			-- Make the result available in `number_of_hits_from_passing' and `number_of_hits_from_failing'.
		require
			collection_not_empty: a_statistic_collection /= Void and then not a_statistic_collection.is_empty
		local
			l_statistic: AFX_EXECUTION_TRACE_STATISTIC
		do
			from a_statistic_collection.start
			until a_statistic_collection.after
			loop
				l_statistic := a_statistic_collection.item_for_iteration

				collect_number_of_hits_from_one_statistic (l_statistic)

				a_statistic_collection.forth
			end
		end

	compute_rank_values (a_numers_from_passing, a_numbers_from_failing: like number_of_hits_from_passing)
			-- Compute suspiciousness values of <expression, breakpoint> pairs according to their occurrences in passing and failing executions.
			-- Make the result values available in `ranking'.
		require
			ranking_empty: ranking.is_empty
		local
			l_bp_index: INTEGER
			l_expr: EPA_EXPRESSION
			l_failing_table, l_passing_table: DS_HASH_TABLE [REAL_32, EPA_EXPRESSION]
			l_passing_number, l_failing_number: REAL
			l_passing_count, l_failing_count: INTEGER
			l_rank_value: REAL
		do
			-- Pairs never hit in any failing execution would not be considered.
			from a_numbers_from_failing.start
			until a_numbers_from_failing.after
			loop
				l_bp_index := a_numbers_from_failing.key_for_iteration
				l_failing_table := a_numbers_from_failing.item_for_iteration

				from l_failing_table.start
				until l_failing_table.after
				loop
					l_expr := l_failing_table.key_for_iteration
					l_failing_number := l_failing_table.item_for_iteration

					l_failing_count := l_failing_number.truncated_to_integer
					l_passing_count := count_of_hits (l_expr, l_bp_index, number_of_hits_from_passing)

					l_rank_value := suspiciousness_value (l_passing_count, l_failing_count)

					ranking.force_last ([l_bp_index, l_expr, l_rank_value])

					l_failing_table.forth
				end

				a_numbers_from_failing.forth
			end
		end

	sort_rank_values
			-- Sort values in `ranking' in decreasing order of their suspiciousness values.
		local
			l_equality_tester: AGENT_BASED_EQUALITY_TESTER [TUPLE [INTEGER, EPA_EXPRESSION, REAL]]
			l_sorter: DS_QUICK_SORTER [TUPLE[INTEGER, EPA_EXPRESSION, REAL]]
		do
			create l_equality_tester.make (agent is_ranked_higher_than)
			create l_sorter.make (l_equality_tester)
			l_sorter.sort (ranking)
		end

	collect_number_of_hits_from_one_statistic (a_statistic: AFX_EXECUTION_TRACE_STATISTIC)
			-- Collect the numbers of hits from `a_statistic', and update `number_of_hits_from_passing' and `number_of_hits_from_failing'.
		require
			statistic_attached: a_statistic /= Void
		local
			l_is_passing, l_is_failing: BOOLEAN
			l_number_of_hits: like number_of_hits_from_passing
			l_bp_index: INTEGER
			l_table: DS_HASH_TABLE [REAL_32, EPA_EXPRESSION]
			l_expr: EPA_EXPRESSION
			l_number: REAL
		do
			l_is_passing := a_statistic.is_passing
			l_is_failing := a_statistic.is_failing
			if l_is_passing then
				l_number_of_hits := number_of_hits_from_passing
			elseif l_is_failing then
				l_number_of_hits := number_of_hits_from_failing
			else
				check should_not_happen: False end
			end

			-- Iterate through all <expression, breakpoint> pairs, and increase number of hits
			--		if the expression at the breakpoint was hit at least once.
			from a_statistic.start
			until a_statistic.after
			loop
				l_bp_index := a_statistic.key_for_iteration
				l_table := a_statistic.item_for_iteration
				from l_table.start
				until l_table.after
				loop
					l_expr := l_table.key_for_iteration
					l_number := l_table.item_for_iteration

					if l_number > 0 then
						increase_number_of_hits (l_number_of_hits, l_expr, l_bp_index)
					end

					l_table.forth
				end
				a_statistic.forth
			end
		end

	increase_number_of_hits (a_number_of_hits: like number_of_hits_from_passing; a_expr: EPA_EXPRESSION; a_bp_index: INTEGER)
			-- Increase the number of hits of <`a_expr', `a_bp_index'> by 1.
		require
			number_of_hits_attached: a_number_of_hits /= Void
			expr_attached: a_expr /= Void
		local
			l_table: DS_HASH_TABLE [REAL_32, EPA_EXPRESSION]
			l_number: REAL
		do
			if a_number_of_hits.has (a_bp_index) then
				l_table := a_number_of_hits.item (a_bp_index)
				if l_table.has (a_expr) then
					l_number := l_table.item (a_expr)
					l_number := l_number + 1
					l_table.replace (l_number, a_expr)
				else
					l_table.force (1.0, a_expr)
				end
			else
				create l_table.make_equal (20)
				l_table.force (1.0, a_expr)
				a_number_of_hits.force (l_table, a_bp_index)
			end
		end

	is_ranked_higher_than (a_rank1, a_rank2: TUPLE[bp_index: INTEGER; expr: EPA_EXPRESSION; rank: REAL]): BOOLEAN
			-- Is `a_rank1' ranked higher than `a_rank2', i.e. should `a_rank1' be placed before `a_rank2' in the list?
		do
			if a_rank1.rank > a_rank2.rank then
				Result := True
			elseif a_rank1.rank < a_rank2.rank then
				Result := False
			else
				if a_rank1.bp_index < a_rank2.bp_index then
					Result := True
				elseif a_rank1.bp_index > a_rank2.bp_index then
					Result := False
				else
					Result := a_rank1.expr.text < a_rank2.expr.text
				end
			end
		end

	suspiciousness_value (a_passing_count, a_failing_count: INTEGER): REAL
			-- Suspiciousness value based on the count of hits in passing and failing executions.
		require
			valid_counts: a_passing_count >= 0 and then a_failing_count >= 0
		local
			l_passing_weight, l_failing_weight: REAL_64
		do
			if a_passing_count = 0 then
				l_passing_weight := 0
			else
				l_passing_weight := Scale_factor_passing * (1 - Common_ratio_passing ^ a_passing_count) / (1 - Common_ratio_passing)
			end
			if a_failing_count = 0 then
				l_failing_weight := 0
			else
				l_failing_weight := Scale_factor_failing * (1 - Common_ratio_failing ^ a_failing_count) / (1 - Common_ratio_failing)
			end

			Result := (l_failing_weight - l_passing_weight).truncated_to_real
		end


	count_of_hits (a_expr: EPA_EXPRESSION; a_bp_index: INTEGER; a_number_table: like number_of_hits_from_passing): INTEGER
			-- Number of hits of <`a_expr', `a_bp_index'> according to `a_number_table'.
		require
			number_table_attached: a_number_table /= Void
			bp_index_valid: a_bp_index > 0
			expr_attached: a_expr /= Void
		local
		do
			if a_number_table.has (a_bp_index) and then attached a_number_table.item (a_bp_index) as lt_table then
				if lt_table.has (a_expr) then
					Result := lt_table.item (a_expr).truncated_to_integer
				end
			end
		end

feature{NONE} -- Access

	number_of_hits_from_passing: DS_HASH_TABLE [DS_HASH_TABLE [REAL_32, EPA_EXPRESSION], INTEGER_32]
			-- Number of hits of an expression at a breakpoint slot from all passing test cases.
		do
			if number_of_hits_from_passing_cache = VOid then
				create number_of_hits_from_passing_cache.make (10)
			end
			Result := number_of_hits_from_passing_cache
		end

	number_of_hits_from_failing: DS_HASH_TABLE [DS_HASH_TABLE [REAL_32, EPA_EXPRESSION], INTEGER_32]
			-- Number of hits of an expression at a breakpoint slot from all failing test cases.
		do
			if number_of_hits_from_failing_cache = VOid then
				create number_of_hits_from_failing_cache.make (10)
			end
			Result := number_of_hits_from_failing_cache
		end

feature -- Constant

	Scale_factor_passing: REAL = 0.66666
			-- Weight of the first hit in passing execution.

	Scale_factor_failing: REAL = 1.0
			-- Weight of the first hit in failing execution.

	Common_ratio_passing: REAL = 0.33333
			-- Weight ratio of a subsequent hit to a previous one in passing executions.

	Common_ratio_failing: REAL = 0.33333
			-- Weight ratio of a subsequent hit to a previous one in failing executions.

feature{NONE} -- Cache

	number_of_hits_from_passing_cache: like number_of_hits_from_passing
			-- Cache for `number_of_hits_from_passing'.

	number_of_hits_from_failing_cache: like number_of_hits_from_failing
			-- Cache for `number_of_hits_from_failing'.


end
