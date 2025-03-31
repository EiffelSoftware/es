note
	description: "[
			Object representing the class layour table
			The ClassLayout table is used to define how the fields of a class or value type shall be laid out by the
			CLI. (Normally, the CLI is free to reorder and/or insert gaps between the fields defined for a class or
			value type.)
			A ClassLayout table can contain zero or more rows.
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=ClassLayout", "src=https://www.ecma-international.org/wp-content/uploads/ECMA-335_6th_edition_june_2012.pdf#page=240&zoom=100,116,96", "protocol=uri"

class
	PE_CLASS_LAYOUT_TABLE_ENTRY

inherit

	PE_TABLE_ENTRY_BASE

create
	make_with_data

feature {NONE} -- Initialization

	make_with_data (a_pack: NATURAL_16; a_size: NATURAL; a_parent: NATURAL_32)
		do
			pack := a_pack
			size := a_size
			create parent.make_with_index (a_parent)
		end

feature -- Status


feature -- Access

	pack: NATURAL_16
			-- Defined as a word two bytes.
			-- packing size.

	size: NATURAL
			-- class size
			-- a 4-byte constant

	parent: PE_TYPE_DEF
			-- an index into the TypeDef table

feature -- Operations

	table_index: NATURAL_32
		once
			Result := {PE_TABLES}.tClassLayout
		end

	render (a_sizes: SPECIAL [NATURAL_32]; a_dest: ARRAY [NATURAL_8]): NATURAL_32
		local
			l_bytes: NATURAL_32
		do
				-- Write pack to the destination buffer `a_dest`.
			{BYTE_ARRAY_HELPER}.put_natural_16 (a_dest, pack, 0)
				-- Intialize the number of bytes written
			l_bytes := 2

				-- Write size to the destination buffer `a_dest`.
			{BYTE_ARRAY_HELPER}.put_natural_32 (a_dest, size, l_bytes.to_integer_32)
			l_bytes := l_bytes + 4

				-- Write parent to the buffer and update the number of bytes.
			l_bytes := l_bytes + parent.render (a_sizes, a_dest, l_bytes)

				-- Return the number of bytes written
			Result := l_bytes
		end

	rendering_size (a_sizes: SPECIAL [NATURAL_32]): NATURAL_32
		local
			l_bytes: NATURAL_32
		do
				-- Initialize the number of bytes
			l_bytes := 2


			l_bytes := l_bytes + 4

				-- Read parent from the buffer and update the number of bytes.
			l_bytes := l_bytes + parent.rendering_size (a_sizes)

				-- Return the number of bytes
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
