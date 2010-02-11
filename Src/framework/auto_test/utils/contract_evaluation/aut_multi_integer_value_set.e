note
	description: "Summary description for {AUT_MULTI_INTEGER_VALUE_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_MULTI_INTEGER_VALUE_SET

inherit
	AUT_INTEGER_VALUE_SET

create
	make

feature{NONE} -- Initialization

	make (a_arity: INTEGER) is
			-- Initialize.
		require
			a_arity_positive: a_arity > 0
		do
			create storage.make
			storage.compare_objects
			arity := a_arity
		ensure
			arity_set: arity = a_arity
		end

feature -- Access

	has (a_values: ARRAY [INTEGER]): BOOLEAN is
			-- Does current contain `a_values'?
		do
			Result := storage.has (a_values)
		end

feature -- Access

	item: ARRAY [INTEGER] is
			-- Item values at current location
		do
			Result := storage.item_for_iteration
		end

	count: INTEGER is
			-- Number of elements
		do
			Result := storage.count
		end

feature -- Status report

	before: BOOLEAN is
			-- Is before?
		do
			Result := storage.before
		end

	after: BOOLEAN is
			-- Is after?
		do
			Result := storage.after
		end

feature -- Basic operations

	start is
			-- Start
		do
			storage.start
		end

	forth is
			-- Forth
		do
			storage.forth
		end

	put (a_values: like item) is
			-- Put `a_values' into Current.
		do
			if not storage.has (a_values) then
				storage.extend (a_values)
			end
		end

	wipe_out is
			-- Wipe out current.
		do
			storage.wipe_out
		end

feature{NONE} -- Implementation

	storage: LINKED_LIST [ARRAY [INTEGER]];
			-- Internal storage

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
