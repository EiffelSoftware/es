note
	description: "Object representing the FieldRVA table."
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=FieldRVA", "src=https://www.ecma-international.org/wp-content/uploads/ECMA-335_6th_edition_june_2012.pdf#page=253&zoom=100,116,310", "protocol=uri"

class
	PE_FIELD_RVA_TABLE_ENTRY

inherit

	PE_TABLE_ENTRY_BASE
		redefine
			same_as
		end

create
	make_with_data

feature {NONE} -- Initialization

	make_with_data (a_rva: NATURAL_32; a_field_index: NATURAL_32)
		do
			rva := a_rva
			create field_index.make_with_index (a_field_index)
		end

feature -- Status

	same_as (e: like Current): BOOLEAN
			-- Is `e` same as `Current`?
			-- note: used to detect if an entry is already recorded.
		do
			Result := Precursor (e)
				or else (
					e.rva = rva and then
					e.field_index.is_equal (field_index)
				)
		end

feature -- Access

	rva: NATURAL_32
			-- (a 4-byte constant)

	field_index: PE_FIELD_LIST
			-- An index into the Field table.

feature -- Operations

	table_index: NATURAL_32
		once
			Result := {PE_TABLES}.tfieldrva
		end

	render (a_sizes: SPECIAL [NATURAL_32]; a_dest: ARRAY [NATURAL_8]): NATURAL_32
		local
			l_bytes: NATURAL_32
		do
				-- note that when reading rva_ holds the rva, when writing it holds an offset into the CIL section
				-- Write the flags to the destination buffer `a_dest`.
			{BYTE_ARRAY_HELPER}.put_natural_32 (a_dest, (rva + {PE_WRITER}.cildata_rva.value), 0)

				-- Initialize the number of bytes written
			l_bytes := 4

				-- Write field_index
				-- to the buffer and update the number of bytes.
			l_bytes := l_bytes + field_index.render (a_sizes, a_dest, l_bytes)

				-- Return the total number of bytes written.
			Result := l_bytes
		end

	rendering_size (a_sizes: SPECIAL [NATURAL_32]): NATURAL_32
		local
			l_bytes: NATURAL_32
		do
				-- note that when reading rva_ holds the rva, when writing it holds an offset into the CIL section
				-- Set the rva (from a_src)  to the rva.
				-- Initialize the number of bytes readed.
			l_bytes := 4

				-- Get the field_index and
				-- update the number of bytes.

			l_bytes := l_bytes + field_index.rendering_size (a_sizes)

				-- Return the number of bytes readed.
			Result := l_bytes
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
