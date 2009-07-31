note
	description: "Summary description for {AUT_UNARY_INTEGER_VALUE_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_UNARY_INTEGER_VALUE_SET

inherit
	AUT_INTEGER_VALUE_SET

create
	make

feature{NONE} -- Initialization

	make is
			-- Initialize.
		do
			create storage.make (20)
			arity := 1
		ensure
			arity_set: arity = 1
		end

feature -- Access

	has (a_values: ARRAY [INTEGER]): BOOLEAN is
			-- Does current contain `a_values'?
		do
			if a_values.count = 1 then
				Result := storage.has (a_values.item (a_values.lower))
			end
		end

feature -- Access

	item: ARRAY [INTEGER] is
			-- Item values at current location
		do
			Result := <<storage.item_for_iteration>>
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

	wipe_out is
			-- Wipe out.
		do
			storage.wipe_out
		end

	put (a_values: like item) is
			-- Put `a_values' into Current.
		do
			if a_values.count = 1 then
				storage.force_last (a_values.item (a_values.lower))
			end
		end

feature{NONE} -- Impelementation

	storage: DS_HASH_SET [INTEGER];
			-- Internal storage of integers

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
