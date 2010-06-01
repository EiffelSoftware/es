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

	array_represention: ARRAY [INTEGER]
			-- Array of variable indexes that satisfy `predicate'
		do
			if array_represention_cache = Void then
				array_represention_cache := storage.to_array
			end
			Result := array_represention_cache
		ensure
			result_attached: result /= Void
			result_valid: Result.count = storage.count
		end

feature -- Status report

	has_variable (a_variable: ITP_VARIABLE): BOOLEAN is
			-- Does `a_variable' exist in current valuation?
		do
			Result := storage.has (a_variable.index)
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

			l_storage.search (l_obj_index)
			if l_storage.found then
				if not a_value then
					l_storage.remove_found_item
					array_represention_cache := Void
				end
			else
				if a_value then
					l_storage.force_last (l_obj_index)
					array_represention_cache := Void
				end
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
			array_represention_cache := Void
		ensure then
			storage_wiped_out: storage.is_empty
		end

	remove_variable (a_variable: ITP_VARIABLE) is
			-- Remove all valuations related to `a_variable'.
		do
			storage.remove (a_variable.index)
			array_represention_cache := Void
		end

feature -- Process

	process (a_visitor: AUT_PREDICATE_VALUATION_VISITOR) is
			-- Prcoess current with `a_visitor'.
		do
			a_visitor.process_unary_predicate_valuation (Current)
		end

feature{AUT_PREDICATE_VALUATION_CURSOR}  -- Storage

	storage: DS_HASH_SET [INTEGER]
			-- Indexes of objects that satisfy `precdicate'

feature{NONE} -- Implementation

	initial_storage_capacity: INTEGER is 1000
			-- Initial capacity for `storage'

	array_represention_cache: detachable like array_represention
			-- Cache for `array_represention'

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
