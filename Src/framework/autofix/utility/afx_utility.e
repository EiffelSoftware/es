note
	description: "Summary description for {AFX_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_UTILITY

inherit
	EPA_CONTRACT_EXTRACTOR

	AFX_SOLVER_FACTORY

	EPA_UTILITY

	EPA_SHARED_EQUALITY_TESTERS

	EPA_SHARED_EQUALITY_TESTERS

	EPA_TYPE_UTILITY

feature -- Access

	test_case_info_from_string (a_string: STRING): EPA_TEST_CASE_INFO
			-- Test case information analyzed from `a_string'
		do
			create Result.make_with_string (a_string)
		end

feature -- Fix

	formated_feature (a_feature: FEATURE_I): STRING
			-- Pretty printed feature `a_feature'
		local
			l_printer: ETR_AST_STRUCTURE_PRINTER
			l_output: ETR_AST_STRING_OUTPUT
			l_feat_text: STRING
			l_match_list: LEAF_AS_LIST
		do
			l_match_list := match_list_server.item (a_feature.written_class.class_id)
			entity_feature_parser.parse_from_string ("feature " + a_feature.e_feature.ast.original_text (l_match_list), Void)
			create l_output.make_with_indentation_string ("%T")
			create l_printer.make_with_output (l_output)
			l_printer.print_ast_to_output (a_feature.e_feature.ast)
			Result := l_output.string_representation
		end

	formated_fix (a_fix: AFX_FIX): STRING
			-- Pretty printed feature text for `a_fix'
		local
			l_printer: ETR_AST_STRUCTURE_PRINTER
			l_output: ETR_AST_STRING_OUTPUT
			l_feat_text: STRING
			l_parser: like entity_feature_parser
		do
			if a_fix.feature_text.has_substring ("should not happen") then
				Result := a_fix.feature_text.twin
			else
				l_parser := entity_feature_parser
				l_parser.set_syntax_version (l_parser.transitional_64_syntax)
				l_parser.parse_from_string ("feature " + a_fix.feature_text, Void)
				create l_output.make_with_indentation_string ("%T")
				create l_printer.make_with_output (l_output)
				l_printer.print_ast_to_output (l_parser.feature_node)
				Result := l_output.string_representation
			end
		end

feature -- Logging

	store_fix_in_file (a_directory: STRING; a_fix: AFX_FIX; a_validated: BOOLEAN; a_big_file: detachable PLAIN_TEXT_FILE)
			-- Store `a_fix' as the `a_id'-th fix into a file in directory `a_directory'
			-- `a_validated' indicates if `a_fix' has been validated.
			-- Also append the fix in `a_big_file'.
		local
			l_file: PLAIN_TEXT_FILE
			l_file_name: FILE_NAME
			l_lines: LIST [STRING]
			l_formated_fix: STRING
		do
			create l_file_name.make_from_string (a_directory)
			l_file_name.set_file_name (fix_file_name (a_fix, a_validated))
			create l_file.make_create_read_write (l_file_name)

				-- Print patched feature text.
			l_formated_fix := formated_fix (a_fix)
			l_file.put_string (l_formated_fix)
			l_file.put_string (once "%N%N")

			if a_big_file /= Void then
				a_big_file.put_string (fix_signature (a_fix, False, True) + "%N")
				a_big_file.put_string (l_formated_fix)
				a_big_file.put_string (once "%N%N")
			end

				-- Print information about current fix.
			l_lines := a_fix.information.split ('%N')
			from
				l_lines.start
			until
				l_lines.after
			loop
				l_file.put_string (once "-- ")
				l_file.put_string (l_lines.item_for_iteration)
				l_file.put_string (once "%N")
				l_lines.forth
			end
			l_file.close
		end

	fix_signature (a_fix: AFX_FIX; a_validated: BOOLEAN; a_id: BOOLEAN): STRING
			-- Signature of `a_fix'
			-- `a_validated' indicates if `a_fix' has been validated.
			-- `a_id' indicates whether the fix ID is included.
		local
			l_fdouble: FORMAT_DOUBLE
			l_rank: STRING
		do
			create Result.make (64)
			Result.append (once "fix_")
			if a_validated then
				if a_fix.is_valid then
					Result.append (once "S_")
				else
					Result.append (once "F_")
				end
			else
				Result.append (once "U_")
			end
			create l_fdouble.make (6, 3)
			Result.append ("SYN_")
			l_rank := l_fdouble.formatted (a_fix.ranking.syntax_score)
			l_rank.left_adjust
			Result.append (l_rank)
			Result.append (once "__")
			Result.append ("SEM_")
			l_rank := l_fdouble.formatted (a_fix.ranking.impact_on_passing_test_cases)
			l_rank.left_adjust
			Result.append (l_rank)
			Result.append (once "__")

			inspect
				a_fix.skeleton_type
			when {AFX_FIX}.afore_skeleton_type then
				Result.append ("AFOR")
			when {AFX_FIX}.wrapping_skeleton_type then
				Result.append ("WRAP")
			else
				Result.append ("NONE")
			end

			if a_id then
				Result.append ("__" + a_fix.id.out)
			end
		end

	fix_file_name (a_fix: AFX_FIX; a_validated: BOOLEAN): STRING
			-- File name to store `a_fix'.
			-- `a_validated' indicates if `a_fix' has been validated.
		local
			l_fdouble: FORMAT_DOUBLE
			l_rank: STRING
		do
			create Result.make (64)
			Result.append (fix_signature (a_fix, a_validated, True))
			Result.append (".txt")
		end

feature -- State

	state_shrinker: AFX_STATE_SHRINKER
			-- State shrinker
		once
			create Result
		end

feature -- Process

	output_from_program (a_command: STRING; a_working_directory: detachable STRING): STRING
			-- Output from the execution of `a_command' in (possibly) `a_working_directory'.
			-- Note: You may need to prune the final new line character.
		do
			Result := output_from_program_with_input_file (a_command, a_working_directory, Void)
		end

	output_from_program_with_input_file (a_command: STRING; a_working_directory: detachable STRING; a_input_file: detachable STRING): STRING
			-- Output from the execution of `a_command' in (possibly) `a_working_directory'.
			-- Note: You may need to prune the final new line character.
			-- If `a_input_file' is attached, redirect input to that file.
		local
			l_prc_factory: PROCESS_FACTORY
			l_prc: PROCESS
			l_buffer: STRING
		do
			create l_prc_factory
			l_prc := l_prc_factory.process_launcher_with_command_line (a_command, a_working_directory)
			create Result.make (1024)
			l_prc.redirect_output_to_agent (agent Result.append ({STRING}?))
			if a_input_file /= Void then
				l_prc.redirect_input_to_file (a_input_file)
			end
			l_prc.launch
			if l_prc.launched then
				l_prc.wait_for_exit
			end
		end

feature -- Access

	solver_expression (a_expr: EPA_EXPRESSION): AFX_SOLVER_EXPR
			-- Solver expression from `a_expr'
		local
			l_resolved: TUPLE [resolved_str: STRING; mentioned_classes: DS_HASH_SET [EPA_CLASS_WITH_PREFIX]]
			l_shared_theory: AFX_SHARED_CLASS_THEORY
			l_raw_text: STRING
		do
			create l_shared_theory
			l_shared_theory.solver_expression_generator.initialize_for_generation
			l_shared_theory.solver_expression_generator.generate_expression (a_expr.ast, a_expr.class_, a_expr.written_class, a_expr.feature_)
			l_raw_text := l_shared_theory.solver_expression_generator.last_statements.first
			l_resolved := l_shared_theory.resolved_smt_statement (l_raw_text, create {EPA_CLASS_WITH_PREFIX}.make (a_expr.class_, ""))
			Result := new_solver_expression_from_string (l_resolved.resolved_str)
		end

	expression_as_state_skeleton (a_expr: EPA_EXPRESSION): AFX_STATE_SKELETON
			-- State skeleton including `a_expr'
		require
			a_expr_is_predicate: a_expr.is_predicate
		local
			l_exprs: LINKED_LIST [EPA_EXPRESSION]
		do
			create l_exprs.make
			l_exprs.extend (a_expr)

			create Result.make_with_expressions (a_expr.class_, a_expr.feature_, l_exprs)
		end

	equation_as_state (a_equation: EPA_EQUATION): EPA_STATE
			-- State representing `a_equation'.
			-- The returned state only contains Current as the only predicate.
		do
			create Result.make (1, a_equation.class_, a_equation.feature_)
			Result.force_last (a_equation)
		end

feature -- State related

	state_projected_by_skeleton (a_state: EPA_STATE; a_skeleton: AFX_STATE_SKELETON): EPA_STATE
			-- Projection of `a_state' only containing expressions in `a_skeleton'
		local
			l_removed: LINKED_LIST [EPA_EQUATION]
			l_equation: EPA_EQUATION
		do
			Result := a_state.cloned_object
			Result.do_if (
				agent Result.remove,
				agent (a_equation: EPA_EQUATION; a_ske: AFX_STATE_SKELETON): BOOLEAN
					do
						Result := not a_ske.has (a_equation.expression)
					end (?, a_skeleton))
		end

	padded_state (a_state: EPA_STATE; a_skeleton: AFX_STATE_SKELETON): EPA_STATE
			-- State from `a_state' containing all predicates in `a_skeleton'.
			-- Predicates in `a_skeleton' but not presented in Current
			-- will be assigned to a random value in the returned state.
		require
			current_is_subset: predicate_skeleton (a_state).is_subset (a_skeleton)
		local
			l_diff: like a_skeleton
		do
				-- Copy existing equations into Result.
			create Result.make (a_skeleton.count, a_state.class_, a_state.feature_)
			a_state.do_all (agent Result.force_last)

				-- Generate random values for expression not appearing in Current.
			l_diff := a_skeleton.subtraction (predicate_skeleton (Result))
			if not l_diff.is_empty then
				l_diff.do_all (
					agent (a_expr: EPA_EXPRESSION; a_st: EPA_STATE)
						do
							a_st.force_last (equation_with_random_value (a_expr))
						end (?, Result))
			end
		ensure
			result_is_padded: predicate_skeleton (Result).is_subset (a_skeleton) and a_skeleton.is_subset (predicate_skeleton (Result))
		end

	predicate_skeleton (a_state: EPA_STATE): AFX_STATE_SKELETON
			-- Predicate skeleton of `a_state'
		require
			all_expressions_boolean: a_state.for_all (agent (a_equation: EPA_EQUATION): BOOLEAN do Result := a_equation.expression.is_predicate end)
		do
			create Result.make_basic (a_state.class_, a_state.feature_, a_state.count)
			a_state.do_all (
				agent (a_pred: EPA_EQUATION; a_skeleton: AFX_STATE_SKELETON)
					do
						a_skeleton.force_last (a_pred.expression)
					end (?, Result))
		ensure
			good_result: Result.count = a_state.count
		end

	skeleton_with_value (a_state: EPA_STATE): AFX_STATE_SKELETON
			-- Skeleton from consisting of predicate rewritten as predicates in `a_state'.
		do
			create Result.make_basic (a_state.class_, a_state.feature_, a_state.count)
			a_state.do_all (
				agent (a_pred: EPA_EQUATION; a_skeleton: AFX_STATE_SKELETON)
					do
						a_skeleton.force_last (a_pred.as_predicate)
					end (?, Result))
		end

	skeleton_from_state (a_state: EPA_STATE): AFX_STATE_SKELETON
			-- Expression skeleton from `a_state'
		do
			create Result.make_basic (a_state.class_, a_state.feature_, a_state.count)
			a_state.do_all (
				agent (a_equation: EPA_EQUATION; a_skeleton: AFX_STATE_SKELETON)
					do
						a_skeleton.force_last (a_equation.expression)
					end (?, Result))
		ensure
			good_result: Result.count = a_state.count
		end

feature -- Contract extraction

	precondition_expressions (a_context_class: CLASS_C; a_feature: FEATURE_I): DS_HASH_SET [EPA_EXPRESSION]
			-- List of precondition assertions of `a_feature' in `a_context_class'
		local
			l_exprs: LINKED_LIST [EPA_EXPRESSION]
			l_expr: EPA_AST_EXPRESSION
		do
			l_exprs := precondition_of_feature (a_feature, a_context_class)

			create Result.make (l_exprs.count)
			Result.set_equality_tester (expression_equality_tester)

			fixme ("Require else assertions are ignored. 30.12.2009 Jasonw")
			extend_expression_in_set (
				l_exprs,
				agent (a_expr: EPA_EXPRESSION): BOOLEAN do Result := not a_expr.is_require_else end,
				Result,
				a_context_class,
				a_feature)
		end

	postconditions_expressions (a_context_class: CLASS_C; a_feature: FEATURE_I): DS_HASH_SET [EPA_EXPRESSION]
			-- List of postcondition assertions of `a_feature' in `a_context_class'
		local
			l_exprs: LINKED_LIST [EPA_EXPRESSION]
		do
			l_exprs := postcondition_of_feature (a_feature, a_context_class)

			create Result.make (l_exprs.count)
			Result.set_equality_tester (expression_equality_tester)

			extend_expression_in_set (
				l_exprs,
				agent (a_expr: EPA_EXPRESSION): BOOLEAN do Result := True end,
				Result,
				a_context_class,
				a_feature)
		end

	invariant_expressions (a_context_class: CLASS_C; a_feature: FEATURE_I): DS_HASH_SET [EPA_EXPRESSION]
			-- List of class invariant assertions in `a_context_class'
		local
			l_exprs: LINKED_LIST [EPA_EXPRESSION]
			l_gen: AFX_POSTCONDITION_AS_INVARIANT_GENERATOR
		do
			l_exprs := invariant_of_class (a_context_class)
			create l_gen
			l_gen.generate (a_context_class)

			create Result.make (l_exprs.count + l_gen.last_invariants.count)
			Result.set_equality_tester (expression_equality_tester)

				-- Include normal class invariants.
			extend_expression_in_set (
				l_exprs,
				agent (a_expr: EPA_EXPRESSION): BOOLEAN do Result := True end,
				Result,
				a_context_class,
				a_feature)

				-- Include some postconditions as class invariants.
			l_gen.last_invariants.do_if (
				agent Result.force_last,
				agent (a_item: EPA_EXPRESSION; a_set: DS_HASH_SET [EPA_EXPRESSION]): BOOLEAN
					do
						Result := not a_set.has (a_item)
					end (?, Result))
		end

	extend_expression_in_set (a_exprs: LINKED_LIST [EPA_EXPRESSION]; a_test: PREDICATE [ANY, TUPLE [EPA_EXPRESSION]]; a_set: DS_HASH_SET [EPA_EXPRESSION]; a_context_class: CLASS_C; a_feature: FEATURE_I)
			-- Append items from `a_exprs' into `a_set' if those items satisfy `a_test'.
			-- `a_context_class' and `a_feature' are used to construct AFX_EXPRESSION.
		local
			l_expr: EPA_AST_EXPRESSION
		do
			from
				a_exprs.start
			until
				a_exprs.after
			loop
				if a_test.item ([a_exprs.item_for_iteration]) then
					create l_expr.make_with_text (a_context_class, a_feature, text_from_ast (a_exprs.item_for_iteration.ast), a_exprs.item_for_iteration.written_class)
					if not a_set.has (l_expr) then
						a_set.force_last (l_expr)
					end
				end
				a_exprs.forth
			end
		end

end
