note
	description: "[
			Class describing the Document table.
			The Document table shall contain no duplicate rows based upon document name.
		
			Name shall not be nil. It can however encode an empty name string.
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Document", "src=https://github.com/dotnet/runtime/blob/main/docs/design/specs/PortablePdb-Metadata.md#document-table-0x30", "protocol=uri"

class
	PE_DOCUMENT_TABLE_ENTRY

inherit
	PE_TABLE_ENTRY_BASE
		redefine
			same_as
		end

create
	make_with_data

feature {NONE} -- Implementation

	make_with_data (a_name_index: NATURAL_32; a_hash_algorithm_index: NATURAL_32; a_hash_index: NATURAL_32; a_language_index: NATURAL_32)
		do
			create name_index.make_with_index (a_name_index)
			create hash_algorithm_index.make_with_index (a_hash_algorithm_index)
			create hash_index.make_with_index (a_hash_index)
			create language_index.make_with_index (a_language_index)
		end

feature -- Status

	same_as (e: like Current): BOOLEAN
			-- Is `e` same as `Current`?
			-- note: used to detect if an entry is already recorded.
			--| The Document table shall contain no duplicate rows based upon document name.

		do
			Result := Precursor (e)
				or else (
					e.name_index.is_equal (name_index)
				)
		end

feature -- Access

	name_index: PE_BLOB
			-- an index into the Blob heap.
			--| PE_DOCUMENT_BLOB
			--| Blob ::= separator part+

	hash_algorithm_index: PE_GUID
			-- an index into the Guid heap.

	hash_index: PE_BLOB
			-- an index into the Blob heap.

	language_index: PE_GUID
			-- an index into the Guid heap.

feature -- Operations

	table_index: NATURAL_32
		once
			Result := {PDB_TABLES}.tdocument
		end

	render (a_sizes: SPECIAL [NATURAL_32]; a_dest: ARRAY [NATURAL_8]): NATURAL_32
			-- <Precursor>
		local
			l_bytes_written: NATURAL_32
		do
				-- Initialize the number of bytes written to 0
			l_bytes_written := 0

				-- Render the name_index and add the number of bytes written to l_bytes_written
			l_bytes_written := l_bytes_written + name_index.render (a_sizes, a_dest, l_bytes_written)

				-- Render the hash_algorithm_index and add the number of bytes written to l_bytes_written
			l_bytes_written := l_bytes_written + hash_algorithm_index.render (a_sizes, a_dest, l_bytes_written)

				-- Render the hash_index and add the number of bytes written to l_bytes_written
			l_bytes_written := l_bytes_written + hash_index.render (a_sizes, a_dest, l_bytes_written)

				-- Render the language_index and add the number of bytes written to l_bytes_written
			l_bytes_written := l_bytes_written + language_index.render (a_sizes, a_dest, l_bytes_written)

				-- Return the total number of bytes written
			Result := l_bytes_written
		end

	rendering_size (a_sizes: SPECIAL [NATURAL_32]): NATURAL_32
			-- <Precursor>
		local
			l_bytes: NATURAL_32
		do
				-- Initialize the number of bytes read to 0
			l_bytes := 0

				-- Read the name_index
			l_bytes := l_bytes + name_index.rendering_size (a_sizes)

				-- Read the hash_algorithm_index
			l_bytes := l_bytes + hash_algorithm_index.rendering_size (a_sizes)

				-- Read the hash_index
			l_bytes := l_bytes + hash_index.rendering_size (a_sizes)

				-- Read the language_index
			l_bytes := l_bytes + language_index.rendering_size (a_sizes)

				-- Return the total number of bytes read
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
