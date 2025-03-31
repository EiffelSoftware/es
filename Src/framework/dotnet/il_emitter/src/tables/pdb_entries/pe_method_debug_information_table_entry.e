note
	description: "[
			Class describing the MethodDebugInformation table.
			The MethodDebugInformation table is either empty (missing) or has exactly as many rows as MethodDef table.
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=MethodDebugInformation", "src=https://github.com/dotnet/runtime/blob/main/docs/design/specs/PortablePdb-Metadata.md#methoddebuginformation-table-0x31", "protocol=uri"

class
	PE_METHOD_DEBUG_INFORMATION_TABLE_ENTRY

inherit
	PE_TABLE_ENTRY_BASE

create
	make,
	make_empty

feature {NONE} -- Implementation

	make (a_document_row_id: NATURAL_32; a_sequence_points_index: NATURAL_32)
		do
			create document_row_id.make_with_index (a_document_row_id)
			create sequence_points_index.make_with_index (a_sequence_points_index)
			is_empty := False

			-- The table is a logical extension of MethodDef table (adding a column to the table)
			-- and as such can be indexed by MethodDef row id.
			-- we can add a new entry:
			-- method_def_index: PE_METHOD_DEF_OR_REF
		end

	make_empty
		do
			make (0, 0)
			is_empty := True
		end

feature -- Access

	document_row_id: PE_DOCUMENT
			-- The row id of the single document containing all sequence points of the method,
			-- or 0 if the method doesn't have sequence points or spans multiple documents.

	sequence_points_index: PE_BLOB
			-- Blob heap index, 0 if the method doesn’t have sequence points, encoding: sequence points blob.
			-- https://github.com/dotnet/runtime/blob/main/docs/design/specs/PortablePdb-Metadata.md#sequence-points-blob
			--| PE_SEQUENCE_POINTS_BLOB
			--| Sequence points blob has the following structure:
			--| Blob ::= header SequencePointRecord (SequencePointRecord | document-record)*
			--| SequencePointRecord ::= sequence-point-record | hidden-sequence-point-record

	is_empty: BOOLEAN

feature -- Operations

	table_index: NATURAL_32
		once
			Result := {PDB_TABLES}.tMethodDebugInformation
		end

	render (a_sizes: SPECIAL [NATURAL_32]; a_dest: ARRAY [NATURAL_8]): NATURAL_32
			-- <Precursor>
		local
			l_bytes_written: NATURAL_32
		do
				-- Initialize the number of bytes written to 0
			l_bytes_written := 0

				-- Render the document_row_id and add the number of bytes written to l_bytes_written
			l_bytes_written := l_bytes_written + document_row_id.render (a_sizes, a_dest, l_bytes_written)

				-- Render the sequence_points_index and add the number of bytes written to l_bytes_written
			l_bytes_written := l_bytes_written + sequence_points_index.render (a_sizes, a_dest, l_bytes_written)

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

				-- Read the document_row_id
			l_bytes := l_bytes + document_row_id.rendering_size (a_sizes)
				-- Read the sequence_points_index
			l_bytes := l_bytes + sequence_points_index.rendering_size (a_sizes)

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
