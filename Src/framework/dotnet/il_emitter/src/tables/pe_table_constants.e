note
	description: "constants related to the tables in the PE file"
	date: "$Date$"
	revision: "$Revision$"

class
	PE_TABLE_CONSTANTS

feature -- Access

	Max_tables: INTEGER = 64
			-- the following are after the tables indexes, these are used to
			-- allow figuring out the size of indexes to 'special' streams
			-- generally if the stream is > 65535 bytes the index fits in a 32 bit DWORD
			-- otherwise the index fits into a 16 bit WORD

	Extra_indexes: INTEGER = 5

	T_string: INTEGER = 65

	T_us: INTEGER = 66

	T_guid: INTEGER = 67

	T_blob: INTEGER = 68

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
