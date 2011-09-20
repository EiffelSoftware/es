note
	description: "Summary description for {AFX_EXPRESSIONS_TO_MONITOR_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EXPRESSIONS_TO_MONITOR_GENERATOR

inherit
	AFX_SHARED_SESSION

	AFX_SHARED_STATIC_ANALYSIS_REPORT

	AFX_SHARED_DYNAMIC_ANALYSIS_REPORT

feature -- Access

	last_expressions_to_monitor: DS_HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]
			-- Expressions to monitor from last generation.
		do
			if last_expressions_to_monitor_cache = Void then
				create last_expressions_to_monitor_cache.make_equal (30)
			end
			Result := last_expressions_to_monitor_cache
		end

feature -- Basic operation

	generate_for_feature (a_feature: EPA_FEATURE_WITH_CONTEXT_CLASS)
			-- Generate expressions to monitor for `a_feature'.
		require
			feature_attached: a_feature /= VOid
		local
			l_ranking: HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]
			l_basic_expr_gen: AFX_BASIC_STATE_EXPRESSION_GENERATOR
			l_implication_gen: AFX_IMPLICATION_GENERATOR
			l_base_expressions, l_expressions_to_monitor: EPA_HASH_SET [EPA_EXPRESSION]
			l_constructor: AFX_BASIC_TYPE_EXPRESSION_CONSTRUCTOR
			l_rank: AFX_EXPR_RANK
		do
			reset

			if config.is_using_model_based_strategy then
					-- Generate expressions and their rankings.
				create l_ranking.make (50)
				l_ranking.compare_objects
				create l_basic_expr_gen
				l_basic_expr_gen.generate (a_feature.written_class, a_feature.feature_, l_ranking)
				create l_implication_gen
				l_implication_gen.generate (a_feature.written_class, a_feature.feature_, l_ranking)

					-- Put into `last_expressions_to_monitor'.
				from
					l_ranking.start
				until
					l_ranking.after
				loop
					last_expressions_to_monitor.force (l_ranking.item_for_iteration, l_ranking.key_for_iteration)
					l_ranking.forth
				end

			elseif config.is_using_random_based_strategy then
				create l_base_expressions.make_equal (1)
					-- Sub-expressions from the recipient feature.
				l_base_expressions.merge ((create {AFX_SUB_EXPRESSION_SERVER}).sub_expressions (a_feature))
					-- Sub-expressions from the violated assertion.
				Sub_expression_collector.collect_from_ast (exception_recipient_feature, exception_signature.exception_condition_in_recipient.ast)
				l_base_expressions.merge (Sub_expression_collector.last_sub_expressions)

					-- Expressions to monitor.
				create l_constructor
				l_constructor.construct_from (l_base_expressions)
				l_expressions_to_monitor := l_constructor.last_constructed_expressions
					-- Expressions to monitor with rankings.
				from
					create l_rank.make ({AFX_EXPR_RANK}.rank_basic)
					l_expressions_to_monitor.start
				until
					l_expressions_to_monitor.after
				loop
					last_expressions_to_monitor.force (l_rank, l_expressions_to_monitor.item_for_iteration)
					l_expressions_to_monitor.forth
				end
			else
				check should_not_happen: False end
			end
		end

feature{NONE} -- Implementation

	reset
			-- Reset generator.
		do
			last_expressions_to_monitor_cache := Void
		end

	Sub_expression_collector: AFX_SUB_EXPRESSION_COLLECTOR
			-- Sub-expression collector.
		once
			create Result
			Result.set_should_collect_arguments (False)
			Result.set_should_collect_current (False)
			Result.set_should_collect_result (False)
		end

feature{NONE} -- Cache

	last_expressions_to_monitor_cache: DS_HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]
			-- Cache for `last_expressions_to_monitor'.

end
