note
	description: "Summary description for {AFX_ANY_STRUCTURE_FIX_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_ANY_STRUCTURE_FIX_GENERATOR

inherit
	AFX_ASSERTION_STRUCTURE_BASED_FIX_GENERATOR

create
	make

feature -- Basic operations

	generate
			-- Generate fixes into `fixes'.
		do
			fixing_locations.do_all (agent generate_afore_fixes)
			fixing_locations.do_if (
				agent generate_wrapping_fixes,
					-- Only generate fix if the wrapped ast is not empty.
				agent (data: TUPLE [scope_level: INTEGER_32; instructions: LINKED_LIST [AFX_AST_STRUCTURE_NODE]]): BOOLEAN
					do
						Result := not data.instructions.is_empty
					end)
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
				-- 	snippet
				--		require: delayed
				--		ensure: delayed
			fixes.extend (new_afore_fix_skeleton (
				exception_spot, a_fixing_location.instructions, Void, Void, Void, a_fixing_location.scope_level))


				-- Generate fix: (p is the failing assertion)
				-- if not p then
				-- 		snippet
				--			require: delayed
				--			ensure: delayed
				-- end
			fixes.extend (new_afore_fix_skeleton (
				exception_spot, a_fixing_location.instructions, l_negated_failing_assert, Void, Void, a_fixing_location.scope_level))
		end

	generate_wrapping_fixes (a_fixing_location: TUPLE [scope_level: INTEGER; instructions: LINKED_LIST [AFX_AST_STRUCTURE_NODE]])
			-- Generate wrapping fixes for `a_fixing_location' and
			-- store results in fixes'.
		local
			l_failing_assert: AFX_EXPRESSION
			l_negated_failing_assert: AFX_EXPRESSION
			l_value: AFX_BOOLEAN_VALUE
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
					--			require: delayed
					--			ensure: delayed
					-- end
				fixes.extend (new_wrapping_fix_skeleton (
					exception_spot, a_fixing_location.instructions, l_failing_assert, Void, Void, a_fixing_location.scope_level))
			end
		end

end
