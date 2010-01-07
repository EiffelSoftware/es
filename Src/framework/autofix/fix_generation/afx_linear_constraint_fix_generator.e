note
	description: "Summary description for {AFX_LINEAR_CONSTRAINT_FIX_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_LINEAR_CONSTRAINT_FIX_GENERATOR

inherit
	AFX_ASSERTION_STRUCTURE_BASED_FIX_GENERATOR
		redefine
			structure_analyzer
		end

	AUT_CONTRACT_EXTRACTOR

	REFACTORING_HELPER

	AFX_UTILITY

create
	make

feature -- Access

	structure_analyzer: AFX_LINEAR_CONSTRAINED_EXPRESSION_STRUCTURE_ANALYZER
			-- Failing assertion structure analyzer

feature -- Basic operations

	generate
			-- Generate fixes into `fixes'.
		local
			l_solutions: like constrained_solutions
			l_structure_analyzer: like structure_analyzer
		do
				-- Analyze the linear constrained problem.
			create l_structure_analyzer
			l_structure_analyzer.analyze (exception_spot.original_failing_assertion)
			constraints := l_structure_analyzer.constraints

			create relevant_constraints.make (Void)
			relevant_constraints.merge (constraints)
			collect_relevant_constraints

				-- Solve the linear constrained problem.
			l_solutions := constrained_solutions (constrain_possibilities)

				-- Generate fixes.
			l_solutions.do_all (agent generate_fix_for_constrained_solution)
		end

feature{NONE} -- Implementation

	constraints: AFX_NUMERIC_CONSTRAINTS
			-- Constraints relevant to the assertion failure

	relevant_constraints: AFX_NUMERIC_CONSTRAINTS
			-- Contraints relevant to `constraints'
			-- `relevant_constriants' is a super set of `constraints'.

	constraint_table: HASH_TABLE [AFX_NUMERIC_CONSTRAINTS, AFX_EXPRESSION]
			-- Table of contraints.
			-- Key is the assertion from which the contraint comes,
			-- value is that constraint.

	constrained_expressions: LINKED_LIST [AFX_EXPRESSION]
			-- Constrained expressions
			-- This list contains the keys of `constraint_table'

	constrain_possibilities: LINKED_LIST [TUPLE [constrained_expressions: DS_HASH_SET [AFX_EXPRESSION]; constraining_expressions: DS_HASH_SET [AFX_EXPRESSION]]]
			-- Different possibilities to treat components in `constraints' as constrained or constraining.
			-- Returned value is a list of these possibilities.
			-- `constrained_expressions' are the set of expressions in `constraints' which are considered to be constrained.
			-- `constraining_expressions' are the set of expressions in `constraints' which are considered to be constraining.
			-- The order of the elements in the result has no meaning.
		local
			l_max_occur: INTEGER
			l_constrained_expr: AFX_EXPRESSION
			l_constrained: DS_HASH_SET [AFX_EXPRESSION]
			l_constraining: DS_HASH_SET [AFX_EXPRESSION]
		do
				-- Heuristics to decide which expressions are constrained:
				-- 1. If an expression appears the most, it is likely to be the constrained part, `i' in the above example.
    			-- 2. If an expression is an argument, it is likely to be the constrained part.
    			-- 3. If an expression is not changed in all passing runs, it is likely to be the constraining part.	
    		fixme ("Only the first heuristic (occurrence frequency) is implemented. 5.1.2010 Jasonw")

			create Result.make

				-- Get the most frequently appeared expression, treat it as constrained.
			from
				constraints.occurrence_frequency.start
			until
				constraints.occurrence_frequency.after
			loop
				if constraints.occurrence_frequency.item_for_iteration >= l_max_occur then
					l_max_occur := constraints.occurrence_frequency.item_for_iteration
					l_constrained_expr := constraints.occurrence_frequency.key_for_iteration
				end
				constraints.occurrence_frequency.forth
			end

				-- Construct result.
			create l_constrained.make (1)
			l_constrained.set_equality_tester (expression_equality_tester)
			l_constrained.force_last (l_constrained_expr)

			create l_constraining.make (1)
			l_constraining.set_equality_tester (expression_equality_tester)
			l_constraining.append (constraints.components.subtraction (l_constrained))

			Result.extend ([l_constrained, l_constraining])
		end

feature{NONE} -- Implementation

	collect_relevant_constraints
			-- Coleect numeric constrained assertions which are relevant to the failing assertion,
			-- store result in `constraints'.
		local
			l_asserts: DS_HASH_SET [AFX_EXPRESSION]
			l_constraint_analyzer: AFX_LINEAR_CONSTRAINED_EXPRESSION_STRUCTURE_ANALYZER
			l_feat: FEATURE_I
			l_class: CLASS_C
			l_constraints, l_temp: like constraint_table
			l_rev_components: DS_HASH_SET [AFX_EXPRESSION]
			l_done: BOOLEAN
			l_kept: DS_HASH_SET [AFX_EXPRESSION]
			l_cir: ARRAYED_CIRCULAR [ANY]
			l_cursor: CURSOR
			l_removed: LINKED_LIST [AFX_EXPRESSION]
		do
			create l_asserts.make (20)
			l_asserts.set_equality_tester (expression_equality_tester)

			l_feat := exception_spot.feature_of_failing_assertion
			l_class := exception_spot.class_of_feature_of_failing_assertion
			if exception_spot.is_precondition_violation then
					-- Collect all precondion assertions and class invariant assertions.
				l_asserts.append (precondition_expressions (l_class, l_feat))
				l_asserts.append (invariant_expressions (l_class, l_feat))

			elseif exception_spot.is_postcondition_violation then
					-- Collect all postcondition assertions and class invariant assertions.
				l_asserts.append (postconditions_expressions (l_class, l_feat))
				l_asserts.append (invariant_expressions (l_class, l_feat))

			elseif exception_spot.is_class_invariant_violation then
					-- Collect class invariant assertions.
				l_asserts.append (invariant_expressions (l_class, l_feat))

			else
					-- Collect class invariant assertions.
				fixme ("In feature body, the class invariant need not to hold. The solution here is too strong. 30.12.2009 Jasonw")
				l_asserts.append (invariant_expressions (l_class, l_feat))
			end

				-- Find out only numeric constrained assertions.
			create l_constraint_analyzer
			create l_constraints.make (l_asserts.count)
			l_constraints.compare_objects
			from
				l_asserts.start
			until
				l_asserts.after
			loop
				l_constraint_analyzer.analyze (l_asserts.item_for_iteration)
				if l_constraint_analyzer.is_matched then
					l_constraints.put (l_constraint_analyzer.constraints, l_asserts.item_for_iteration)
				end
				l_asserts.forth
			end

				-- Collect constraints relevant to `constraint', keep them in `l_constraints'.			
			create l_rev_components.make (20)
			l_rev_components.set_equality_tester (expression_equality_tester)
			l_rev_components.append (constraints.components)
			l_temp := l_constraints.twin
			create l_kept.make (5)
			l_kept.set_equality_tester (expression_equality_tester)
			if attached {AFX_EXPRESSION} constraints.expression as l_expr then
				l_kept.force_last (l_expr)
			else
				check False end
			end

			if not l_temp.is_empty then
				from
					l_done := False
				until
					l_done
				loop
					l_done := True
					create l_removed.make
					from
						l_temp.start
					until
						l_temp.after
					loop
						if
							not l_temp.item_for_iteration.components.is_disjoint (l_rev_components)
						then
							l_kept.force_last (l_temp.key_for_iteration)
							l_removed.extend (l_temp.key_for_iteration)
							l_rev_components.append (l_temp.item_for_iteration.components)
							relevant_constraints.merge (l_temp.item_for_iteration)
							if l_done then
								l_done := False
							end
						end
						l_temp.forth
					end
					l_removed.do_all (agent l_temp.remove)
				end
			end

				-- Construct `constraint_table' and `constrained_expressions'.
			create constrained_expressions.make
			create constraint_table.make (l_constraints.count)
			from
				l_constraints.start
			until
				l_constraints.after
			loop
				if l_kept.has (l_constraints.key_for_iteration) then
					constraint_table.put (l_constraints.item_for_iteration, l_constraints.key_for_iteration)
					constrained_expressions.extend (l_constraints.key_for_iteration)
				end
				l_constraints.forth
			end
		end

	solve_and_append_solution (a_maximize: BOOLEAN; a_function: AFX_EXPRESSION; a_constraints: LINKED_LIST [AFX_EXPRESSION]; a_arguments: LINKED_LIST [AFX_EXPRESSION]; a_solutions: DS_HASH_SET [AFX_EXPRESSION])
			-- Append solutions to the linear constraint problem into `a_solutions'.
			-- If `a_maximize' is True, maximize the solution, otherwise, minimize it.
			-- The linear constrianed problem is defined by `a_function', `a_constriants' and `a_arguments'.
		local
			l_solver: AFX_MATHEMATICA_SYMBOLIC_CONSTRAINT_SOLVER
		do
				-- Solve the linear constrained problem.
			create l_solver.make (config)
			l_solver.solve (a_maximize, a_function, a_constraints, a_arguments)

				-- Collect solutions in to `a_solutions'.
			from
				l_solver.last_solutions.start
			until
				l_solver.last_solutions.after
			loop
				a_solutions.force_last (l_solver.last_solutions.key_for_iteration)
				l_solver.last_solutions.forth
			end
		end

	type_anchor: TUPLE [constrained_expression: AFX_EXPRESSION; solution: AFX_EXPRESSION; constrained_expressions: DS_HASH_SET [AFX_EXPRESSION]; constraining_expressions: DS_HASH_SET [AFX_EXPRESSION]]
			-- Anchor type
			-- `constrained_expression' is the expression considered as the solving target, `constrained_expression' must be one of `constrained_expressions'.
			-- `solution' is the solution for `constrained_expression' under the constraints.
			-- `constrained_expressions' and `constraining_expressions' are used for supporting data.

	generate_fix_for_constrained_solution (a_solution: like type_anchor)
			-- Generate fixes for `a_solution'.
		local
			l_solution_text: STRING
			l_solution_expr: AFX_AST_EXPRESSION
			l_constrained_expr: AFX_EXPRESSION
		do
				-- Rewrite the solution in the context of the recipient.
			create l_solution_text.make (64)
			if attached {AFX_EXPRESSION} exception_spot.target_expression_of_failing_feature as l_target_expr and then not l_target_expr.is_for_boogie then
				l_solution_text.append (l_target_expr.text)
				l_solution_text.append (".")
			end
			l_solution_text.append (a_solution.solution.text)
			create l_solution_expr.make_with_text (exception_spot.recipient_class_, exception_spot.recipient_, l_solution_text, exception_spot.recipient_class_)

				-- Generate different types of fixes depending on the type of the constrained expressoin.
			l_constrained_expr := a_solution.constrained_expression
			if exception_spot.is_precondition_violation then
				if config.is_wrapping_fix_enabled then
					fixing_locations.do_if (
						agent (a_location: TUPLE [scope_level: INTEGER; instrus: LINKED_LIST [AFX_AST_STRUCTURE_NODE]]; a_sol: like type_anchor; a_solved_expr: AFX_EXPRESSION)
							do
								generate_wraping_fixes_for_precondition_violation (a_location, a_sol, a_solved_expr)
							end (?, a_solution, l_solution_expr),

						agent (a_location: TUPLE [scope_level: INTEGER; instrus: LINKED_LIST [AFX_AST_STRUCTURE_NODE]]): BOOLEAN
							do
								Result := a_location.scope_level = 1 and a_location.instrus.count = 1
							end)
				end
			elseif
				l_constrained_expr.is_attribute or
				l_constrained_expr.is_local or
				l_constrained_expr.is_result
			then
				if config.is_afore_fix_enabled then
					fixing_locations.do_if (
						agent (a_location: TUPLE [scope_level: INTEGER; instrus: LINKED_LIST [AFX_AST_STRUCTURE_NODE]]; a_sol: like type_anchor; a_solved_expr: AFX_EXPRESSION)
							do
								generate_afore_fixes_for_precondition_violation (a_location, a_sol, a_solved_expr)
							end (?, a_solution, l_solution_expr),

						agent (a_location: TUPLE [scope_level: INTEGER; instrus: LINKED_LIST [AFX_AST_STRUCTURE_NODE]]): BOOLEAN
							do
								Result := a_location.scope_level = 1 and a_location.instrus.count <=1
							end)
				end
			else
					-- Give up.
			end
		end

	generate_afore_fixes_for_precondition_violation (a_fixing_location: TUPLE [scope_level: INTEGER; instructions: LINKED_LIST [AFX_AST_STRUCTURE_NODE]]; a_solution: like type_anchor; a_solved_expression: AFX_EXPRESSION)
			-- Generate afore fixes for precondition violation for `a_fixing_location'.
		require
			scope_level_valid: a_fixing_location.scope_level = 1
			instructions_valid: a_fixing_location.instructions.count <= 1
		local
			l_new_exp: AFX_AST_EXPRESSION
			l_old_ast: detachable AST_EIFFEL
			l_new_ast: AST_EIFFEL
			l_fix_skeleton: AFX_IMMEDIATE_AFORE_FIX_SKELETON
			l_ranking: AFX_FIX_RANKING
			l_text: STRING
			l_old_free_text: STRING
		do
				-- Generate fix: (p is the failing assertion)
				-- if not p then
				-- 		snippet
				-- end
				-- original code
			if a_fixing_location.instructions.is_empty then
				l_old_ast := Void
			else
				l_old_ast := a_fixing_location.instructions.first.ast.ast
			end

			fixme ("The above method of removing old expression is not should. Refactoring is needed. 7.1.2009 Jasonw")
			l_old_free_text := a_solved_expression.text.twin
			l_old_free_text.replace_substring_all ("old ", "")
			l_new_ast := ast_from_text (a_solution.constrained_expression.text + " := " + l_old_free_text)
			check l_new_ast /= Void end

				-- Construct ranking for fix skeleton.
			create l_ranking
			l_ranking.set_fix_skeleton_complexity (afore_skeleton_complexity)
			l_ranking.set_relevant_instructions (a_fixing_location.instructions.count)
			l_ranking.set_scope_levels (1)
			l_ranking.set_snippet_complexity (1)

				-- Construct fix skeleton.
			create l_fix_skeleton.make (exception_spot, config, test_case_execution_status)
			l_fix_skeleton.set_guard_condition (exception_spot.failing_assertion.negated)
			l_fix_skeleton.set_original_ast (l_old_ast)
			l_fix_skeleton.set_new_ast (l_new_ast)
			l_fix_skeleton.set_ranking (l_ranking)

			fixes.extend (l_fix_skeleton)
		end

	generate_wraping_fixes_for_precondition_violation (a_fixing_location: TUPLE [scope_level: INTEGER; instructions: LINKED_LIST [AFX_AST_STRUCTURE_NODE]]; a_solution: like type_anchor; a_solved_expression: AFX_EXPRESSION)
			-- Generate wrapping fixes for precondition violation for `a_fixing_location'.
		require
			scope_level_valid: a_fixing_location.scope_level = 1
			instructions_valid: a_fixing_location.instructions.count = 1
		local
			l_arg_index: INTEGER
			l_actual_argument: AFX_EXPRESSION
			l_replacer: AFX_ACTUAL_PARAMETER_REPLACER
			l_old_ast: AST_EIFFEL
			l_new_ast: AST_EIFFEL
			l_fix_skeleton: AFX_IMMEDIATE_WRAP_FIX_SKELETON
			l_ranking: AFX_FIX_RANKING
		do
				-- Generate fix: (p is the failing assertion)
				-- if p then
				-- 		original code
				-- else
				-- 		snippet (same as original code except that the constrained expression is replaced by the solution expression.)
				-- end

				-- Get the new ast node with actual argument replaced with the linear constrained solution.
			check a_solution.constrained_expression.is_argument end
			l_arg_index := arguments_of_feature (exception_spot.feature_of_failing_assertion).item (a_solution.constrained_expression.text)
			l_actual_argument := exception_spot.actual_arguments_in_failing_assertion.item (l_arg_index)
			l_old_ast := a_fixing_location.instructions.first.ast.ast
			create l_replacer
			l_replacer.replace (l_old_ast, exception_spot.feature_of_failing_assertion, l_arg_index, a_solved_expression.ast, exception_spot.recipient_written_class)
			l_new_ast := l_replacer.last_ast

				-- Construct ranking for fix skeleton.
			create l_ranking
			l_ranking.set_fix_skeleton_complexity (wrapping_skeleton_complexity)
			l_ranking.set_relevant_instructions (1)
			l_ranking.set_scope_levels (1)
			l_ranking.set_snippet_complexity (1)

				-- Construct fix skeleton.
			create l_fix_skeleton.make (exception_spot, exception_spot.failing_assertion, config, test_case_execution_status)
			l_fix_skeleton.set_guard_condition (exception_spot.failing_assertion)
			l_fix_skeleton.set_original_ast (l_old_ast)
			l_fix_skeleton.set_new_ast (l_new_ast)
			l_fix_skeleton.set_ranking (l_ranking)

			fixes.extend (l_fix_skeleton)
		end

	constrained_solutions (a_constrain_possibilities: like constrain_possibilities): LINKED_LIST [like type_anchor]
			-- A list of solutions for constrained problems defined in `a_constrain_possibilities'
		local
			l_maximizer: AFX_MATHEMATICA_SYMBOLIC_CONSTRAINT_SOLVER
			l_minimizer: AFX_MATHEMATICA_SYMBOLIC_CONSTRAINT_SOLVER
			l_constrained_exprs: DS_HASH_SET [AFX_EXPRESSION]
			l_arguments: LINKED_LIST [AFX_EXPRESSION]
			l_solutions: DS_HASH_SET [AFX_EXPRESSION]
			l_constrained_expr: AFX_EXPRESSION
			l_sol: AFX_AST_EXPRESSION
		do
			create Result.make

				-- Solve the linear constrained problem.
			from
				a_constrain_possibilities.start
			until
				a_constrain_possibilities.after
			loop
					-- Generate solutions for every constrain possibility because it cannot be decided
					-- for sure, which expression is constrained, and which ones are constraining.
				l_constrained_exprs := a_constrain_possibilities.item_for_iteration.constrained_expressions
				create l_solutions.make (10)
				l_solutions.set_equality_tester (expression_equality_tester)
				from
					l_constrained_exprs.start
				until
					l_constrained_exprs.after
				loop
					l_constrained_expr := l_constrained_exprs.item_for_iteration
					create l_arguments.make
					l_arguments.extend (l_constrained_expr)
						-- Get a maximized solution and a minimized solution.
					solve_and_append_solution (True, l_constrained_expr, constrained_expressions, l_arguments, l_solutions)
					solve_and_append_solution (False, l_constrained_expr, constrained_expressions, l_arguments, l_solutions)

--					create l_sol.make_with_text (l_constrained_expr.class_, l_constrained_expr.feature_, "1", l_constrained_expr.class_)
--					l_solutions.force_last (l_sol)
--					create l_sol.make_with_text (l_constrained_expr.class_, l_constrained_expr.feature_, "count", l_constrained_expr.class_)
--					l_solutions.force_last (l_sol)

					from
						l_solutions.start
					until
						l_solutions.after
					loop
						Result.extend ([l_constrained_expr, l_solutions.item_for_iteration, a_constrain_possibilities.item_for_iteration.constrained_expressions, a_constrain_possibilities.item_for_iteration.constraining_expressions])
						l_solutions.forth
					end
					l_constrained_exprs.forth
				end
				a_constrain_possibilities.forth
			end
		end

end
