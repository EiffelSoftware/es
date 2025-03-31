note
	description: "Representation of both an Import Lookup table and an Import Address Table (IAT) in a PE File for CLI"
	date: "$Date$"
	revision: "$Revision$"

class
    CLI_IMPORT_ADDRESS_TABLE

create
	make

feature {NONE} -- Initialization

	make
		do
		end

feature -- Access

    import_by_name_rva: INTEGER_32
    	-- RVA to ImportByName table.

feature -- Status Report

	count: INTEGER
			--  Number of elements that Current can hold.
		do
			Result := size_of
		end

feature -- Element Change

	set_import_by_name_rva (a_val: INTEGER_32)
			-- Set `import_by_name_rva' with `a_val'
		do
			import_by_name_rva := a_val
		ensure
			import_by_name_rva_set: import_by_name_rva = a_val
		end

feature  -- Debug

	debug_header (a_name: STRING_32)
		local
			l_file: RAW_FILE
		do
			create l_file.make_create_read_write (a_name + ".bin")
			l_file.put_managed_pointer (item, 0, count)
			l_file.close
		end


feature -- Item

    item: CLI_MANAGED_POINTER
            -- Write the items to the buffer in little-endian format.
        do
			create Result.make (size_of)
			Result.put_integer_32 (import_by_name_rva) -- import_by_name_rva
			Result.put_padding (4, 0) -- padding
        end

feature -- Size

    size_of: INTEGER
            -- Compute the size of the struct.
		local
			s: CLI_MANAGED_POINTER_SIZE
		do
			create s.make
       		s.put_integer_32 --import_by_name_rva
       		s.put_padding (4) -- padding 4 bytes (FIXME: why?)
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
end -- class CLI_IMPORT_ADDRESS_TABLE
