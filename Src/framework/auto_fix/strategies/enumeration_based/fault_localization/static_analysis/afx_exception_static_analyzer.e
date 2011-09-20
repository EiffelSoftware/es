note
	description: "Summary description for {AFX_EXCEPTION_SPOT_ANALYZER_RANDOM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EXCEPTION_STATIC_ANALYZER

inherit

	AFX_SHARED_SESSION

	AFX_SHARED_STATIC_ANALYSIS_REPORT

	REFACTORING_HELPER

feature -- Basic operations

	analyze_exception (a_test_case: EPA_TEST_CASE_SIGNATURE; a_trace: STRING)
			-- Statically analyze an exception raised during execution of 'a_test_case',
			--		with 'a_trace' as the exception trace.
		local
			l_ranking: HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]
			l_collection: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			l_calculator: EPA_CONTROL_DISTANCE_CALCULATOR
			l_report: DS_HASH_TABLE [INTEGER, EPA_BASIC_BLOCK]
		do
			current_test_case := a_test_case
			set_exception_spot (create {AFX_EXCEPTION_SPOT}.make (a_test_case))
			exception_spot.set_trace (a_trace)

			analyze_failing_assertion

			analyze_state_predicates

				-- Calculate control distances from instructions to the point of exception, inside the recipient.
			calculate_control_distance (exception_spot.failing_assertion_break_point_slot)
		end

feature{NONE} -- Access

	current_test_case: EPA_TEST_CASE_SIGNATURE
			-- Test case under analysis.

	current_recipient_feature_with_context: EPA_FEATURE_WITH_CONTEXT_CLASS
			-- Recipient feature with context information.
		require
			exception_spot_attached: exception_spot /= Void
		do
			if current_recipient_feature_with_context_cache = Void then
				create current_recipient_feature_with_context_cache.make (exception_spot.recipient_, exception_spot.recipient_class_)
			end
			Result := current_recipient_feature_with_context_cache
		end

feature{NONE} -- Implementation

	analyze_failing_assertion
			-- Analyze and, more importantly, rewrite the violated assertion in the context of the recipient feature.
			-- Make the analysis result available in `exception_spot'.
		local
			l_rewriter: AFX_FAILING_ASSERTION_REWRITER
			l_spot: like exception_spot
		do
			l_spot := exception_spot

				-- Rewrite the violated assertion.
			create l_rewriter
			l_rewriter.rewrite (current_test_case, l_spot.recipient_ast_structure, l_spot.trace)

			l_spot.set_failing_assertion (l_rewriter.assertion)
			l_spot.set_original_failing_assertion (l_rewriter.original_assertion)
			l_spot.set_feature_of_failing_assertion (l_rewriter.feature_of_assertion)
			l_spot.set_class_of_feature_of_failing_assertion (l_rewriter.class_of_feature_of_assertion)
			l_spot.set_actual_arguments_in_failing_assertion (l_rewriter.actual_argument_expressions)
			l_spot.set_failing_assertion_break_point_slot (l_rewriter.assertion_break_point_slot)
			l_spot.set_target_expression_of_failing_feature (l_rewriter.target_expression)
		end

	analyze_state_predicates
			-- Gather expressions to monitor in the context of the recipient feature, which
			-- will be used to model the program states during executing the recipient feature.
			-- Register the expressions for later use.
		local
			l_feature_with_context: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_ranking: HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]
			l_ranking2: DS_HASH_SET [EPA_EXPRESSION]
			ll_ranking: DS_HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]
			l_basic_expr_gen: AFX_BASIC_STATE_EXPRESSION_GENERATOR
			l_implication_gen: AFX_IMPLICATION_GENERATOR
			l_imp_file: PLAIN_TEXT_FILE
			l_collector: AFX_BASIC_TYPE_EXPRESSION_CONSTRUCTOR
			l_base_expressions: EPA_HASH_SET [EPA_EXPRESSION]
		do
			l_feature_with_context := current_recipient_feature_with_context

			if config.is_using_model_based_strategy then
				create l_ranking.make (50)
				l_ranking.compare_objects

					-- Generate basic expressions such as argumentless boolean queries.
				create l_basic_expr_gen
				l_basic_expr_gen.generate (current_test_case.recipient_written_class, current_test_case.recipient_, l_ranking)

					-- Implications based on basic expressions.
				create l_implication_gen
				l_implication_gen.generate (current_test_case.recipient_written_class, current_test_case.recipient_, l_ranking)

				fixme ("Should stick with one set of container library.")
				create ll_ranking.make_equal (l_ranking.count)
				from l_ranking.start
				until l_ranking.after
				loop
					ll_ranking.force (l_ranking.item_for_iteration, l_ranking.key_for_iteration)
					l_ranking.forth
				end
			elseif config.is_using_random_based_strategy then
					-- Always monitor (sub-)expressions from the failing assertion.
				create l_base_expressions.make_equal (1)
				check failing_assertion_attached: exception_spot.failing_assertion /= Void end
				l_base_expressions.force (exception_spot.failing_assertion)
				l_base_expressions.merge ((create {AFX_SUB_EXPRESSION_SERVER}).sub_expressions (l_feature_with_context))

					-- Collect expressions to monitor.
				create l_collector
				l_collector.collect_from (l_feature_with_context.context_class, l_feature_with_context.feature_, l_base_expressions)
				l_ranking2 := l_collector.expressions_to_monitor
				create ll_ranking.make_equal (l_ranking2.count)
				from l_ranking2.start
				until l_ranking2.after
				loop
					ll_ranking.force (create {AFX_EXPR_RANK}.make ({AFX_EXPR_RANK}.Rank_basic), l_ranking2.item_for_iteration)
					l_ranking2.forth
				end
			else
				check should_not_happen: False end
			end

				-- Register the expressions to monitor for the recipient feature.
			set_expressions_to_monitor_for_feature (l_feature_with_context, ll_ranking)
		end

	calculate_control_distance (a_reference: INTEGER)
			-- Calculate the distances of instructions to `a_reference' breakpoint,
			-- in the context of `current_recipient_feature_with_context'.
			-- Save the result report in `control_distance_report'.
		require
			current_recipient_feature_with_context_attached: current_recipient_feature_with_context /= Void
			reference_valid: a_reference > 0
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_calculator: EPA_CONTROL_DISTANCE_CALCULATOR
			l_report: DS_HASH_TABLE [INTEGER, INTEGER]
			l_control_distance_report: AFX_CONTROL_DISTANCE_REPORT
		do
			to_implement ("Check if we need to adapt the breakpoint index from exception trace in the context of recipient body.")
			l_class := exception_spot.recipient_class_
			l_feature := exception_spot.recipient_
			create l_calculator.make
			l_calculator.calculate_within_feature (l_class, l_feature, a_reference)
			check is_successful: l_calculator.is_successful end
			l_report := l_calculator.last_report_concerning_bp_indexes
			fixme ("Return report object directly from the calculator.")
			create l_control_distance_report.make (l_class, l_feature, a_reference, l_report)
			set_control_distance_report (l_control_distance_report)
		end

feature{NONE} -- Implementation

	implication_file_path (a_tc: EPA_TEST_CASE_SIGNATURE): PLAIN_TEXT_FILE
			-- File which stores the possible implication candidates used
			-- in state model for the fault specified in `a_tc'.
		local
			l_file_name: FILE_NAME
		do
			create l_file_name.make_from_string (config.theory_directory)
			l_file_name.set_file_name (a_tc.id + ".implications")
			create Result.make (l_file_name)
		end

	store_implications_in_file (a_implications: DS_HASH_SET [AFX_IMPLICATION_EXPR]; a_file: PLAIN_TEXT_FILE)
			-- Store `a_implications' in `a_file'.
		local
			l_cursor: DS_HASH_SET_CURSOR [AFX_IMPLICATION_EXPR]
		do
			a_file.create_read_write
			from
				l_cursor := a_implications.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				a_file.put_string (l_cursor.item.text)
				a_file.put_character ('%N')
				l_cursor.forth
			end
			a_file.close
		end

	implications_from_file (a_tc: EPA_TEST_CASE_SIGNATURE; a_file: PLAIN_TEXT_FILE): EPA_STATE_SKELETON
			-- Implications loaded from `a_file' for test case `a_tc'
		local
			l_imps: LINKED_LIST [STRING]
			l_array: ARRAY [STRING]
			i: INTEGER
		do
			create l_imps.make
			a_file.open_read
			from
				a_file.read_line
			until
				a_file.after
			loop
				if not a_file.last_string.is_empty then
					l_imps.extend (a_file.last_string.twin)
				end
				a_file.read_line
			end
			a_file.close

			create l_array.make (1, l_imps.count)
			from
				i := 1
				l_imps.start
			until
				l_imps.after
			loop
				l_array.put (l_imps.item_for_iteration, i)
				i := i + 1
				l_imps.forth
			end

			Result := implications_for_class (l_array, a_tc.recipient_written_class, a_tc.recipient_)
		end

	implications_for_class (a_implications: ARRAY [STRING]; a_class: CLASS_C; a_feature: FEATURE_I): EPA_STATE_SKELETON
			-- Implications and their rankings for `a_class'
		local
			i: INTEGER
			l_expr: EPA_AST_EXPRESSION
		do
			create Result.make_basic (a_class, a_feature, a_implications.count)
			from
				i := a_implications.lower
			until
				i > a_implications.upper
			loop
				create l_expr.make_with_text (a_class, a_feature, a_implications.item (i), a_class)
				Result.force_last (l_expr)
				i := i + 1
			end
		end

	update_expressions_with_ranking (a_expressions: HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]; a_new_exprs: DS_HASH_SET [EPA_EXPRESSION]; a_ranking: INTEGER)
			-- Add `a_new_exprs' into `a_expressions' with `a_ranking' into `a_expression'.
			-- If some expression already in `a_expressions' but `a_ranking' is higher than the original ranking,
			-- update it with `a_ranking'.
		local
			l_expr: EPA_EXPRESSION
			l_rank: AFX_EXPR_RANK
		do
			fixme ("Copied from AFX_RELEVANT_STATE_EXPRESSION_GENERATOR. 28.11.2009 Jasonw")
			from
				a_new_exprs.start
			until
				a_new_exprs.after
			loop
				create l_rank.make ({AFX_EXPR_RANK}.rank_implication)
				l_expr := a_new_exprs.item_for_iteration
				if a_expressions.has (l_expr) then
					if a_expressions.item (l_expr) < l_rank then
						a_expressions.replace (l_rank, l_expr)
					end
				else
					a_expressions.put (l_rank, l_expr)
				end
				a_new_exprs.forth
			end
		end

feature{NONE} -- Implementation

	current_recipient_feature_with_context_cache: EPA_FEATURE_WITH_CONTEXT_CLASS
			-- Cache for `current_recipient_feature_with_context'.

end

