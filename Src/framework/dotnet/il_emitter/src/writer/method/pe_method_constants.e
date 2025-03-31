note
	description: "Summary description for {PE_METHOD_FLAGS}."
	date: "$Date$"
	revision: "$Revision$"

class
	PE_METHOD_CONSTANTS

feature -- Flags

	TinyFormat: INTEGER = 2
			-- no local variables MAXstack <=8 size < 64;

	FatFormat: INTEGER = 3

		-- more flags only availble for FAT format
	MoreSects: INTEGER = 8

	InitLocals: INTEGER = 0x10

	CIL: INTEGER = 0x4000
			-- not a real flag either

	EntryPoint: INTEGER = 0x8000
			-- not a real flag that goes in the PE file

feature -- Table

	EHTable: INTEGER = 1
	OptILTable: INTEGER = 2
	EHFatFormat: INTEGER = 0x40
	EHMoreSects: INTEGER = 0x80

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
