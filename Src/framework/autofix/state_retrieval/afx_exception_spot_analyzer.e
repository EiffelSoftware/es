note
	description: "Summary description for {AFX_EXCEPTION_SPOT_ANALYZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EXCEPTION_SPOT_ANALYZER

inherit
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

	analyze (a_tc: AFX_TEST_CASE_INFO; a_dm: DEBUGGER_MANAGER)
			-- Generate `last_spot' for text case `a_tc' in the context
			-- given by the debugger `a_dm'.			
		do
			create last_spot.make (a_tc)
			last_spot.set_trace (a_dm.application_status.exception_text)

				-- Analyze different aspects of the failure.
			analyze_state_predicates (a_tc, a_dm, last_spot)
			analyze_ast_structure (a_tc, a_dm, last_spot)
			analyze_failing_assertion (a_Tc, a_dm, last_spot.recipient_ast_structure, last_spot)
		end

feature{NONE} -- Implementation

	implications_for_class (a_implications: ARRAY [STRING]; a_class: CLASS_C; a_feature: FEATURE_I): AFX_STATE_SKELETON
			-- Implications and their rankings for `a_class'
		local
			i: INTEGER
			l_expr: AFX_AST_EXPRESSION
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

feature{NONE} -- Implementation

	implication_file_path (a_tc: AFX_TEST_CASE_INFO): PLAIN_TEXT_FILE
			-- File which stores the possible implication candidates used
			-- in state model for the fault specified in `a_tc'.
		local
			l_file_name: FILE_NAME
		do
			create l_file_name.make_from_string (config.theory_directory)
			l_file_name.set_file_name (a_tc.id + ".implications")
			create Result.make (l_file_name)
		end

	analyze_state_predicates (a_tc: AFX_TEST_CASE_INFO; a_dm: DEBUGGER_MANAGER; a_spot: like last_spot)
			-- Analyze predicates that should be included in state for current exception, and
			-- set those predicates into `a_spot'.
			-- `a_tc' includes basic information of the current exception.
			-- `a_dm' is a debugger manager.
		local
			l_ranking: HASH_TABLE [AFX_EXPR_RANK, AFX_EXPRESSION]
			l_basic_expr_gen: AFX_BASIC_STATE_EXPRESSION_GENERATOR
			l_implication_gen: AFX_IMPLICATION_GENERATOR
			l_imp_file: PLAIN_TEXT_FILE
		do
			create l_ranking.make (50)
			l_ranking.compare_objects

				-- Generate basic expressions such as argumentless boolean queries.
			create l_basic_expr_gen
			l_basic_expr_gen.generate (a_tc, l_ranking)


			l_imp_file := implication_file_path (a_tc)
			if l_imp_file.exists then
				update_expressions_with_ranking (l_ranking, implications_from_file (a_tc, l_imp_file), {AFX_EXPR_RANK}.rank_implication)
			else
					-- Generate implications.
				create l_implication_gen
				l_implication_gen.generate (a_tc, l_ranking)
				store_implications_in_file (l_implication_gen.implications, l_imp_file)
			end

			a_spot.set_ranking (l_ranking)
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

	implications_from_file (a_tc: AFX_TEST_CASE_INFO; a_file: PLAIN_TEXT_FILE): AFX_STATE_SKELETON
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

			Result := implications_for_class (l_array, a_tc.recipient_class_, a_tc.recipient_)
		end

	analyze_ast_structure (a_tc: AFX_TEST_CASE_INFO; a_dm: DEBUGGER_MANAGER; a_spot: like last_spot)
			-- Analyze AST structure of the recipient, and
			-- set the information into `a_spot'.
			-- `a_tc' includes basic information of the current exception.
			-- `a_dm' is a debugger manager.
		local
			l_structure_gen: AFX_AST_STRUCTURE_NODE_GENERATOR
		do
				-- Analyze AST structure of the recipient feature.
			create l_structure_gen
			l_structure_gen.generate (a_tc.recipient_class_, a_tc.recipient_)

			a_spot.set_recipient_ast_structure (l_structure_gen.structure)
		end

	analyze_failing_assertion (a_tc: AFX_TEST_CASE_INFO; a_dm: DEBUGGER_MANAGER; a_ast_structure: AFX_FEATURE_AST_STRUCTURE_NODE; a_spot: like last_spot)
			-- Analyze failing assertion of the exception, and
			-- set the information into `a_spot'.
			-- `a_tc' includes basic information of the current exception.
			-- `a_dm' is a debugger manager.
			-- `a_ast_structure' is the AST structure of the recipient of the exception.
		local
			l_rewriter: AFX_FAILING_ASSERTION_REWRITER
		do
				 -- Failing assertion rewritting
			create l_rewriter
			l_rewriter.rewrite (a_tc, a_ast_structure, a_dm.application_status.exception_text)

			a_spot.set_failing_assertion (l_rewriter.assertion)
			a_spot.set_feature_of_failing_assertion (l_rewriter.feature_of_assertion)
			a_spot.set_actual_arguments_in_failing_assertion (l_rewriter.actual_argument_expressions)
			a_spot.set_failing_assertion_break_point_slot (l_rewriter.assertion_break_point_slot)
			a_spot.set_target_expression_of_failing_feature (l_rewriter.target_expression)
		end

	update_expressions_with_ranking (a_expressions: HASH_TABLE [AFX_EXPR_RANK, AFX_EXPRESSION]; a_new_exprs: DS_HASH_SET [AFX_EXPRESSION]; a_ranking: INTEGER)
			-- Add `a_new_exprs' into `a_expressions' with `a_ranking' into `a_expression'.
			-- If some expression already in `a_expressions' but `a_ranking' is higher than the original ranking,
			-- update it with `a_ranking'.
		local
			l_expr: AFX_EXPRESSION
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

end
