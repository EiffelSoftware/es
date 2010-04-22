note
	description: "Represents an expression in a contract"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_CONTRACT_EXPRESSION
create
	make_pre_post,
	make_invariant

feature {NONE} -- Creation

	make_pre_post (a_assertion_list: ASSERT_LIST_AS; a_source_feature: attached like source_feature)
			-- Make with `a_assertion_list' and `a_source_feature'
		require
			non_void: a_assertion_list /= void and a_source_feature /= void
		do
			assertions := a_assertion_list.assertions

			if attached {REQUIRE_ELSE_AS} a_assertion_list then
				is_require_else := true
			elseif attached {ENSURE_THEN_AS} a_assertion_list then
				is_ensure_then := true
			elseif attached {REQUIRE_AS} a_assertion_list then
				is_require := true
			elseif attached {ENSURE_AS} a_assertion_list then
				is_ensure := true
			else
				-- Should never happen
				check
					false
				end
			end

			source_feature := a_source_feature
			source_class := a_source_feature.written_class
		end

	make_invariant (a_invariant: INVARIANT_AS; a_source_class: like source_class)
			-- Make with `a_invariant' and `a_source_class'
		require
			non_void: a_invariant /= void and a_source_class /= void
		do
			assertions := a_invariant.assertion_list
			source_class := a_source_class

			is_invariant := true
		end

feature -- Access

	assertions: EIFFEL_LIST [TAGGED_AS]
			-- AST node containing the expressions

	is_require: BOOLEAN
			-- Is `Current' a require-precondition?

	is_ensure: BOOLEAN
			-- Is `Current' an ensure-postcondition?

	is_ensure_then: BOOLEAN
			-- Is `Current' an ensure-then-postcondition?

	is_require_else: BOOLEAN
			-- Is `Current' a require-else-precondition?

	is_precondition: BOOLEAN
			-- Is `Current' a precondition?
		do
			Result := is_require or is_require_else
		end

	is_postcondition: BOOLEAN
			-- Is `Current' a postcondition?
		do
			Result := is_ensure or is_ensure_then
		end

	is_invariant: BOOLEAN
			-- Is `Current' an invariant?

	source_class: CLASS_C
			-- Source class of the expression

	source_feature: detachable FEATURE_I
			-- Source feature of the expression

invariant
	has_assertions: assertions /= void
	has_source_class: source_class /= void
	has_source_feature: (is_precondition or is_postcondition) implies source_feature /= void
note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
