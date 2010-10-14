note
	description: "Summary description for {AFX_ORIGINAL_EXPRESSION_RANKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_ORIGINAL_EXPRESSION_RANKER

inherit
	AFX_SHARED_PROGRAM_STATE_EXPRESSIONS_SERVER

create
	make

feature -- Initialization

	make (a_config: AFX_CONFIG)
			-- Initialization.
		do
			config := a_config
		end

feature -- Access

	config: AFX_CONFIG
			-- AutoFix configuration.

	exception_spot: AFX_EXCEPTION_SPOT assign set_exception_spot
			-- Exception spot where the expressions originate.

--	current_test_case_info: EPA_TEST_CASE_INFO assign set_current_test_case_info
--			-- Current test case info.

	extended_expression_ranking: DS_ARRAYED_LIST [TUPLE [INTEGER_32, EPA_EXPRESSION, REAL_32]] assign set_extended_expression_ranking
			-- Ranking of extended expression usages.

	ranking: DS_ARRAYED_LIST [TUPLE [INTEGER_32, EPA_EXPRESSION, REAL_32]]
			-- Ranking of the original expressions from program.
		do
			if ranking_cache = Void then
				create ranking_cache.make_default
			end

			Result := ranking_cache
		end

feature -- Basic operation

	compute_ranking
			-- Compute the ranking of each original expressions at each breakpoint index.
		require
			extended_expression_ranking_available: extended_expression_ranking /= Void
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_originals: DS_HASH_TABLE [EPA_PROGRAM_STATE_EXPRESSION, STRING]
			l_expression_table: DS_HASH_TABLE [EPA_PROGRAM_STATE_EXPRESSION, STRING]
			l_rank_table: DS_HASH_TABLE [DS_HASH_TABLE[REAL, EPA_PROGRAM_STATE_EXPRESSION], INTEGER]
			l_extended_table, l_original_table: DS_HASH_TABLE [EPA_PROGRAM_STATE_EXPRESSION, STRING]
		do
			if ranking_cache = Void then
				l_class := exception_spot.recipient_class_
				l_feature := exception_spot.recipient_
				l_expression_table := table_of_expressions (state_expression_server.expression_set (l_class, l_feature))

				l_rank_table := rank_table_for_originals (l_expression_table)

			end
		end

	store_rank_table_into_ranking (a_rank_table: DS_HASH_TABLE [DS_HASH_TABLE[REAL, EPA_PROGRAM_STATE_EXPRESSION], INTEGER])
			-- Store the ranking information in `a_rank_table' into `ranking', unsorted.
		local
			l_indx: INTEGER
			l_expr: EPA_PROGRAM_STATE_EXPRESSION
			l_rank: REAL
			l_table: DS_HASH_TABLE[REAL, EPA_PROGRAM_STATE_EXPRESSION]
		do
			from a_rank_table.start
			until a_rank_table.after
			loop
				l_indx := a_rank_table.key_for_iteration
				l_table := a_rank_table.item_for_iteration

				from l_table.start
				until l_table.after
				loop
					l_expr := l_table.key_for_iteration
					l_rank := l_table.item_for_iteration

					ranking.force_last ([l_indx, l_expr, l_rank])

					l_table.forth
				end
				a_rank_table.forth
			end
		end

	table_of_expressions (a_extended_expressions: DS_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION])
				:DS_HASH_TABLE [EPA_PROGRAM_STATE_EXPRESSION, STRING]
			-- Table of expressions.
			-- Key: text of an expression.
			-- Val: expression object.
		local
			l_expr: EPA_PROGRAM_STATE_EXPRESSION
			l_expr_text: STRING
			l_extended_table, l_original_table: DS_HASH_TABLE [EPA_PROGRAM_STATE_EXPRESSION, STRING]
		do
			create l_extended_table.make_equal (a_extended_expressions.count)

			from a_extended_expressions.start
			until a_extended_expressions.after
			loop
				l_expr := a_extended_expressions.item_for_iteration
				l_expr_text := l_expr.text

				-- Add expressions to text->expr table, preferring originate expressions to extended ones.
				if l_extended_table.has (l_expr_text) then
					if l_expr.originate_expressions.is_empty then
						l_extended_table.replace (l_expr, l_expr_text)
					end
				else
					l_extended_table.force (l_expr, l_expr_text)
				end

				a_extended_expressions.forth
			end

			Result := l_extended_table
		end

	rank_table_for_originals (a_expression_table: DS_HASH_TABLE [EPA_PROGRAM_STATE_EXPRESSION, STRING]): DS_HASH_TABLE [DS_HASH_TABLE[REAL, EPA_PROGRAM_STATE_EXPRESSION], INTEGER]
			-- Table of ranks for originals.
			-- Return: table of ranks for original expressions at different breakpoint slots.
		local
			l_extended_ranking: like extended_expression_ranking
			l_rank_tuple: TUPLE [indx: INTEGER_32; expr: EPA_EXPRESSION; rank: REAL_32]
		do
			create Result.make (20)

			l_extended_ranking := extended_expression_ranking
			from l_extended_ranking.start
			until l_extended_ranking.after
			loop
				l_rank_tuple := l_extended_ranking.item_for_iteration

				attribute_rank_to_originate_expression (Result, a_expression_table, l_rank_tuple)

				l_extended_ranking.forth
			end
		end

	attribute_rank_to_originate_expression (
					a_ranking_table: DS_HASH_TABLE [DS_HASH_TABLE[REAL, EPA_PROGRAM_STATE_EXPRESSION], INTEGER];
					a_extended_table: DS_HASH_TABLE [EPA_PROGRAM_STATE_EXPRESSION, STRING];
					a_rank_tuple: TUPLE [indx: INTEGER_32; expr: EPA_EXPRESSION; rank: REAL_32])
			-- Attribute the rank of an expression to its originate expression.
		local
			l_indx: INTEGER
			l_rank: REAL
			l_expr: EPA_EXPRESSION
			l_expr_text: STRING
			l_table: DS_HASH_TABLE [EPA_PROGRAM_STATE_EXPRESSION, STRING]
			l_ps_expr, l_orig_expr: EPA_PROGRAM_STATE_EXPRESSION
			l_originates: EPA_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION]
		do
			l_rank := a_rank_tuple.rank
			l_expr := a_rank_tuple.expr
			l_indx := a_rank_tuple.indx
			l_expr_text := l_expr.text

			if a_extended_table.has (l_expr_text)  then
				l_ps_expr := a_extended_table.item (l_expr_text)
				l_originates := l_ps_expr.originate_expressions

				-- Update ranks of all originate expressions.
				from l_originates.start
				until l_originates.after
				loop
					l_orig_expr := l_originates.item_for_iteration

					check l_orig_expr.originate_expressions.is_empty end
					update_ranking (a_ranking_table, l_indx, l_orig_expr, l_rank)

					l_originates.forth
				end
			end
		end

	update_ranking (a_ranking_table: DS_HASH_TABLE [DS_HASH_TABLE[REAL, EPA_PROGRAM_STATE_EXPRESSION], INTEGER];
					a_indx: INTEGER; a_expr: EPA_PROGRAM_STATE_EXPRESSION; a_rank: REAL)
			-- Update the ranking of `a_expr' at breakpoint `a_indx' in `a_ranking_table', using the new ranking `a_rank'.
		local
			l_table: DS_HASH_TABLE[REAL, EPA_PROGRAM_STATE_EXPRESSION]
			l_old_rank: REAL
		do
			if a_ranking_table.has (a_indx) then
				l_table := a_ranking_table.item (a_indx)
				if l_table.has (a_expr) then
					l_old_rank := l_table.item (a_expr)
					if l_old_rank < a_rank then
						l_table.replace (a_rank, a_expr)
					end
				else
					l_table.force (a_rank, a_expr)
				end
			else
				create l_table.make_equal (20)
				l_table.force (a_rank, a_expr)
				a_ranking_table.force (l_table, a_indx)
			end
		end

--	original_expressions (a_extended_expressions: DS_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION]): DS_HASH_TABLE [EPA_PROGRAM_STATE_EXPRESSION, STRING]
--			-- Original expressions from `a_extended_expressions'.
--			-- Key: text of an original expression.
--			-- Val: expression object of an original.
--			-- An expression is considered to be original, if its `originate_expressions' is empty.
--		local
--			l_expr: EPA_PROGRAM_STATE_EXPRESSION
--		do
--			create Result.make_equal (a_extended_expressions.count)
--			from a_extended_expressions.start
--			until a_extended_expressions.after
--			loop
--				l_expr := a_extended_expressions.item_for_iteration
--				if l_expr.originate_expressions.is_empty then
--					Result.force (l_expr, l_expr.text)
--				end
--				a_extended_expressions.forth
--			end
--		end

feature -- Status set

	reset_ranker
			-- Reset the internal state of the current ranker.
		do
			ranking_cache := Void
		end

--	set_current_test_case_info (a_test_case: like current_test_case_info)
--			-- Set `current_test_case_info'.
--		require
--			test_case_info_attached: a_test_case /= Void
--		do
--			current_test_case_info := a_test_case

--			reset_ranker
--		end

	set_exception_spot (a_spot: like exception_spot)
			-- Set `exception_spot'.
		require
			spot_attached: a_spot /= Void
		do
			exception_spot := a_spot

			reset_ranker
		end

	set_extended_expression_ranking (a_ranking: like extended_expression_ranking)
			-- Set `extended_expression_raning'.
		require
			ranking_attached: a_ranking /= Void
		do
			extended_expression_ranking := a_ranking

			reset_ranker
		end

feature{NONE} -- Cache

	ranking_cache: like ranking
			-- Cache for `ranking'.


end
