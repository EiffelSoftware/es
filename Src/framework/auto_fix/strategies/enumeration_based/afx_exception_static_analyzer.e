note
	description: "Summary description for {AFX_EXCEPTION_SPOT_ANALYZER_RANDOM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EXCEPTION_STATIC_ANALYZER

inherit

	AFX_SHARED_PROGRAM_STATE_EXPRESSIONS_SERVER

	REFACTORING_HELPER

create
	make

feature{NONE} -- Initialization

	make (a_config: like config)
			-- Initialize.
		do
			config := a_config
		end

feature -- Access

	last_spot: AFX_EXCEPTION_SPOT
			-- Last analyzed exception spot

	config: AFX_CONFIG
			-- Config for current AutoFix session

feature -- Basic operations

	analyze_exception (a_test_case: EPA_TEST_CASE_INFO; a_trace: STRING)
			-- Statically analyze an exception raised during execution of 'a_test_case',
			--		with 'a_trace' as the exception trace.
		local
			l_ranking: HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]
			l_collection: EPA_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION]
			l_calculator: EPA_CONTROL_DISTANCE_CALCULATOR
			l_report: DS_HASH_TABLE [INTEGER, EPA_BASIC_BLOCK]
		do
			current_test_case := a_test_case
			create last_spot.make (a_test_case)
			last_spot.set_trace (a_trace)

			-- Calculate control distances from instructions to the point of exception, inside the recipient.
			create l_calculator.make
			to_implement ("Check if we need to adapt the breakpoint index from exception trace in the context of recipient body.")
			l_calculator.calculate_within_feature (last_spot.recipient_class_, last_spot.recipient_, last_spot.test_case_breakpoint_slot)
			check is_successful: l_calculator.is_successful end
			l_report := l_calculator.last_report

			analyze_state_predicates (current_test_case, last_spot)

			-- Collect all program state expressions for the recipient feature.
--			l_collection := program_state_expressions

			-- Register the expressions at `last_spot'.
			-- Both `hash_code' and `is_equal' have been redefined in {EPA_PROGRAM_STATE_EXPRESSION},
			--		therefore, program state expressions can be used directly in `last_spot'.`ranking' and `last_spot'.`skeleton'.
--			last_spot.set_ranking (ranking_in_control_distance (l_collection, l_report))

--			create l_ranking.make (l_collection.count)
--			l_ranking.compare_objects
--			l_collection.do_all (
--					agent (a_exp: EPA_PROGRAM_STATE_EXPRESSION; a_ranking: HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]; a_report: DS_HASH_TABLE [INTEGER, EPA_BASIC_BLOCK])
--						local
--							l_rank: AFX_EXPR_RANK
--							l_done: BOOLEAN
--							l_index: INTEGER
--						do
--							l_index := a_exp.breakpoint_slot
--							from a_report.start
--							until l_done or else a_report.after
--							loop
--								if a_report.key_for_iteration.block_number = l_index then
--									create l_rank.make (a_report.item_for_iteration)
--									l_done := True
--								end
--								a_report.forth
--							end
--							check l_done end
--							a_ranking.force (l_rank, a_exp)
--						end (?, l_ranking, l_report))

--			-- Initialize `last_spot'.`skeleton' using empty ranking information.
--			-- Use a more specific tester, since we are storing {EPA_PROGRAM_STATE_EXPRESSION} objects in the skeleton.
--			last_spot.set_ranking (create {HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]}.make (10))
--			last_spot.skeleton.set_equality_tester (create {EPA_PROGRAM_STATE_EXPRESSION_EQUALITY_TESTER})

--			-- Collect all program state expressions for the recipient feature.
--			l_collection := program_state_expressions

--			-- Register the expressions at `last_spot'.`skeleton' and `last_spot'.`ranking'.
--			l_collection.do_all (
--					agent (a_exp: EPA_PROGRAM_STATE_EXPRESSION; a_skeleton: AFX_STATE_SKELETON; a_ranking: HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION])
--						do
--							a_skeleton.force_last (a_exp)
--							a_ranking.force (create {AFX_EXPR_RANK}.make (1), a_exp)
--						end (?, last_spot.skeleton, last_spot.ranking))


-- Is the following necessary?

			--
			analyze_failing_assertion
		end

feature{NONE} -- Implementation

	current_test_case: EPA_TEST_CASE_INFO
			-- Test case under analysis.

	analyze_state_predicates (a_tc: EPA_TEST_CASE_INFO; a_spot: like last_spot)
			-- Analyze predicates that should be included in state for current exception, and
			-- set those predicates into `a_spot'.
			-- `a_tc' includes basic information of the current exception.
		local
			l_recipient_class: CLASS_C
			l_recipient_feature: FEATURE_I
			l_expression_set: DS_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION]
			l_expression: EPA_PROGRAM_STATE_EXPRESSION
			l_rank: AFX_EXPR_RANK

			l_ranking: HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]
			l_basic_expr_gen: AFX_BASIC_STATE_EXPRESSION_GENERATOR
			l_implication_gen: AFX_IMPLICATION_GENERATOR
			l_imp_file: PLAIN_TEXT_FILE
		do
			fixme ("The expressions should be from recipient written class, and interpreted in the context class.")
			l_recipient_class := a_tc.recipient_class_
			l_recipient_feature := a_tc.origin_recipient
			l_expression_set := state_expression_server.expression_set (l_recipient_class, l_recipient_feature)

			create l_ranking.make (l_expression_set.count)
			l_ranking.compare_objects

			from l_expression_set.start
			until l_expression_set.after
			loop
				l_expression := l_expression_set.item_for_iteration

				create l_rank.make (1)
				l_ranking.force (l_rank, l_expression)

				l_expression_set.forth
			end

			a_spot.set_ranking (l_ranking)
		end

	ranking_in_control_distance (a_expression_set: EPA_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION]; a_report: DS_HASH_TABLE [INTEGER, EPA_BASIC_BLOCK]): HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]
			-- List of ranking for expressions from `a_expression_set', on the basis of control distances from such expressions to the exception location.
		local
			l_collection: HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]
			l_exp: EPA_PROGRAM_STATE_EXPRESSION
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
			l_spot: like last_spot
		do
			l_spot := last_spot

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

--	program_state_expressions: DS_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION]
--			-- Program state expressions from the recipient feature,
--			--		together with their associated breakpoint indexes if applicable.
--			-- The set includes only expressions of type {BOOLEAN}.
--		local
--			l_test_case: EPA_TEST_CASE_INFO
--			l_collector: EPA_PROGRAM_STATE_EXPRESSION_COLLECTOR
----			l_extender: AFX_PROGRAM_STATE_EXPRESSION_EXTENDER
--			l_class: CLASS_C
--			l_feature: FEATURE_I
--			l_collection: DS_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION]
--			l_exp: EPA_PROGRAM_STATE_EXPRESSION
--			l_related_expressions: DS_LINKED_LIST [EPA_PROGRAM_STATE_EXPRESSION]
--			l_related: EPA_PROGRAM_STATE_EXPRESSION
--			l_extender: AFX_PROGRAM_STATE_EXTENDER_FOR_INTEGRAL_RELATIONS
--		do
--			l_test_case := current_test_case
--			l_class := l_test_case.recipient_class_
--			l_feature := l_test_case.recipient_

--			-- Collect expressions originated from the feature.
--			create l_collector
--			l_collector.collect_from_feature (l_class, l_feature)
--			l_collection := l_collector.last_collection

--			-- Extend the set with relational expressions in integral ones.
--			if not l_collection.is_empty then
--				create l_extender.make (config)
--				l_extender.set_original (l_collection)
--				l_extender.compute_extension
--				l_collection := l_extender.extended_skeleton
--			end

--			-- Collect all boolean expressions into `Result'.
--			create Result.make_equal (l_collection.count + 1)
--			from l_collection.start
--			until l_collection.after
--			loop
--				l_exp := l_collection.item_for_iteration

--				-- Compute related boolean expressions and add them to the `Result'.
--				l_exp.compute_related_boolean_expressions
--				Result.append (l_exp.related_boolean_expressions)

--				l_collection.forth
--			end
--		end

--			l_collection.do_all (
--					agent (a_col: DS_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION]; a_exp: EPA_PROGRAM_STATE_EXPRESSION)
--						do
--							a_exp.compute_related_expressions
--							if a_exp.related_expressions.is_empty then
--								a_col.force (a_exp)
--							end
--						end (Result, ?))

--			-- Add indirect expressions, which are all of primitive types, into `Result', if they are not there yet.
--			-- In some cases, indirect expressions constructed from direct expressions are the same as other direct ones.
--			-- Consider an expression 'a_ref.count', we will have 'a_ref' and 'a_ref.count' as direct expressions,
--			--		and 'a_ref.count' can also be constructed from 'a_ref' as an indirect expression.
--			l_collection.do_all (
--					agent (a_col: DS_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION]; a_exp: EPA_PROGRAM_STATE_EXPRESSION)
--						do
--							if not a_exp.related_expressions.is_empty then
--								a_exp.related_expressions.do_if (
--									agent a_col.force,
--									agent (a_col1: DS_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION]; a_exp1: EPA_PROGRAM_STATE_EXPRESSION): BOOLEAN
--										do
--											Result := not a_col1.has (a_exp1)
--										end (a_col, ?))
--							end
--						end (Result, ?))

--			from l_collection.start
--			until l_collection.after
--			loop
--				l_exp := l_collection.item_for_iteration

--				l_exp.compute_related_queries
--				if l_exp.related_queries.is_empty then
--					Result.force (l_exp)
--				else
--					Result.append (l_exp.related_queries)
--				end

--				l_collection.forth
--			end



--	analyze (a_tc: EPA_TEST_CASE_INFO; a_dm: DEBUGGER_MANAGER)
--			-- Generate `last_spot' for text case `a_tc' in the context
--			-- given by the debugger `a_dm'.			
--		do
--			create last_spot.make (a_tc)
--			last_spot.set_trace (a_dm.application_status.exception_text)

--			-- Use a more specific tester, since we are storing {EPA_PROGRAM_STATE_EXPRESSION} objects in the skeleton.
--			last_spot.skeleton.set_equality_tester (create {EPA_PROGRAM_STATE_EXPRESSION_EQUALITY_TESTER})

----			collect_program_state_expressions (a_tc, last_spot)

----				-- Analyze different aspects of the failure.
------			analyze_state_predicates (a_tc, a_dm, last_spot)
----			analyze_ast_structure (a_tc, a_dm, last_spot)
----			analyze_failing_assertion (a_Tc, a_dm, last_spot.recipient_ast_structure, last_spot)
--		end

--	implications_for_class (a_implications: ARRAY [STRING]; a_class: CLASS_C; a_feature: FEATURE_I): AFX_STATE_SKELETON
--			-- Implications and their rankings for `a_class'
--		local
--			i: INTEGER
--			l_expr: EPA_AST_EXPRESSION
--		do
--			create Result.make_basic (a_class, a_feature, a_implications.count)
--			from
--				i := a_implications.lower
--			until
--				i > a_implications.upper
--			loop
--				create l_expr.make_with_text (a_class, a_feature, a_implications.item (i), a_class)
--				Result.force_last (l_expr)
--				i := i + 1
--			end
--		end

--feature{NONE} -- Implementation

--	implication_file_path (a_tc: EPA_TEST_CASE_INFO): PLAIN_TEXT_FILE
--			-- File which stores the possible implication candidates used
--			-- in state model for the fault specified in `a_tc'.
--		local
--			l_file_name: FILE_NAME
--		do
--			create l_file_name.make_from_string (config.theory_directory)
--			l_file_name.set_file_name (a_tc.id + ".implications")
--			create Result.make (l_file_name)
--		end

--	store_implications_in_file (a_implications: DS_HASH_SET [AFX_IMPLICATION_EXPR]; a_file: PLAIN_TEXT_FILE)
--			-- Store `a_implications' in `a_file'.
--		local
--			l_cursor: DS_HASH_SET_CURSOR [AFX_IMPLICATION_EXPR]
--		do
--			a_file.create_read_write
--			from
--				l_cursor := a_implications.new_cursor
--				l_cursor.start
--			until
--				l_cursor.after
--			loop
--				a_file.put_string (l_cursor.item.text)
--				a_file.put_character ('%N')
--				l_cursor.forth
--			end
--			a_file.close
--		end

--	implications_from_file (a_tc: EPA_TEST_CASE_INFO; a_file: PLAIN_TEXT_FILE): AFX_STATE_SKELETON
--			-- Implications loaded from `a_file' for test case `a_tc'
--		local
--			l_imps: LINKED_LIST [STRING]
--			l_array: ARRAY [STRING]
--			i: INTEGER
--		do
--			create l_imps.make
--			a_file.open_read
--			from
--				a_file.read_line
--			until
--				a_file.after
--			loop
--				if not a_file.last_string.is_empty then
--					l_imps.extend (a_file.last_string.twin)
--				end
--				a_file.read_line
--			end
--			a_file.close

--			create l_array.make (1, l_imps.count)
--			from
--				i := 1
--				l_imps.start
--			until
--				l_imps.after
--			loop
--				l_array.put (l_imps.item_for_iteration, i)
--				i := i + 1
--				l_imps.forth
--			end

--			Result := implications_for_class (l_array, a_tc.recipient_written_class, a_tc.recipient_)
----			Result := implications_for_class (l_array, a_tc.recipient_class_, a_tc.recipient_)
--		end

--	update_expressions_with_ranking (a_expressions: HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]; a_new_exprs: DS_HASH_SET [EPA_EXPRESSION]; a_ranking: INTEGER)
--			-- Add `a_new_exprs' into `a_expressions' with `a_ranking' into `a_expression'.
--			-- If some expression already in `a_expressions' but `a_ranking' is higher than the original ranking,
--			-- update it with `a_ranking'.
--		local
--			l_expr: EPA_EXPRESSION
--			l_rank: AFX_EXPR_RANK
--		do
--			fixme ("Copied from AFX_RELEVANT_STATE_EXPRESSION_GENERATOR. 28.11.2009 Jasonw")
--			from
--				a_new_exprs.start
--			until
--				a_new_exprs.after
--			loop
--				create l_rank.make ({AFX_EXPR_RANK}.rank_implication)
--				l_expr := a_new_exprs.item_for_iteration
--				if a_expressions.has (l_expr) then
--					if a_expressions.item (l_expr) < l_rank then
--						a_expressions.replace (l_rank, l_expr)
--					end
--				else
--					a_expressions.put (l_rank, l_expr)
--				end
--				a_new_exprs.forth
--			end
--		end

