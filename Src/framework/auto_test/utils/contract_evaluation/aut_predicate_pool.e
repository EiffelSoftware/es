note
	description: "Summary description for {AUT_PREDICATE_POOL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PREDICATE_POOL

inherit
	AUT_SHARED_PREDICATE_CONTEXT
	REFACTORING_HELPER

create
	make

feature{NONE} -- Initialization

	make is
			-- Initialize current
		do
				-- Uses `equal' for key comparison
			create predicate_valuation_table.make_default
		end

feature -- Access

	candidates (a_constraint: AUT_PREDICATE_CONSTRAINT; a_max_solution_count: INTEGER): DS_LINKED_LIST [ARRAY [detachable ITP_VARIABLE]] is
			-- Candidate object combinations satisfy `a_constraint'.
			-- Return at most `a_max_solution_count' candidates.
			-- The returned candidates are randomly selected from the candidate space.
			-- If `a_max_solution_count' is 0, all satisfying candidates are returned.
		require
			a_constraint_attached: a_constraint /= Void
			a_max_solution_count_non_negative: a_max_solution_count >= 0
		local
			l_candidate: ARRAY [detachable ITP_VARIABLE]
			l_quick_sorter: DS_ARRAY_QUICK_SORTER [AUT_PREDICATE]
			l_less_than_tester: AGENT_BASED_EQUALITY_TESTER [AUT_PREDICATE]
			l_sorted_predicates: ARRAY [AUT_PREDICATE]
			i: INTEGER
				-- working structure:
				--  the inner ARRAY [ITP_VARIABLE] is a satisfying combination of the predicate valuation
				--  the middle ARRAY is the list of satisfying combinations
				--  the outer ARRAY is one item per predicate
				-- so: each predicate has a list of satisfying combinations for its valuation
			l_working_structure: ARRAY [ARRAY [ARRAY [ITP_VARIABLE]]]
			l_iteration_combinations: ARRAY [ARRAY [ITP_VARIABLE]]
			l_combination: ARRAY [ITP_VARIABLE]
		do
				-- Use `=' as comparison criterion
			create Result.make_default

				-- Construct array of predicates
			from
				create l_sorted_predicates.make (1, a_constraint.argument_mapping.keys.count)
				i := 1
				a_constraint.argument_mapping.keys.start
			until
				a_constraint.argument_mapping.keys.after
			loop
				l_sorted_predicates.force (a_constraint.argument_mapping.keys.item_for_iteration, i)
				i := i + 1
				a_constraint.argument_mapping.keys.forth
			end

				-- Sort the list according to their number of satisfying combinations
			create l_less_than_tester.make (agent (a, b: AUT_PREDICATE): BOOLEAN
					do
						Result := predicate_valuation_table.item (a).satisfying_combinations_count < predicate_valuation_table.item (b).satisfying_combinations_count
					end)
			create l_quick_sorter.make (l_less_than_tester)
			l_quick_sorter.sort (l_sorted_predicates)

				-- Create the sorted working structure (shares index with l_sorted_predicates)
			create l_working_structure.make (1, l_sorted_predicates.count)
			from
				i := l_sorted_predicates.lower
			until
				i = l_sorted_predicates.upper
			loop
				l_iteration_combinations := predicate_valuation_table.item (l_sorted_predicates.item (i)).satisfying_object_combinations_as_array
				l_working_structure.force (l_iteration_combinations, i)
				i := i + 1
			end

				fixme ("TO IMPLEMENT")
				-- Sketch of algorithm:
				--
				-- repeat
				--   create an empty l_candidate
				--   loop over l_sorted_predicates
				--     randomly select a satisfying combination for the predicate valuation, taking the fixed variables in l_candidate into account
				--     add the variables of the satisfying combination into l_candidate at the correct index
				--     continue with the next predicate or backtrack if no satisfying combination found
				--   add l_candidate into Result
				-- until Result has `a_max_solution_count' candidates (or until all candidates are found if `a_max_solution_count' = 0)
				fixme ("TO IMPLEMENT")

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
			a_arguments_items_attached: not a_arguments.has (Void)
		local
			l_argument_mapping: DS_HASH_TABLE [DS_HASH_TABLE [INTEGER, INTEGER], AUT_PREDICATE]
			l_iteration_predicate: AUT_PREDICATE
			l_break: BOOLEAN
			l_iteration_predicate_valuation: AUT_PREDICATE_VALUATION
			l_valuation_satisfied: BOOLEAN
			l_mapped_arguments_array: ARRAY [ITP_VARIABLE]
			i: INTEGER
		do
			l_argument_mapping := a_constraint.argument_mapping
			Result := true

			from
				l_break := false
				l_argument_mapping.start
			until
				l_argument_mapping.after or else l_break
			loop
				l_iteration_predicate := l_argument_mapping.key_for_iteration

				if not predicate_valuation_table.has (l_iteration_predicate) then
					l_break := true
				else
					l_iteration_predicate_valuation := predicate_valuation_table.item (l_iteration_predicate)

					if l_iteration_predicate_valuation.arity = 0 then
--						l_valuation_satisfied := l_iteration_predicate_valuation.is_satisfying_combination (create {ARRAY [ITP_VARIABLE]}.make (0, 0))
						fixme ("to implement: nullary predicate valuations")
					else
							-- Create a new arguments array, mapped to predicate argument index
						from
							create l_mapped_arguments_array.make (1, l_iteration_predicate_valuation.arity)
							i := 1
						until
							i = l_iteration_predicate_valuation.arity
						loop
							l_mapped_arguments_array.force (a_arguments.item (l_argument_mapping.item_for_iteration.item (i)), i)
						end

						l_valuation_satisfied := l_iteration_predicate_valuation.is_satisfying_combination (l_mapped_arguments_array)
					end

					if not l_valuation_satisfied then
						l_break := true
					end
				end

				l_argument_mapping.forth
			end

			if l_break then
				Result := false
			end
		end

	is_predicate_satisfied (a_predicate: AUT_PREDICATE; a_arguments: ARRAY [ITP_VARIABLE]): BOOLEAN is
			-- Is `a_arguments' satisfy `a_predicate'?
		require
			a_predicate_attached: a_predicate /= Void
			a_predicate_exist: predicates.has (a_predicate)
			a_arguments_attached: a_arguments /= Void
			a_arguments_valid: a_predicate.arity = a_arguments.count and then a_arguments.lower = 1
			a_arguments_items_attached: not a_arguments.has (Void)
		do
			if not predicate_valuation_table.has (a_predicate) then
				Result := false
			else
				Result := predicate_valuation_table.item (a_predicate).is_satisfying_combination (a_arguments)
			end
		end

feature -- Basic operations

	update_predicate_valuation (a_predicate: AUT_PREDICATE; a_arguments: ARRAY [ITP_VARIABLE]; a_valuation: BOOLEAN) is
			-- Update the valuation of `a_predicate' with `a_arguments' to `a_valuation'.
		require
			a_predicate_attached: a_predicate /= Void
			a_predicate_exist: predicates.has (a_predicate)
			a_arguments_attached: a_arguments /= Void
			a_arguments_valid: a_predicate.arity = a_arguments.count and then a_arguments.lower = 1
			a_arguments_items_attached: not a_arguments.has (Void)
		local
			l_predicate_valuation: AUT_PREDICATE_VALUATION
		do
			if predicate_valuation_table.has (a_predicate) then
				l_predicate_valuation := predicate_valuation_table.item (a_predicate)
			else
				if a_predicate.arity = 0 then
--					l_predicate_valuation := create {AUT_NULLARY_PREDICATE_VALUATION}.make (a_valuation)
					fixme ("to implement: nullary predicate valuations")
				else
					l_predicate_valuation := create {AUT_PREDICATE_VALUATION}.make (a_predicate)
				end

				predicate_valuation_table.put (l_predicate_valuation, a_predicate)
			end

			l_predicate_valuation.set_valuation (a_arguments, a_valuation)
		ensure
			predicate_valuation_table_has: predicate_valuation_table.has (a_predicate)
		end

feature{NONE} -- Implementation

	predicate_valuation_table: DS_HASH_TABLE [AUT_PREDICATE_VALUATION, AUT_PREDICATE]
			-- Table holding the valuation for each predicate

invariant
	predicate_valuation_table_attached: predicate_valuation_table /= Void
	predicate_valuation_table_valid: not predicate_valuation_table.has (Void) and not predicate_valuation_table.has_item (Void)

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
