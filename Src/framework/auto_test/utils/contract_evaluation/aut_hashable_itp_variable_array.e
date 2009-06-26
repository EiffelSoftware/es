note
	description: "Summary description for {AUT_HASHABLE_ITP_VARIABLE_ARRAY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_HASHABLE_ITP_VARIABLE_ARRAY

inherit
	HASHABLE
		redefine
			is_equal
		end

create
	make_from_array

feature -- Initialization

	make_from_array (a_array: ARRAY [ITP_VARIABLE])
			-- Initialize with a twin of `a'.
		require
			a_array_attached: a_array /= Void
			index_of_a_array_is_valid: a_array.lower = 1
			a_array_valid: not a_array.has (Void)
		do
			internal_variables_array := a_array.twin
			compute_string_representation
		end

feature -- Access

	hash_code: INTEGER
			-- Hash code value
		do
			-- Cached by STRING_32
			Result := string_representation.hash_code
		ensure then
			good_result: Result = string_representation.hash_code
			result_not_negative: Result >= 0
		end

	string_representation: STRING_32
			-- String representation of the items, for HASHABLE

	as_array: ARRAY [ITP_VARIABLE] is
			-- Return the internal array (ugly workaround)
			-- DO NOT MODIFY THE RETURNED ARRAY, will invalidate hash_code
		do
			Result := internal_variables_array
		end

	count: INTEGER is
			-- Number of variables in Current
		do
			Result := internal_variables_array.count
		ensure
			good_result: Result = internal_variables_array.count
		end

	item (i: INTEGER): ITP_VARIABLE is
			-- Variable at `i'-th position
		require
			i_valid: i > 0 and then i <= count
		do
			Result := internal_variables_array.item (i)
		ensure
			result_attached: Result /= Void
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Is array equal to `other'? equality is based on string_representation
		do
			Result := False

			if other = Current or else string_representation.is_equal (other.string_representation) then
				Result := True
			end
		end

feature {NONE} -- Implementation

	internal_variables_array: ARRAY [ITP_VARIABLE]

	compute_string_representation
			-- Compute the string represenation of the items
		local
			i: INTEGER
		do
			create string_representation.make (20)

			from
				i := internal_variables_array.lower
			until
				i = internal_variables_array.upper
			loop
				string_representation.append_integer (internal_variables_array.item (i).hash_code)
				string_representation.append_character (',')
				i := i + 1
			end
		end

invariant
	internal_variables_array_attached: internal_variables_array /= Void
	string_representation_attached: string_representation /= Void

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
