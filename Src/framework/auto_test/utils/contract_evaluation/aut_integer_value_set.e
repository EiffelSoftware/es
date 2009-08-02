note
	description: "Summary description for {AUT_INTEGER_VALUE_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_INTEGER_VALUE_SET

feature -- Access

	has (a_values: ARRAY [INTEGER]): BOOLEAN is
			-- Does current contain `a_values'?
		require
			a_values_attached: a_values /= Void
			a_values_valid: is_item_valid (a_values)
		deferred
		end

	arity: INTEGER
			-- Number of integers for each `item'

feature -- Access

	item: ARRAY [INTEGER] is
			-- Item values at current location
		deferred
		end

	count: INTEGER is
			-- Number of elements
		deferred
		ensure
			result_non_negative: Result >= 0
		end

feature -- Status report

	before: BOOLEAN is
			-- Is before?
		deferred
		end

	after: BOOLEAN is
			-- Is after?
		deferred
		end

	is_empty: BOOLEAN is
			-- Is Current empty?
		do
			Result := count = 0
		end

	is_item_valid (a_array: like item): BOOLEAN is
			-- is `a_array' valid to be put into Current?
		require
			a_array_attached: a_array /= Void
		do
			Result := a_array.lower = 1 and then a_array.count = arity
		end

feature -- Basic operations

	start is
			-- Start
		deferred
		end

	forth is
			-- Forth
		deferred
		end

	put (a_values: like item) is
			-- Put `a_values' into Current.
		require
			a_values_attached: a_values /= Void
			a_values_valid: is_item_valid (a_values)
		deferred
		end

	wipe_out is
			-- Wipe out current.
		deferred
		ensure
			is_empty: is_empty
		end

invariant
	arity_positive: arity > 0

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
