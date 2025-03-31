note
	description: "Summary description for {PE_RESOURCE_DATA_ENTRY}."
	date: "$Date$"
	revision: "$Revision$"

class
	PE_RESOURCE_DATA_ENTRY



feature -- Access

	rva: INTEGER_32 assign set_rva
			-- `rva'

	size: INTEGER_32 assign set_size
			-- `size'

	code_page: INTEGER_32 assign set_code_page
			-- `code_page'

	reserved: INTEGER_32 assign set_reserved
			-- `reserved'

feature -- Element change

	set_rva (a_rva: like rva)
			-- Assign `rva' with `a_rva'.
		do
			rva := a_rva
		ensure
			rva_assigned: rva = a_rva
		end

	set_size (a_size: like size)
			-- Assign `size' with `a_size'.
		do
			size := a_size
		ensure
			size_assigned: size = a_size
		end

	set_code_page (a_code_page: like code_page)
			-- Assign `code_page' with `a_code_page'.
		do
			code_page := a_code_page
		ensure
			code_page_assigned: code_page = a_code_page
		end

	set_reserved (a_reserved: like reserved)
			-- Assign `reserved' with `a_reserved'.
		do
			reserved := a_reserved
		ensure
			reserved_assigned: reserved = a_reserved
		end

feature -- Managed Pointer

	managed_pointer: MANAGED_POINTER
		local
			l_pos: INTEGER
		do
			create Result.make (size_of)
			l_pos := 0

				--rva
			Result.put_integer_32_le (rva, l_pos)
			l_pos := l_pos + {PLATFORM}.integer_32_bytes

				--size
			Result.put_integer_32_le (size, l_pos)
			l_pos := l_pos + {PLATFORM}.integer_32_bytes

				--code_page
			Result.put_integer_32_le (code_page, l_pos)
			l_pos := l_pos + {PLATFORM}.integer_32_bytes

				--reserved
			Result.put_integer_32_le (reserved, l_pos)
		end

feature -- Measurement

	size_of: INTEGER
		local
			l_internal: INTERNAL
			n: INTEGER
			l_obj: PE_RESOURCE_DATA_ENTRY
		do
			create l_obj
			create l_internal
			n := l_internal.field_count (l_obj)
			across 1 |..| n as ic loop
				if attached l_internal.field (ic, l_obj) as l_field then
					if attached {INTEGER_32} l_field then
						Result := Result + {PLATFORM}.integer_32_bytes
					end
				end
			end
		ensure
			instance_free: class
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
