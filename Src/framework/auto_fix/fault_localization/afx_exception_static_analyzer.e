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

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize.
		do
		end

feature -- Basic operations

	analyze_exception (a_test_case: EPA_TEST_CASE_INFO; a_trace: STRING)
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

			-- Calculate control distances from instructions to the point of exception, inside the recipient.
			calculate_control_distance (exception_spot.recipient_class_, exception_spot.recipient_, exception_spot.failing_assertion_break_point_slot)

--			analyze_state_predicates (current_test_case, exception_spot)

			-- Register the expressions at `exception_spot'.
			-- Both `hash_code' and `is_equal' have been redefined in {EPA_PROGRAM_STATE_EXPRESSION},
			--		therefore, program state expressions can be used directly in `exception_spot'.`ranking' and `exception_spot'.`skeleton'.
--			exception_spot.set_ranking (ranking_in_control_distance (l_collection, l_report))

--			-- Initialize `exception_spot'.`skeleton' using empty ranking information.
--			-- Use a more specific tester, since we are storing {EPA_PROGRAM_STATE_EXPRESSION} objects in the skeleton.
--			exception_spot.set_ranking (create {HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]}.make (10))
--			exception_spot.skeleton.set_equality_tester (create {EPA_PROGRAM_STATE_EXPRESSION_EQUALITY_TESTER})

		end

feature{NONE} -- Implementation

	current_test_case: EPA_TEST_CASE_INFO
			-- Test case under analysis.

	calculate_control_distance (a_class: CLASS_C; a_feature: FEATURE_I; a_reference: INTEGER)
			-- Calculate the distances of instructions to `a_reference' breakpoint, in `a_class'.`a_feature'.
			-- The resulting report is available in `control_distance_report'.
		require
			context_attached: a_class /= Void and then a_feature /= Void
			reference_valid: a_reference > 0
		local
			l_calculator: EPA_CONTROL_DISTANCE_CALCULATOR
			l_report: DS_HASH_TABLE [INTEGER, INTEGER]
			l_control_distance_report: AFX_CONTROL_DISTANCE_REPORT
		do
			create l_calculator.make
			to_implement ("Check if we need to adapt the breakpoint index from exception trace in the context of recipient body.")
			l_calculator.calculate_within_feature (a_class, a_feature, a_reference)
			check is_successful: l_calculator.is_successful end
			l_report := l_calculator.last_report_concerning_bp_indexes
			create l_control_distance_report.make (a_class, a_feature, a_reference, l_report)
			set_control_distance_report (l_control_distance_report)
		end

	ranking_in_control_distance (a_expression_set: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]; a_report: DS_HASH_TABLE [INTEGER, EPA_BASIC_BLOCK]): HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]
			-- List of ranking for expressions from `a_expression_set', on the basis of control distances from such expressions to the exception location.
		local
			l_collection: HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]
			l_exp: AFX_PROGRAM_STATE_EXPRESSION
			l_rank: AFX_EXPR_RANK
			l_done: BOOLEAN
			l_index: INTEGER
		do
			create l_collection.make (a_expression_set.count)
			l_collection.compare_objects

			from a_expression_set.start
			until a_expression_set.after
			loop
				l_exp := a_expression_set.item_for_iteration
				l_index := l_exp.breakpoint_slot

				-- Rank an expression based on it's control distance to the exception point, as recorded in `a_report'.
				from
					a_report.start
					l_done := False
				until
					l_done or else a_report.after
				loop
					if a_report.key_for_iteration.asts.first.breakpoint_slot = l_index then
						create l_rank.make (a_report.item_for_iteration)
						l_done := True
					end
					a_report.forth
				end
				check l_done end

				l_collection.force (l_rank, l_exp)

				a_expression_set.forth
			end

			Result := l_collection
		end

	analyze_failing_assertion
			-- Analyze failing assertion of the exception, and save the information into `a_spot'.
		local
			l_rewriter: AFX_FAILING_ASSERTION_REWRITER
			l_spot: like exception_spot
		do
			l_spot := exception_spot

			 -- Failing assertion rewritting
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

end

--	analyze (a_tc: EPA_TEST_CASE_INFO; a_dm: DEBUGGER_MANAGER)
--			-- Generate `exception_spot' for text case `a_tc' in the context
--			-- given by the debugger `a_dm'.			
--		do
--			create exception_spot.make (a_tc)
--			exception_spot.set_trace (a_dm.application_status.exception_text)

--			-- Use a more specific tester, since we are storing {EPA_PROGRAM_STATE_EXPRESSION} objects in the skeleton.
--			exception_spot.skeleton.set_equality_tester (create {EPA_PROGRAM_STATE_EXPRESSION_EQUALITY_TESTER})

----			collect_program_state_expressions (a_tc, exception_spot)

----				-- Analyze different aspects of the failure.
------			analyze_state_predicates (a_tc, a_dm, exception_spot)
----			analyze_ast_structure (a_tc, a_dm, exception_spot)
----			analyze_failing_assertion (a_Tc, a_dm, exception_spot.recipient_ast_structure, exception_spot)
--		end


