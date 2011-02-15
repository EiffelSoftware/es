note
	description: "Summary description for {AFX_SOLVER_LAUNCHER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_SOLVER_FACILITY

inherit
	AFX_SOLVER_FACTORY

	REFACTORING_HELPER

	AFX_SOLVER_CONSTANTS

	AFX_UTILITY

feature -- Basic operations

	has_implication (a_list1: LINEAR [EPA_EXPRESSION]; a_list2: LINEAR [EPA_EXPRESSION]; a_theory: AFX_THEORY): BOOLEAN
			-- Does the conjunction of `a_list1' imply the conjunction of `a_list2'
			-- in the context of `a_theory'?
		require
			a_list1_not_empty: not a_list1.is_empty
			a_list2_not_empty: not a_list2.is_empty
		local
			l_expr: EPA_EXPRESSION
			l_result: like solver_output_for_expressions
			l_list: LINKED_LIST [EPA_EXPRESSION]
		do
				-- Create a dummy expression.
			a_list1.start
			l_expr := a_list1.item_for_iteration
			create {EPA_AST_EXPRESSION} l_expr.make_with_text (l_expr.class_, l_expr.feature_, "Current", l_expr.written_class)
			create l_list.make
			l_list.extend (l_expr)
			solver_file_generator.generate_for_implied_checking (a_list1, a_list2, a_theory)
			l_result := solver_output_for_expressions (l_list, solver_file_generator.last_content)

			if not l_result.is_empty then
				l_result.start
				Result := l_result.item_for_iteration ~ boogie_verified_tag
			end
		end

feature -- Access

	valid_premises (a_premises: AFX_STATE_SKELETON; a_consequence: EPA_EXPRESSION; a_theory: AFX_THEORY): AFX_STATE_SKELETON
			-- A state skeleton, in which all element e -> a_consequence
		local
			l_premise: EPA_EXPRESSION
			l_implication: EPA_EXPRESSION
			l_implication_skeleton: AFX_STATE_SKELETON
			l_tbl: HASH_TABLE [EPA_EXPRESSION, EPA_EXPRESSION] -- Key is the implication, value is the premise.
			l_valid_imps: DS_HASH_SET [EPA_EXPRESSION]
		do
			create l_implication_skeleton.make_basic (a_premises.class_, a_premises.feature_, a_premises.count)
			create l_tbl.make (a_premises.count)
			l_tbl.compare_objects

			from
				a_premises.start
			until
				a_premises.after
			loop
				l_premise := a_premises.item_for_iteration
				if l_premise /~ a_consequence then
					l_implication := l_premise implies a_consequence
					l_implication_skeleton.force_last (l_implication)
					l_tbl.put (l_premise, l_implication)
				end
				a_premises.forth
			end
			l_valid_imps := predicates_with_satisfiability (l_implication_skeleton, predicate_valid, l_implication_skeleton.theory)

			create Result.make_basic (a_premises.class_, a_premises.feature_, l_valid_imps.count)
			from
				l_valid_imps.start
			until
				l_valid_imps.after
			loop
				Result.force_last (l_tbl.item (l_valid_imps.item_for_iteration))
				l_valid_imps.forth
			end
		end

	simplified_skeleton (a_skeleton: AFX_STATE_SKELETON): AFX_STATE_SKELETON
			-- Simplified version of `a_skeleton'
			-- Result is simplified from `a_skeleton' by doing the following:
			-- Remove all tautologies from `a_skeleton'.
		local
			l_expr_list: LINKED_LIST [EPA_EXPRESSION]
			l_tautologies: AFX_STATE_SKELETON
		do
			l_tautologies := tautologies (a_skeleton)
			create l_expr_list.make

			a_skeleton.do_if (
				agent l_expr_list.extend,
				agent (a_expr: EPA_EXPRESSION; a_tau: AFX_STATE_SKELETON): BOOLEAN
						do
							Result := not a_tau.has (a_expr)
						end (?, l_tautologies))

			create Result.make_with_expressions (a_skeleton.class_, a_skeleton.feature_, l_expr_list)
		end

	tautologies (a_skeleton: AFX_STATE_SKELETON): AFX_STATE_SKELETON
			-- Tautology expressions from `a_skeleton'
		do
			create Result.make_with_expressions (
				a_skeleton.class_,
				a_skeleton.feature_,
				valid_expressions (a_skeleton.linear_representation, a_skeleton.theory))
		end

	expression_validity (a_expressions: LINEAR [EPA_EXPRESSION]; a_theory: AFX_THEORY): LINKED_LIST [BOOLEAN]
			-- Validity status of `a_expressions' in the context of `a_theory'.
			-- Result is a list of status, True means the corresponding expression in `a_expressions'
			-- is valid, otherwise, is not valid.
		local
			i: INTEGER
			l_temp_exprs: LINKED_LIST [EPA_EXPRESSION]
		do
			create l_temp_exprs.make
			create Result.make
			from
				i := 1
				a_expressions.start
			until
				a_expressions.after
			loop
				l_temp_exprs.extend (a_expressions.item_for_iteration)
				if i \\ max_proof_obligation_per_file = 0 then
					Result.append (expression_validity_internal (l_temp_exprs, a_theory))
					l_temp_exprs.wipe_out
				end
				i := i + 1
				a_expressions.forth
			end

			if not l_temp_exprs.is_empty then
				Result.append (expression_validity_internal (l_temp_exprs, a_theory))
			end
		end

	valid_expressions (a_expressions: LINEAR [EPA_EXPRESSION]; a_theory: AFX_THEORY): LINKED_LIST [EPA_EXPRESSION]
			-- List of valid formulae from `a_expressions' in the context of `a_theory'
		local
			l_generator: like solver_file_generator
			l_list: LINKED_LIST [AFX_SOLVER_EXPR]
			l_expr_list: LINKED_LIST [EPA_EXPRESSION]
			l_expr: EPA_EXPRESSION
			l_output: HASH_TABLE [STRING, EPA_EXPRESSION]
			l_validity: like expression_validity
		do
			create Result.make
			l_validity := expression_validity (a_expressions, a_theory)
			from
				a_expressions.start
				l_validity.start
			until
				l_validity.after
			loop
				if l_validity.item_for_iteration then
					Result.extend (a_expressions.item_for_iteration)
				end
				a_expressions.forth
				l_validity.forth
			end
		end

	minimized_premises (a_skeleton: AFX_STATE_SKELETON; a_predicate: EPA_EXPRESSION; a_context: AFX_STATE_SKELETON): detachable AFX_STATE_SKELETON
			-- Smallest state S (containing possibly fewer predicates than `a_skeleton') that, when accompanied
			-- with `a_context', implies `a_predicate': a_context ^ S -> a_predicate
			-- in `last_skeleton'. If no such state is found, set `last_skeleton' to Void.
		require
			a_predicate_valid: a_predicate.type.is_boolean
		do
			if a_skeleton implies expression_as_state_skeleton (a_predicate) then
				Result := minimal_premises_ddmin (a_skeleton, 2, a_predicate, a_context)
			end
		ensure
			result_correct: Result /= Void implies Result.count <= a_skeleton.count
		end

	minimal_premises_ddmin (a_skeleton: AFX_STATE_SKELETON; a_granularity: INTEGER; a_predicate: EPA_EXPRESSION; a_context: detachable AFX_STATE_SKELETON): detachable AFX_STATE_SKELETON
			-- Minimal subset of `a_skeleton' which, when accompanied with `a_context', implies `a_predicate', generated by delta deubbing.
			-- `a_granularity' is the granularity for delta debugging.
			-- Return Void if no such subset is found.
		local
			l_slices: LINKED_LIST [detachable AFX_STATE_SKELETON]
			l_done: BOOLEAN
			l_subset: detachable AFX_STATE_SKELETON
			l_premises: detachable AFX_STATE_SKELETON
		do
			if a_skeleton.count = 1 then
				Result := a_skeleton
			else
				l_slices := a_skeleton.slices (a_granularity)
				from
					l_slices.start
				until
					l_slices.after or l_done
				loop
					l_subset := a_skeleton.subtraction (l_slices.item_for_iteration)

					if a_context /= Void then
						l_premises := l_subset.union (a_context)
					else
						l_premises := l_subset
					end
					if l_premises implies expression_as_state_skeleton (a_predicate) then
						l_done := True
						Result := minimal_premises_ddmin (l_subset, (2).max (a_granularity - 1), a_predicate, a_context)
					end
					l_slices.forth
				end

					-- Increase granularity.
				if not l_done then
					if a_granularity < a_skeleton.count then
						Result := minimal_premises_ddmin (a_skeleton, a_skeleton.count.min (2 * a_granularity), a_predicate, a_context)
					end
				end
			end
		end

	predicates_with_satisfiability (a_predicates: DS_HASH_SET [EPA_EXPRESSION]; a_satisfiability: NATURAL_8; a_theory: AFX_THEORY): DS_HASH_SET [EPA_EXPRESSION]
			-- Predicates in `a_predicates' of `a_satisfiability' in the context of `a_theory'
		require
			a_satisfiability_valid: is_satisfiability_valid (a_satisfiability)
		local
			l_pred_status: like predicate_satisfiability
		do
			l_pred_status := predicate_satisfiability (a_predicates, a_theory)
			create Result.make (a_predicates.count)
			Result.set_equality_tester (create {EPA_EXPRESSION_EQUALITY_TESTER})

			from
				l_pred_status.start
			until
				l_pred_status.after
			loop
				if a_satisfiability = predicate_any_satisfiable or else l_pred_status.item_for_iteration = a_satisfiability then
					Result.force_last (l_pred_status.key_for_iteration)
				end
				l_pred_status.forth
			end
		end

	predicate_satisfiability (a_predicates: DS_HASH_SET [EPA_EXPRESSION]; a_theory: AFX_THEORY): HASH_TABLE [NATURAL_8, EPA_EXPRESSION]
			-- Predicate satisfiability table for predicates in `a_predicates'
			-- Key is the predicate, value is the satisfiacbility of that predicate:
			-- 0: Satisfiable
			-- 1: Valid
			-- 2: Contradictary			
		local
			l_normal_preds: LINKED_LIST [EPA_EXPRESSION]
			l_exprs: LINKED_LIST [EPA_EXPRESSION]
			l_validity: LINKED_LIST [BOOLEAN]
			l_valid: BOOLEAN
			l_negation_valid: BOOLEAN
			l_satis: NATURAL_8
			l_expr: EPA_EXPRESSION
			l_negated_expr: EPA_EXPRESSION
			l_skeleton: AFX_STATE_SKELETON
			l_count: INTEGER
		do
			create l_normal_preds.make
			create l_exprs.make
			create l_validity.make

			from
				a_predicates.start
			until
				a_predicates.after
			loop
				l_normal_preds.extend (a_predicates.item_for_iteration)
				l_exprs.extend (a_predicates.item_for_iteration)
				l_exprs.extend (not a_predicates.item_for_iteration)
				a_predicates.forth
				l_count := l_count + 1
			end

			l_validity := expression_validity (l_exprs, a_theory)

			create Result.make (l_count)
			Result.compare_objects

			from
				l_validity.start
				l_normal_preds.start
			until
				l_normal_preds.after
			loop
				l_valid := l_validity.item_for_iteration
				l_validity.forth
				l_negation_valid := l_validity.item_for_iteration
				l_validity.forth

				if l_valid then
					l_satis := predicate_valid
				elseif l_negation_valid then
					l_satis := predicate_contradictory
				else
					l_satis := predicate_satisfiable
				end
				check not Result.has (l_normal_preds.item_for_iteration) end
				Result.put (l_satis, l_normal_preds.item_for_iteration)
				l_normal_preds.forth
			end
		end

feature -- Constants

	is_satisfiability_valid (s: NATURAL_8): BOOLEAN
			-- Is `s' a valid satisfiability level?
		do
			Result :=
				s = predicate_valid or
				s = predicate_contradictory or
				s = predicate_satisfiable or
				s = predicate_any_satisfiable
		end

	predicate_valid: NATURAL_8 = 1
			-- Predicate valid flag

	predicate_contradictory: NATURAL_8 = 2
			-- Predicate contradictory flag

	predicate_satisfiable: NATURAL_8 = 0
			-- Predicate satisfiable flag	

	predicate_any_satisfiable: NATURAL_8 = 10
			-- Predicate satisfiable flag for any situation	

feature{NONE} -- Implementation

	generate_file (a_content: STRING)
			-- Generate solver file containing `a_content'.
		deferred
		end

	solved_path (a_path: STRING): STRING
			-- Solved path of `a_path'
			-- If in Windows, Result will be equal to `a_path',
			-- otherwise, Result will be the path as seen by Wine.
		local
			l_prc_factory: PROCESS_FACTORY
			l_prc: PROCESS
		do
			if {PLATFORM}.is_windows then
				Result := a_path.twin
			else
				Result := output_from_program ("/bin/sh -c %"winepath -w " + a_path + "%"", Void)
				Result.replace_substring_all ("%N", "")
			end
		end


	solver_output (a_content: STRING): STRING
			-- Output from the solver for input `a_content'
		deferred
		end

	solver_output_for_expressions (a_expressions: LINEAR [EPA_EXPRESSION]; a_solver_input: STRING): HASH_TABLE [STRING, EPA_EXPRESSION]
			-- Output from the solver for checking `a_expressions' in the context of `a_solver_input'.
			-- `a_solver_input' is the input fed to the underlying theorem prover.
			-- Result is a table, key is the expression, value is the solver output for that expression':
			-- output can be either "verified" or "error".
		deferred
		end

	max_proof_obligation_per_file: INTEGER = 150
			-- The maximum number of proof obligations
			-- in a Boogie file.
			-- This is introduced because if there are too many obligations
			-- in one file, Boogie will easily crash.

	expression_validity_internal (a_expressions: LINEAR [EPA_EXPRESSION]; a_theory: AFX_THEORY): LINKED_LIST [BOOLEAN]
			-- Validity status of `a_expressions' in the context of `a_theory'.
			-- Result is a list of status, True means the corresponding expression in `a_expressions'
			-- is valid, otherwise, is not valid.
		local
			l_generator: like solver_file_generator
			l_list: LINKED_LIST [AFX_SOLVER_EXPR]
			l_expr_list: LINKED_LIST [EPA_EXPRESSION]
			l_expr: EPA_EXPRESSION
			l_output: HASH_TABLE [STRING, EPA_EXPRESSION]
			i: INTEGER
		do
				-- Build solver input.
			create l_list.make
			create l_expr_list.make
			from
				a_expressions.start
			until
				a_expressions.after
			loop
				l_expr := a_expressions.item_for_iteration
				if l_expr.is_predicate then
					l_expr_list.extend (l_expr)
					l_list.extend (solver_expression (l_expr))
				end
				a_expressions.forth
			end

				-- Generate solver input file and start the solver.
			l_generator := solver_file_generator
			l_generator.generate_formulae (l_list, a_theory)
			l_output := solver_output_for_expressions (l_expr_list, l_generator.last_content)

				-- Build final result.
			create Result.make
			from
				a_expressions.start
			until
				a_expressions.after
			loop
				Result.extend (l_output.item (a_expressions.item_for_iteration) ~ boogie_verified_tag)
				a_expressions.forth
			end
		end

end
