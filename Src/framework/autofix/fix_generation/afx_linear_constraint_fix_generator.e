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

create
	make

feature -- Access

	structure_analyzer: AFX_LINEAR_CONSTRAINED_EXPRESSION_STRUCTURE_ANALYZER
			-- Failing assertion structure analyzer

feature -- Basic operations

	generate
			-- Generate fixes into `fixes'.
		do
			constraints := structure_analyzer.constraints
			create relevant_constraints.make
			relevant_constraints.merge (constraints)

			collect_relevant_constraints
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
			l_removed: LINKED_LIST [AFX_EXPRESSION]
			l_cir: ARRAYED_CIRCULAR [ANY]
			l_cursor: CURSOR
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
			if not l_temp.is_empty then
				from
					l_done := False
				until
					l_done
				loop
					l_done := True
					from
						create l_removed.make
						l_temp.start
					until
						l_temp.after
					loop
						if not l_temp.item_for_iteration.components.is_subset (l_rev_components) then
							l_removed.extend (l_temp.key_for_iteration)
							l_rev_components.append (l_temp.item_for_iteration.components)
							relevant_constraints.merge (l_temp.item_for_iteration)
							if l_done then
								l_done := False
							end
						end
						l_temp.forth
					end
				end
			end

			from
				l_temp.start
			until
				l_temp.after
			loop
				l_constraints.remove (l_temp.key_for_iteration)
				l_temp.forth
			end
			constraint_table := l_constraints

		end

end
