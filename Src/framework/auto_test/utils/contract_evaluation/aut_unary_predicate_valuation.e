note
	description: "Summary description for {AUT_UNARY_PREDICATE_EVALUATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_UNARY_PREDICATE_VALUATION

inherit
	AUT_PREDICATE_VALUATION

create
	make

feature{NONE} -- Initialization

	make (a_predicate: like predicate) is
			-- Initialize `predicate' with `a_predicate'.
		require
			a_predicate_attached: a_predicate /= Void
			a_predicate_is_unary: a_predicate.is_unary
		do
			predicate := a_predicate
			create storage.make (initial_storage_capacity)
		ensure
			predicate_set: predicate = a_predicate
		end

feature -- Access

	count: INTEGER is
			-- Number of object combinations that satisfy the associated predicate.
		do
			Result := storage.count
		ensure then
			good_result: Result = storage.count
		end

	item (a_arguments: ARRAY [ITP_VARIABLE]): BOOLEAN is
			-- Valuation of objects in `a_arguments'
			-- Index of `a_arguments' is 1-based. They are arguments for `predicate'.
		do
			Result := storage.has (a_arguments.item (1).index)
		ensure then
			good_result: Result = storage.has (a_arguments.item (1).index)
		end

feature -- Basic operations

	put (a_arguments: ARRAY [ITP_VARIABLE]; a_value: BOOLEAN) is
			-- Set valuation for `a_arguments' with `a_value'.
			-- Index of `a_arguments' is 1-based. They are arguments for `predicate'.
		local
			l_storage: like storage
			l_obj_index: INTEGER
		do
			l_storage := storage
			l_obj_index := a_arguments.item (1).index
			if a_value then
				l_storage.force_last (l_obj_index)
			else
				l_storage.remove (l_obj_index)
			end
		ensure then
			good_result:
				(a_value implies item (a_arguments)) or else
				(not a_value implies not item (a_arguments))
		end

	wipe_out is
			-- Wipe out current all valuations.
		do
			storage.wipe_out
		ensure then
			storage_wiped_out: storage.is_empty
		end

feature -- Process

	process (a_visitor: AUT_PREDICATE_VALUATION_VISITOR) is
			-- Prcoess current with `a_visitor'.
		do
			a_visitor.process_unary_predicate_valuation (Current)
		end

feature{AUT_UNARY_PREDICATE_VALUATION_CURSOR}  -- Storage

	storage: DS_HASH_SET [INTEGER]
			-- Indexes of objects that satisfy `precdicate'

feature{NONE} -- Implementation

	initial_storage_capacity: INTEGER is 1000
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
