note
	description: "Represents an expression in a contract"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_CONTRACT_EXPRESSION
create
	make_postcondition,
	make_precondition,
	make_invariant

feature {NONE} -- Creation

	make_postcondition (a_expression: like expression; a_source_feature: attached like source_feature)
			-- Make with `a_expression' and `a_source_feature'
		require
			non_void: a_expression /= void and a_source_feature /= void
			is_complete: a_expression.is_complete
		do
			expression := a_expression
			source_feature := a_source_feature
			source_class := a_source_feature.written_class

			is_postcondition := true
		end

	make_precondition (a_expression: like expression; a_source_feature: attached like source_feature)
			-- Make with `a_expression' and `a_source_feature'
		require
			non_void: a_expression /= void and a_source_feature /= void
			is_complete: a_expression.is_complete
		do
			expression := a_expression
			source_feature := a_source_feature
			source_class := a_source_feature.written_class

			is_precondition := true
		end

	make_invariant (a_expression: like expression; a_source_class: like source_class)
			-- Make with `a_expression' and `a_source_class'
		require
			non_void: a_expression /= void and a_source_class /= void
			is_complete: a_expression.is_complete
		do
			expression := a_expression
			source_class := a_source_class

			is_invariant := true
		end

feature -- Access

	expression: TAGGED_AS
			-- AST node containing the expression

	is_precondition: BOOLEAN
			-- Is `Current' a precondition?

	is_postcondition: BOOLEAN
			-- Is `Current' a postcondition?

	is_invariant: BOOLEAN
			-- Is `Current' an invariant?

	source_class: CLASS_C
			-- Source class of the expression

	source_feature: detachable FEATURE_I
			-- Source feature of the expression

invariant
	has_expression: expression /= void
	has_source_class: source_class /= void
	has_source_feature: (is_precondition or is_postcondition) implies source_feature /= void
	expr_is_complete: expression.is_complete
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
