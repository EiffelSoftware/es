note
	description: "Summary description for {AUT_PREDICATE_VALUATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PREDICATE_VALUATION

inherit
	REFACTORING_HELPER

create
	make

feature{NONE} -- Initialization

	make (a_predicate: AUT_PREDICATE) is
			-- Initialize `Current'
		require
			a_predicate_attached: a_predicate /= Void
		do
			arity := a_predicate.arity

				-- key comparison on `equal'
			create satisfying_object_combinations.make_default
				-- key comparison on `equal'
			create unsatisfying_object_combinations.make_default
		end


feature -- Access

	arity: INTEGER
			-- Arity of the predicate valuation

	is_satisfying_combination (a_combination: ARRAY [ITP_VARIABLE]): BOOLEAN is
			-- Is `a_combination' a satifying combination?
		require
			a_combination_attached: a_combination /= Void
			a_combination_valid: not a_combination.has (Void)
			same_arity: a_combination.count = arity
			has_a_combination: has (a_combination)
		local
			l_hashable_array: AUT_HASHABLE_ITP_VARIABLE_ARRAY
		do
			create l_hashable_array.make_from_array (a_combination)
			Result := satisfying_object_combinations.has (l_hashable_array)
		end

	has (a_combination: ARRAY [ITP_VARIABLE]): BOOLEAN is
			-- Is there a valuation for combination `a_combination'?
		require
			a_combination_attached: a_combination /= Void
			a_combination_valid: not a_combination.has (Void)
			same_arity: a_combination.count = arity
		local
			l_hashable_array: AUT_HASHABLE_ITP_VARIABLE_ARRAY
		do
			create l_hashable_array.make_from_array (a_combination)
			Result := satisfying_object_combinations.has (l_hashable_array) or else unsatisfying_object_combinations.has (l_hashable_array)
		end

	satisfying_object_combinations_as_array: ARRAY [ARRAY [ITP_VARIABLE]] is
			-- Return the satisfying object combinations as an array
			-- DO NOT MODIFY THE RETURNED ARRAY, will invalidate hash_code
		local
			i: INTEGER
		do
			create Result.make (1, satisfying_object_combinations.count)

			from
				i := 1
				satisfying_object_combinations.start
			until
				satisfying_object_combinations.after
			loop
				Result.put (satisfying_object_combinations.item_for_iteration.as_array, i)
				i := i +1
				satisfying_object_combinations.forth
			end
		ensure
			result_attached: Result /= Void
			result_good_count: Result.count = satisfying_object_combinations.count
			result_items_attached: not Result.has (Void)
		end

	satisfying_combinations_count: INTEGER is
			-- Number of satisfying combinarions
		do
			Result := satisfying_object_combinations.count
		ensure
			good_result: Result = satisfying_object_combinations.count
		end


	associated_predicate: AUT_PREDICATE
			-- The predicate associated with the current valuation		

feature -- Setting

	set_valuation (a_combination: ARRAY [ITP_VARIABLE]; a_valuation: BOOLEAN) is
			-- Set the valuation on `a_combination' to `a_valuation'
		require
			a_combination_attached: a_combination /= Void
			a_combination_valid: not a_combination.has (Void)
			same_arity: a_combination.count = arity
		local
			l_hashable_array: AUT_HASHABLE_ITP_VARIABLE_ARRAY
		do
			create l_hashable_array.make_from_array (a_combination)

			if a_valuation = true then
				if unsatisfying_object_combinations.has (l_hashable_array) then
					unsatisfying_object_combinations.remove (l_hashable_array)
				end
				satisfying_object_combinations.force_last (l_hashable_array)
			else
				if satisfying_object_combinations.has (l_hashable_array) then
					satisfying_object_combinations.remove (l_hashable_array)
				end
				unsatisfying_object_combinations.force_last (l_hashable_array)
			end
		ensure
			satisfying_implies_has_satisfying: a_valuation = true implies (has (a_combination) and is_satisfying_combination (a_combination))
			satisfying_implies_satisfying_set_not_smaller: a_valuation = true implies (satisfying_object_combinations.count >= old satisfying_object_combinations.count)
			not_satisfying_implies_has_unsatisfying: a_valuation = false implies (has (a_combination) and not is_satisfying_combination (a_combination))
			unsatisfying_implies_unsatisfying_set_not_smaller: a_valuation = false implies (unsatisfying_object_combinations.count >= old unsatisfying_object_combinations.count)
		end

feature{NONE} -- Implementation

	satisfying_object_combinations: DS_HASH_SET [AUT_HASHABLE_ITP_VARIABLE_ARRAY]
			-- Table of the satisfying object combinations

	unsatisfying_object_combinations: DS_HASH_SET [AUT_HASHABLE_ITP_VARIABLE_ARRAY]
			-- Table of the unsatisfying object combinations

invariant
	arity_positive: arity > 0
	satisfying_object_combinations_attached: satisfying_object_combinations /= Void
	unsatisfying_object_combinations_attached: unsatisfying_object_combinations /= Void
	associated_predicate_attached: associated_predicate /= Void

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
