note
	description: "Representation of an IMAGE_DATA_DIRECTORY for CLI."
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=image_data_directory", "src=https://learn.microsoft.com/en-us/windows/win32/api/winnt/ns-winnt-image_data_directory", "protocol=uri"

class
	CLI_DIRECTORY

create
	make

feature {NONE}

	make
		do
			set_rva_and_size (0, 0)
		end

feature -- Access

	rva: INTEGER_32
			-- RVA of the directory.
			--| Relative virtual address for current directory.

	data_size: INTEGER_32
			-- Size of the directory in bytes.

feature -- Setter

	set_rva (a_virtual_address: INTEGER_32)
			-- Set `rva` to `a_virtual_address'.
		do
			rva := a_virtual_address
		ensure
			rva_set: rva = a_virtual_address
		end

	set_data_size (a_size: INTEGER_32)
			-- Set `data_size` with `a_size'.
		do
			data_size := a_size
		ensure
			data_size_set: data_size = a_size
		end

	set_rva_and_size (a_rva, a_size: INTEGER)
			-- Set `rva' and `data_size' to `a_rva' and `a_size'.
		do
			set_rva (a_rva)
			set_data_size (a_size)
		ensure
			rva_set: rva = a_rva
			data_size_set: data_size = a_size
		end

feature -- Managed Pointer

	item: MANAGED_POINTER
			-- write the items to the buffer in  little-endian format.
		local
			mp: CLI_MANAGED_POINTER
		do
			create mp.make (size_of)

				-- rva
			mp.put_integer_32 (rva)
				-- data_size
			mp.put_integer_32 (data_size)

			Result := mp
		end

feature -- Size

	size_of: INTEGER_32
			-- Size of the structure.
		local
			s: CLI_MANAGED_POINTER_SIZE
		do
			create s.make
				-- rva
			s.put_integer_32
				-- data_size
			s.put_integer_32

			Result := s
		ensure
			is_class: class
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
end -- class CLI_DIRECTORY
