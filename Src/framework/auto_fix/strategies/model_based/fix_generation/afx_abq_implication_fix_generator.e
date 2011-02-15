note
	description: "Summary description for {AFX_ABQ_IMPLICATION_FIX_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_ABQ_IMPLICATION_FIX_GENERATOR

inherit
	AFX_ASSERTION_STRUCTURE_BASED_FIX_GENERATOR
		redefine
			structure_analyzer
		end

create
	make

feature -- Access

	structure_analyzer: EPA_ABQ_IMPLICATION_STRUCTURE_ANALYZER
			-- Failing assertion structure analyzer

feature -- Basic operations

	generate
			-- Generate fixes into `fixes'.
		do
			if config.is_afore_fix_enabled then
				fixing_locations.do_all (agent generate_afore_fixes)
			end

			if config.is_wrapping_fix_enabled then
				fixing_locations.do_if (
					agent generate_wrapping_fixes,
						-- Only generate fix if the wrapped ast is not empty.
					agent (data: TUPLE [scope_level: INTEGER_32; instructions: LINKED_LIST [AFX_AST_STRUCTURE_NODE]]): BOOLEAN
						do
							Result := not data.instructions.is_empty
						end)
			end
		end

feature{NONE} -- Implementation

	generate_afore_fixes (a_fixing_location: TUPLE [scope_level: INTEGER; instructions: LINKED_LIST [AFX_AST_STRUCTURE_NODE]])
			-- Generate afore fixes for `a_fixing_location' and
			-- store results in fixes'.
		local
			l_fix: AFX_AFORE_FIX_SKELETON
			l_failing_assert: EPA_EXPRESSION
			l_negated_failing_assert: EPA_EXPRESSION
			l_value: EPA_BOOLEAN_VALUE
			l_premise: EPA_EXPRESSION
			l_consequent: EPA_EXPRESSION
			l_negated_premise: EPA_EXPRESSION
		do
				-- Initialize.
			create l_value.make (True)
			l_failing_assert := exception_spot.failing_assertion
			l_negated_failing_assert := not l_failing_assert
			l_premise := structure_analyzer.premise
			l_consequent := structure_analyzer.consequent


				-- Generate fix: (p -> q is the failing assertion)
				-- if p then
				-- 		snippet
				--		require: not q ^ p
				--		ensure: q
				-- end
			fixes.extend (
				new_afore_fix_skeleton (
					exception_spot,
					a_fixing_location.instructions,
					l_premise,
					equation_as_state (equation_with_value ((not l_consequent), l_value)).union (equation_as_state (equation_with_value (l_premise, l_value))),
					equation_as_state (equation_with_value (l_consequent, l_value)),
					a_fixing_location.scope_level, False))

				-- Generate fix: (p -> q is the failing assertion)
				-- if p then
				-- 		snippet
				--		require: F_inv
				--		ensure:  S_inv - F_inv
				-- end
			fixes.extend (
				new_afore_fix_skeleton (
					exception_spot,
					a_fixing_location.instructions,
					l_premise,
					create {AFX_DELAYED_STATE}.make_as_failing_invariants,
					create {AFX_DELAYED_STATE}.make_as_passing_substracted_from_failing_invariants,
					a_fixing_location.scope_level, False))

				-- Generate fix: (p -> q is the failing assertion)
				-- if not (p -> q) then
				-- 		snippet
				--		require: F_inv
				--		ensure:  S_inv - F_inv
				-- end
			l_negated_premise := not l_premise
			fixes.extend (
				new_afore_fix_skeleton (
					exception_spot,
					a_fixing_location.instructions,
					l_negated_premise,
					create {AFX_DELAYED_STATE}.make_as_failing_invariants,
					create {AFX_DELAYED_STATE}.make_as_passing_substracted_from_failing_invariants,
					a_fixing_location.scope_level, True))
		end

	generate_wrapping_fixes (a_fixing_location: TUPLE [scope_level: INTEGER; instructions: LINKED_LIST [AFX_AST_STRUCTURE_NODE]])
			-- Generate wrapping fixes for `a_fixing_location' and
			-- store results in fixes'.
		local
			l_failing_assert: EPA_EXPRESSION
			l_negated_failing_assert: EPA_EXPRESSION
			l_value: EPA_BOOLEAN_VALUE
			l_premise: EPA_EXPRESSION
			l_consequent: EPA_EXPRESSION
		do
			if not a_fixing_location.is_empty then
					-- Initialize.
				create l_value.make (True)
				l_failing_assert := exception_spot.failing_assertion
				l_negated_failing_assert := not l_failing_assert
				l_premise := structure_analyzer.premise
				l_consequent := structure_analyzer.consequent

					-- Generate fix: (p -> q is the failing assertion)
					-- if p -> q then
					--		a_fixing_locaiton
					-- else
					--		snippet
					--			require: F_inv
					--			ensure:  S_inv - F_inv
					-- end
				fixes.extend (
					new_wrapping_fix_skeleton (
						exception_spot,
						a_fixing_location.instructions,
						l_failing_assert,
						create {AFX_DELAYED_STATE}.make_as_failing_invariants,
						create {AFX_DELAYED_STATE}.make_as_passing_substracted_from_failing_invariants,
						a_fixing_location.scope_level, False))

--					-- Generate fix: (p -> q is the failing assertion)
--					-- if p -> q then
--					--		a_fixing_locaiton
--					-- else
--					--		snippet
--					--			require: p
--					--			ensure: delayed
--					-- end
--				fixes.extend (new_wrapping_fix_skeleton (
--					exception_spot, a_fixing_location.instructions, l_failing_assert, l_premise.equation (l_value), Void, a_fixing_location.scope_level))
			end
		end
end
