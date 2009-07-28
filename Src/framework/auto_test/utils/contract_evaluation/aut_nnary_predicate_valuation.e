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

	has_variable (a_variable: ITP_VARIABLE): BOOLEAN is
			-- Does `a_variable' exist in current valuation?
		local
			l_cursor: DS_HASH_SET_CURSOR [AUT_HASHABLE_ITP_VARIABLE_ARRAY]
			l_vars: AUT_HASHABLE_ITP_VARIABLE_ARRAY
			i, l_upper: INTEGER
			l_index: INTEGER
		do
			l_index := a_variable.index
			from
				l_cursor := storage.new_cursor
				l_cursor.start
			until
				l_cursor.after or else Result
			loop
				l_vars := l_cursor.item
				from
					i := 1
					l_upper := l_vars.count
				until
					i > l_upper or else Result
				loop
					Result := l_vars.item (i).index = l_index
					i := i + 1
				end
				l_cursor.forth
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

	remove_variable (a_variable: ITP_VARIABLE) is
			-- Remove all valuations related to `a_variable'.
		local
			l_cursor: DS_HASH_SET_CURSOR [AUT_HASHABLE_ITP_VARIABLE_ARRAY]
			l_vars: AUT_HASHABLE_ITP_VARIABLE_ARRAY
			i, l_upper: INTEGER
			l_index: INTEGER
			l_found: BOOLEAN
			l_storage: like storage
			l_found_items: DS_LINKED_LIST [AUT_HASHABLE_ITP_VARIABLE_ARRAY]
		do
			l_index := a_variable.index
			l_storage := storage
			create l_found_items.make
			from
				l_cursor := l_storage.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_vars := l_cursor.item
				from
					i := 1
					l_upper := l_vars.count
					l_found := False
				until
					i > l_upper or else l_found
				loop
					if l_vars.item (i).index = l_index then
						l_found_items.force_last (l_vars)
						l_found := True
					else
						i := i + 1
					end
				end
				l_cursor.forth
			end

			l_found_items.do_all (agent storage.remove)
		end

feature -- Process

	process (a_visitor: AUT_PREDICATE_VALUATION_VISITOR) is
			-- Prcoess current with `a_visitor'.
		do
			a_visitor.process_nnary_predicate_valuation (Current)
		end

feature{AUT_PREDICATE_VALUATION_CURSOR} -- Implementation

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
