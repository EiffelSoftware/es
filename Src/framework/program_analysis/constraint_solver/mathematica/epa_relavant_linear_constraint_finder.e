note
	description: "Find relevant linear constraints from a given set of expressions"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_RELAVANT_LINEAR_CONSTRAINT_FINDER

inherit
	EPA_SHARED_EQUALITY_TESTERS

	EPA_UTILITY

	EPA_CONTRACT_EXTRACTOR

feature -- Access

	relevant_constraints: EPA_NUMERIC_CONSTRAINTS
			-- Contraints relevant to `constraints'
			-- `relevant_constriants' is a super set of `constraints'.

	constraint_table: DS_HASH_TABLE [EPA_NUMERIC_CONSTRAINTS, EPA_EXPRESSION]
			-- Table of contraints.
			-- Key is the assertion from which the contraint comes,
			-- value is that constraint.

	constraining_expressions: LINKED_LIST [EPA_EXPRESSION]
			-- Constrained expressions
			-- This list contains the keys of `constraint_table'

feature -- Basic operations

	calculate (a_constraints: EPA_NUMERIC_CONSTRAINTS; a_asertions: DS_HASH_SET [EPA_EXPRESSION])
			-- Calculate constraints from `a_assertions' that are relevant to `a_constarnts',
			-- make results available in `relevant_constraints', `constraint_table' and `constraining_expressions'.
		require
			a_constraint_valid: a_constraints.expression /= Void
		do
				-- Initialize data structures.
			create relevant_constraints.make (Void)
			relevant_constraints.merge (a_constraints)
			create constraint_table.make (5)
			constraint_table.set_key_equality_tester (expression_equality_tester)
			create constraining_expressions.make
			constraining_expressions.extend (a_constraints.expression)
			constraint_table.put (a_constraints, a_constraints.expression)

				-- Calculate relevant constraints.
			collect_relevant_constraints (a_constraints, a_asertions)
		end

feature{NONE} -- Implementation

	collect_relevant_constraints (a_constraints: EPA_NUMERIC_CONSTRAINTS; a_assertions: DS_HASH_SET [EPA_EXPRESSION])
			-- Collect numeric constrained assertions which are relevant to the failing assertion,
			-- store result in `constraints'.
		require
			a_constraints_has_expression: attached a_constraints.expression
		local
			l_constraint_analyzer: EPA_LINEAR_CONSTRAINED_EXPRESSION_STRUCTURE_ANALYZER
			l_constraints, l_temp: like constraint_table
			l_rev_components: DS_HASH_SET [EPA_EXPRESSION]
			l_done: BOOLEAN
			l_kept: DS_HASH_SET [EPA_EXPRESSION]
			l_cir: ARRAYED_CIRCULAR [ANY]
			l_cursor: CURSOR
			l_removed: LINKED_LIST [EPA_EXPRESSION]
		do
				-- Find out only numeric constrained assertions.
			create l_constraint_analyzer
			create l_constraints.make (a_assertions.count)
			l_constraints.set_key_equality_tester (expression_equality_tester)
			from
				a_assertions.start
			until
				a_assertions.after
			loop
				l_constraint_analyzer.analyze (a_assertions.item_for_iteration)
				if l_constraint_analyzer.is_matched then
					l_constraints.force_last (l_constraint_analyzer.constraints, a_assertions.item_for_iteration)
				end
				a_assertions.forth
			end

				-- Collect constraints relevant to `constraint', keep them in `l_constraints'.			
			create l_rev_components.make (20)
			l_rev_components.set_equality_tester (expression_equality_tester)
			l_rev_components.append (a_constraints.components)

			create l_kept.make (5)
			l_kept.set_equality_tester (expression_equality_tester)
			l_kept.force_last (a_constraints.expression)

			if not l_constraints.is_empty then
				l_temp := l_constraints.twin
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

				-- Construct `constraint_table' and `constraining_expressions'.
			from
				l_constraints.start
			until
				l_constraints.after
			loop
				if l_kept.has (l_constraints.key_for_iteration) then
					constraint_table.force_last (l_constraints.item_for_iteration, l_constraints.key_for_iteration)
					constraining_expressions.extend (l_constraints.key_for_iteration)
				end
				l_constraints.forth
			end
		end

end
