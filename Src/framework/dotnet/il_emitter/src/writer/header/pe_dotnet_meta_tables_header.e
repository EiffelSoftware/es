note
	description: "Summary description for {DOTNET_META_TABLES_HEADER}."
	date: "$Date$"
	revision: "$Revision$"

class
	PE_DOTNET_META_TABLES_HEADER

feature -- Access

	reserved1: NATURAL_32 assign set_reserved1
			-- `reserved1'

	major_version: NATURAL_8 assign set_major_version
			-- `major_version'

	minor_version: NATURAL_8 assign set_minor_version
			-- `minor_version'

	heap_offset_sizes: NATURAL_8 assign set_heap_offset_sizes
			-- `heap_offset_sizes'

	reserved2: NATURAL_8 assign set_reserved2
			-- `reserved2'

	mask_valid: INTEGER_64 assign set_mask_valid
			-- `mask_valid'

	mask_sorted: INTEGER_64 assign set_mask_sorted
			-- `mask_sorted'

feature -- Element change

	set_reserved1 (a_reserved1: like reserved1)
			-- Assign `reserved1' with `a_reserved1'.
		do
			reserved1 := a_reserved1
		ensure
			reserved1_assigned: reserved1 = a_reserved1
		end

	set_major_version (a_major_version: like major_version)
			-- Assign `major_version' with `a_major_version'.
		do
			major_version := a_major_version
		ensure
			major_version_assigned: major_version = a_major_version
		end

	set_minor_version (a_minor_version: like minor_version)
			-- Assign `minor_version' with `a_minor_version'.
		do
			minor_version := a_minor_version
		ensure
			minor_version_assigned: minor_version = a_minor_version
		end

	set_heap_offset_sizes (a_heap_offset_sizes: like heap_offset_sizes)
			-- Assign `heap_offset_sizes' with `a_heap_offset_sizes'.
		do
			heap_offset_sizes := a_heap_offset_sizes
		ensure
			heap_offset_sizes_assigned: heap_offset_sizes = a_heap_offset_sizes
		end

	set_reserved2 (a_reserved2: like reserved2)
			-- Assign `reserved2' with `a_reserved2'.
		do
			reserved2 := a_reserved2
		ensure
			reserved2_assigned: reserved2 = a_reserved2
		end

	set_mask_valid (a_mask_valid: like mask_valid)
			-- Assign `mask_valid' with `a_mask_valid'.
		do
			mask_valid := a_mask_valid
		ensure
			mask_valid_assigned: mask_valid = a_mask_valid
		end

	set_mask_sorted (a_mask_sorted: like mask_sorted)
			-- Assign `mask_sorted' with `a_mask_sorted'.
		do
			mask_sorted := a_mask_sorted
		ensure
			mask_sorted_assigned: mask_sorted = a_mask_sorted
		end


feature -- Managed Pointer

	managed_pointer: CLI_MANAGED_POINTER
		do
			create Result.make (size_of)

				-- reserved1
			Result.put_natural_32 (reserved1)

				-- major_version
			Result.put_natural_8 (major_version)

				-- minor_version
			Result.put_natural_8 (minor_version)

				-- heap_offset_sizes
			Result.put_natural_8 (heap_offset_sizes)

				-- reserved2
			Result.put_natural_8 (reserved2)

				-- mask_valid
			Result.put_integer_64 (mask_valid)

				-- mask_sorted
			Result.put_integer_64 (mask_sorted)
		end

feature -- Measurement

	size_of: INTEGER
		local
			s: CLI_MANAGED_POINTER_SIZE
		do
			create s.make

				-- reserved1
			s.put_natural_32

				-- major_version
			s.put_natural_8

				-- minor_version
			s.put_natural_8

				-- heap_offset_sizes
			s.put_natural_8

				-- reserved2
			s.put_natural_8

				-- mask_valid
			s.put_integer_64

				-- mask_sorted
			s.put_integer_64
			Result := s
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
