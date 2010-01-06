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
			l_maximizer: AFX_MATHEMATICA_SYMBOLIC_CONSTRAINT_SOLVER
			l_minimizer: AFX_MATHEMATICA_SYMBOLIC_CONSTRAINT_SOLVER
			l_possibilities: like constrain_possibilities
			l_constrained_exprs: DS_HASH_SET [AFX_EXPRESSION]
			l_arguments: LINKED_LIST [AFX_EXPRESSION]
			l_solutions: DS_HASH_SET [AFX_EXPRESSION]
		do
				-- Analyze the linear constrained problem.
			constraints := structure_analyzer.constraints
			create relevant_constraints.make (Void)
			relevant_constraints.merge (constraints)
			collect_relevant_constraints

				-- Solve the linear constrained problem.
			l_possibilities := constrain_possibilities
			create l_solutions.make (10)
			l_solutions.set_equality_tester (expression_equality_tester)
			from
				l_possibilities.start
			until
				l_possibilities.after
			loop
					-- Generate solutions for every constrain possibility because it cannot be decided
					-- for sure, which expression is constrained, and which ones are constraining.
				l_constrained_exprs := l_possibilities.item_for_iteration.constrained_expressions
				from
					l_constrained_exprs.start
				until
					l_constrained_exprs.after
				loop
					create l_arguments.make
					l_arguments.extend (l_constrained_exprs.item_for_iteration)
						-- Get a maximized solution and a minimized solution.
					solve_and_append_solution (True, l_constrained_exprs.item_for_iteration, constrained_expressions, l_arguments, l_solutions)
					solve_and_append_solution (False, l_constrained_exprs.item_for_iteration, constrained_expressions, l_arguments, l_solutions)
					l_constrained_exprs.forth
				end
				l_possibilities.forth
			end

--			from
--				l_solutions.start
--			until
--				l_solutions.after
--			loop
--				io.put_string (l_solutions.item_for_iteration.text + "%N")
--				l_solutions.forth
--			end
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

			l_feat := exception_spot.recipient_
			l_class := exception_spot.recipient_class_
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

end
