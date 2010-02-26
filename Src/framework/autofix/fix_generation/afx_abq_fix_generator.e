note
	description: "Summary description for {AFX_ABQ_FIX_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_ABQ_FIX_GENERATOR

inherit
	AFX_ASSERTION_STRUCTURE_BASED_FIX_GENERATOR

create
	make

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
			l_failing_assert: AFX_EXPRESSION
			l_negated_failing_assert: AFX_EXPRESSION
			l_value: AFX_BOOLEAN_VALUE
		do
				-- Initialize.
			create l_value.make (True)
			l_failing_assert := exception_spot.failing_assertion
			l_negated_failing_assert := not l_failing_assert

				-- Generate fix: (p is the failing assertion)
				-- snippet
				--		require: not p
				--		ensure: p
			fixes.extend (
				new_afore_fix_skeleton (
					exception_spot,
					a_fixing_location.instructions,
					Void,
					equation_as_state (l_negated_failing_assert.equation (l_value)),
					equation_as_state (l_failing_assert.equation (l_value)),
					a_fixing_location.scope_level, False))

				-- Generate fix: (p is the failing assertion), simplified version.
				-- snippet
				--		require: not p
				--		ensure: p
			l_fix := new_afore_fix_skeleton (
						exception_spot,
						a_fixing_location.instructions,
						Void,
						equation_as_state (l_negated_failing_assert.equation (l_value)),
						equation_as_state (l_failing_assert.equation (l_value)),
						a_fixing_location.scope_level, False)
			l_fix.set_is_simplification_needed (True)
			fixes.extend (l_fix)

				-- Generate fix: (p is the failing assertion)
				-- snippet
				--		require: F_inv
				--		ensure:  S_inv - F_inv
			fixes.extend (
				new_afore_fix_skeleton (
					exception_spot,
					a_fixing_location.instructions,
					Void,
					create {AFX_DELAYED_STATE}.make_as_failing_invariants,
					create {AFX_DELAYED_STATE}.make_as_passing_substracted_from_failing_invariants,
					a_fixing_location.scope_level, False))

			if not a_fixing_location.is_empty then
					-- Generate fix: (p is the failing assertion)
					-- if not p then
					-- 		snippet
					-- end
					--		require: not p
					--		ensure: p
				fixes.extend (
					new_afore_fix_skeleton (
						exception_spot,
						a_fixing_location.instructions,
						l_negated_failing_assert,
						equation_as_state (l_negated_failing_assert.equation (l_value)),
						equation_as_state (l_failing_assert.equation (l_value)),
						a_fixing_location.scope_level, True))

					-- Generate fix: (p is the failing assertion), simplified version
					-- if not p then
					-- 		snippet
					-- end
					--		require: not p
					--		ensure: p
				l_fix :=
					new_afore_fix_skeleton (
						exception_spot,
						a_fixing_location.instructions,
						l_negated_failing_assert,
						equation_as_state (l_negated_failing_assert.equation (l_value)),
						equation_as_state (l_failing_assert.equation (l_value)),
						a_fixing_location.scope_level, True)
				l_fix.set_is_simplification_needed (True)
				fixes.extend (l_fix)

					-- Generate fix: (p is the failing assertion)
					-- if not p then
					-- 		snippet
					-- end
					--		require: F_inv
					--		ensure:  S_inv - F_inv
				fixes.extend (
					new_afore_fix_skeleton (
						exception_spot,
						a_fixing_location.instructions,
						l_negated_failing_assert,
						create {AFX_DELAYED_STATE}.make_as_failing_invariants,
						create {AFX_DELAYED_STATE}.make_as_passing_substracted_from_failing_invariants,
						a_fixing_location.scope_level, True))
			end
		end

	generate_wrapping_fixes (a_fixing_location: TUPLE [scope_level: INTEGER; instructions: LINKED_LIST [AFX_AST_STRUCTURE_NODE]])
			-- Generate wrapping fixes for `a_fixing_location' and
			-- store results in fixes'.
		local
			l_failing_assert: AFX_EXPRESSION
			l_negated_failing_assert: AFX_EXPRESSION
			l_value: AFX_BOOLEAN_VALUE
			l_fix: AFX_WRAP_FIX_SKELETON
		do
			if not a_fixing_location.is_empty then
					-- Initialize.
				create l_value.make (True)
				l_failing_assert := exception_spot.failing_assertion
				l_negated_failing_assert := not l_failing_assert

					-- Generate fix: (p is the failing assertion)
					-- if p then
					--		a_fixing_locaiton
					-- else
					--		snippet
					--			require: not p
					--			ensure: p
					-- end
				fixes.extend (
					new_wrapping_fix_skeleton (
						exception_spot,
						a_fixing_location.instructions,
						l_failing_assert,
						equation_as_state (l_negated_failing_assert.equation (l_value)),
						equation_as_state (l_failing_assert.equation (l_value)),
						a_fixing_location.scope_level, False))

					-- Generate fix: (p is the failing assertion), simplified version
					-- if p then
					--		a_fixing_locaiton
					-- else
					--		snippet
					--			require: not p
					--			ensure: p
					-- end
				l_fix :=
					new_wrapping_fix_skeleton (
						exception_spot,
						a_fixing_location.instructions,
						l_failing_assert,
						equation_as_state (l_negated_failing_assert.equation (l_value)),
						equation_as_state (l_failing_assert.equation (l_value)),
						a_fixing_location.scope_level, False)
				l_fix.set_is_simplification_needed (True)
				fixes.extend (l_fix)

					-- Generate fix: (p is the failing assertion)
					-- if p then
					--		a_fixing_locaiton
					-- else
					--		snippet
					--			require: not p
					--			ensure: S_inv - F_inv
					-- end
				fixes.extend (
					new_wrapping_fix_skeleton (
						exception_spot,
						a_fixing_location.instructions,
						l_failing_assert,
						equation_as_state (l_negated_failing_assert.equation (l_value)),
						create {AFX_DELAYED_STATE}.make_as_passing_substracted_from_failing_invariants,
						a_fixing_location.scope_level, False))


					-- Generate fix: (p is the failing assertion)
					-- if p then
					--		a_fixing_locaiton
					-- else
					--		snippet
					--			require: F_inv
					--			ensure: S_inv - F_inv
					-- end
				fixes.extend (
					new_wrapping_fix_skeleton (
						exception_spot,
						a_fixing_location.instructions,
						l_failing_assert,
						create {AFX_DELAYED_STATE}.make_as_failing_invariants,
						create {AFX_DELAYED_STATE}.make_as_passing_substracted_from_failing_invariants,
						a_fixing_location.scope_level, False))
			end
		end

end
