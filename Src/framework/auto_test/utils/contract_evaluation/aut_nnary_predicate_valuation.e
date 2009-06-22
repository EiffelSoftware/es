note
	description: "Summary description for {AUT_NNARY_PREDICATE_VALUATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_NNARY_PREDICATE_VALUATION

inherit
	AUT_PREDICATE_VALUATION
		redefine
			count
		end

	AUT_PREDICATE_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_predicate: like predicate) is
			-- Initialize `predicate' with `a_predicate'.
		require
			a_predicate_attached: a_predicate /= Void
			a_predicate_valid: a_predicate.arity > 2
		do
			predicate := a_predicate
			create storage.make (initial_storage_capacity)
			storage.set_equality_tester (hashable_variable_array_equality_tester)
		ensure
			predicate_set: predicate = a_predicate
		end

feature -- Access

	count: INTEGER
			-- Number of object combinations that satisfy the associated predicate.

	item (a_arguments: ARRAY [ITP_VARIABLE]): BOOLEAN is
			-- Valuation of objects in `a_arguments'
			-- Index of `a_arguments' is 1-based. They are arguments for `predicate'.
		local
			l_hashable_array: AUT_HASHABLE_ITP_VARIABLE_ARRAY
		do
			create l_hashable_array.make_from_array (a_arguments)
			Result := storage.has (l_hashable_array)
		end

feature -- Status report

	is_satisfying_combination (a_partial_solution: like partial_solution_anchor; a_constraint: AUT_PREDICATE_CONSTRAINT): BOOLEAN is
			-- Is `a_partial_solution' a object combination satisfying `predicate' under `a_constraint'?
		local
			l_mapping: DS_HASH_TABLE [INTEGER, INTEGER]
			l_satisfied: BOOLEAN
			l_cursor: DS_HASH_TABLE_CURSOR [INTEGER, INTEGER]
			l_array: ARRAY [ITP_VARIABLE]
			i: INTEGER
			l_var: detachable ITP_VARIABLE
		do
			l_mapping := a_constraint.argument_mapping.item (predicate)
			l_satisfied := True
			create l_array.make (1, arity)
			from
				i := 1
				l_cursor := l_mapping.new_cursor
				l_cursor.start
			until
				l_cursor.after or not l_satisfied
			loop
				l_var := a_partial_solution.item (l_cursor.item)
				if l_var /= Void then
					l_array.put (l_var, i)
				else
					l_satisfied := False
				end
				i := i + 1
				l_cursor.forth
			end

			if l_satisfied then
				Result := item (l_array)
			end
		end

feature -- Basic operations

	put (a_arguments: ARRAY [ITP_VARIABLE]; a_value: BOOLEAN) is
			-- Set valuation for `a_arguments' with `a_value'.
			-- Index of `a_arguments' is 1-based. They are arguments for `predicate'.
		local
			l_hashable_array: AUT_HASHABLE_ITP_VARIABLE_ARRAY
			l_storage: like storage
		do
			create l_hashable_array.make_from_array (a_arguments)
			l_storage := storage
			if a_value then
				if not l_storage.has (l_hashable_array) then
					l_storage.force_last (l_hashable_array)
					count := count + 1
				end
			else
				l_storage.search (l_hashable_array)
				if l_storage.found then
					l_storage.remove_found_item
					count := count - 1
				end
			end
		end

	wipe_out is
			-- Wipe out current all valuations.
		do
			storage.wipe_out
			count := 0
		ensure then
			storage_wiped_out: storage.is_empty
		end

feature -- Process

	process (a_visitor: AUT_PREDICATE_VALUATION_VISITOR) is
			-- Prcoess current with `a_visitor'.
		do
			a_visitor.process_nnary_predicate_valuation (Current)
		end

feature{AUT_NNARY_PREDICATE_VALUATION_CURSOR} -- Implementation

	storage: DS_HASH_SET [AUT_HASHABLE_ITP_VARIABLE_ARRAY]
			-- Storage for valuation

feature{NONE} -- Implementation

	initial_storage_capacity: INTEGER is 100
			-- Initial capacity for `storage'

invariant
	storage_attached: storage /= Void

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
