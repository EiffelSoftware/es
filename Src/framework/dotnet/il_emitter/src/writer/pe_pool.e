note
	description: "Summary description for {PE_POOL}."
	date: "$Date$"
	revision: "$Revision$"

class
	PE_POOL

inherit
	DEBUG_OUTPUT

	REFACTORING_HELPER

create
	make

feature {NONE} -- Implementation

	make
		do
			size := 0
			max_size := 200
			create base.make_filled (0, 200)
		ensure
			size_zero: size = 0
			max_size: max_size = 200
			base_empty: base.capacity = 200
		end

feature -- Access

	size: NATURAL_32

	max_size: NATURAL_32

	base: SPECIAL [NATURAL_8]
			-- todo double check if we need to use
			-- SPECIAL instead of ARRAY

	confirm (new_size: NATURAL_32)
			-- C++ uses ensure
		do
			if size + new_size > max_size then
				if size + new_size < max_size * 2 then
					max_size := max_size * 2
				else
					max_size := (max_size + new_size) * 2
				end
				base := base.resized_area_with_default (0, max_size.to_integer_32)
			end
		ensure
			new_max_size: base.capacity.to_natural_64 = max_size
		end

feature -- Status report

	debug_output: STRING_32
		do
			Result := "size=" + size.out + " (0x" + size.to_hex_string + ")"
		end

feature -- Element Change

	increment_size
			-- Increment size by 1.
		do
			size := size + 1
		ensure
			size_incremented: old size + 1 = size
		end

	increment_size_by (a_value: NATURAL_32)
			-- Increment size by `a_value`.
		do
			size := size + a_value
		ensure
			size_incremented: old size + a_value = size
		end

	copy_data (a_index: INTEGER; a_data: ARRAY [NATURAL_8]; a_count: NATURAL_32)
		local
			l_index: INTEGER
			i,n: INTEGER
		do
				-- TODO double check if
				-- base.copy_data (other: SPECIAL [T], source_index, destination_index, n: INTEGER_32)
				-- could replace the following code.
			l_index := a_index
			from
				i := 1
				n := a_count.to_integer_32
				check no_truncation: n.to_natural_64 = a_count end
			until
				i > n
			loop
				if i <= a_data.count then
					base [l_index] := a_data [i]
					l_index := l_index + 1
				else
					base [l_index] := null_natural_8_code
					l_index := l_index + 1
				end
				i := i + 1
			end
			base [l_index] := null_natural_8_code
		end

	null_natural_8_code: NATURAL_8
		once
			Result := ('%U').code.to_natural_8
		end

note
	copyright: "Copyright (c) 1984-2025, Eiffel Software"
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
