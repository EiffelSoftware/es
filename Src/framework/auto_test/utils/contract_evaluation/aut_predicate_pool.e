note
	description: "Summary description for {AUT_PREDICATE_POOL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PREDICATE_POOL

inherit
	AUT_SHARED_PREDICATE_CONTEXT

feature -- Access

	candidates (a_constraint: AUT_PREDICATE_CONSTRAINT; a_max_solution_count: INTEGER): DS_LINKED_LIST [ARRAY [detachable ITP_VARIABLE]] is
			-- Candidate object combinations satisfy `a_constraint'.
			-- Return at most `a_max_solution_count' candidates.
			-- The returned candidates are randomly selected from the candidate space.
			-- If `a_max_solution_count' is 0, all satisfying candidates are returned.
		require
			a_constraint_attached: a_constraint /= Void
			a_max_solution_count_non_negative: a_max_solution_count >= 0
		do
		ensure
			result_attached: Result /= Void
		end

feature -- Status report

	is_candidate_satisfied (a_constraint: AUT_PREDICATE_CONSTRAINT; a_arguments: ARRAY [ITP_VARIABLE]): BOOLEAN is
			-- Is `a_arguments' satisfy `a_constraint'?
		require
			a_constraint_attached: a_constraint /= Void
			a_arguments_attached: a_arguments /= Void
			a_arguments_valid: a_constraint.distinct_argument_count = a_arguments.count and then a_arguments.lower = 0
		do
		end

	is_predicate_satisfied (a_predicate: AUT_PREDICATE; a_arguments: ARRAY [ITP_VARIABLE]): BOOLEAN is
			-- Is `a_arguments' satisfy `a_predicate'?
		require
			a_predicate_attached: a_predicate /= Void
			a_predicate_exist: predicates.has (a_predicate)
			a_arguments_attached: a_arguments /= Void
			a_arguments_valid: a_predicate.arity = a_arguments.count and then a_arguments.lower = 1
		do
		end

feature -- Basic operations

	update_predicate_valuation (a_predicate: AUT_PREDICATE; a_arguments: ARRAY [ITP_VARIABLE]; a_valuation: BOOLEAN) is
			-- Update the valuation of `a_predicate' with `a_arguments' to `a_valuation'.
		require
			a_predicate_attached: a_predicate /= Void
			a_predicate_exist: predicates.has (a_predicate)
			a_arguments_attached: a_arguments /= Void
			a_arguments_valid: a_predicate.arity = a_arguments.count and then a_arguments.lower = 1
		do
		end

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
