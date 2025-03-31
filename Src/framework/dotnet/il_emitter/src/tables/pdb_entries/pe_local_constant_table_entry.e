note
	description: "[
			Class describing the LocalConstant table.
			The LocalConstant table has several columns and specific requirements.
			
			There shall be no duplicate rows in the LocalConstant table, based upon owner and Name.
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=LocalConstant", "src=https://github.com/dotnet/runtime/blob/main/docs/design/specs/PortablePdb-Metadata.md#localconstant-table-0x34", "protocol=uri"

class
	PE_LOCAL_CONSTANT_TABLE_ENTRY

inherit
	PE_TABLE_ENTRY_BASE
		redefine
			same_as
		end

create
	make_with_data

feature {NONE} -- Implementation

	make_with_data (a_name_index: NATURAL_32; a_signature_index: NATURAL_32)
		do
			create name_index.make_with_index (a_name_index)
			create signature_index.make_with_index (a_signature_index)
		end

feature -- Status

	same_as (e: like Current): BOOLEAN
			-- Is `e` same as `Current`?
			-- note: used to detect if an entry is already recorded.
			--| There shall be no duplicate rows in the LocalConstant table, based upon owner and Name.

		do
			Result := Precursor (e)
				or else (
					e.name_index.is_equal (name_index) and then
					e.signature_index.is_equal (signature_index)
				)
		end

feature -- Access

	name_index: PE_STRING
			-- String heap index.

	signature_index: PE_BLOB
			-- Blob heap index, LocalConstantSig blob.
			-- https://github.com/dotnet/runtime/blob/main/docs/design/specs/PortablePdb-Metadata.md#localconstantsig-blob
			--| PE_LOCAL_CONSTANT_SIG_BLOB
			--| Blob ::= CustomMod* (PrimitiveConstant | EnumConstant | GeneralConstant)
			--| PrimitiveConstant ::= PrimitiveTypeCode PrimitiveValue
			--| PrimitiveTypeCode ::= BOOLEAN | CHAR | I1 | U1 | I2 | U2 | I4 | U4 | I8 | U8 | R4 | R8 | STRING

			--| EnumConstant ::= EnumTypeCode EnumValue EnumType
			--| EnumTypeCode ::= BOOLEAN | CHAR | I1 | U1 | I2 | U2 | I4 | U4 | I8 | U8
			--| EnumType ::= TypeDefOrRefOrSpecEncoded

			--| GeneralConstant ::= (CLASS | VALUETYPE) TypeDefOrRefOrSpecEncoded GeneralValue? |
			--                    OBJECT

feature -- Operations

	table_index: NATURAL_32
		once
			Result := {PDB_TABLES}.tLocalConstant
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

				-- Render the signature_index and add the number of bytes written to l_bytes_written
			l_bytes_written := l_bytes_written + signature_index.render (a_sizes, a_dest, l_bytes_written)

				-- Return the total number of bytes written
			Result := l_bytes_written
		end

	rendering_size (a_sizes: SPECIAL [NATURAL_32]): NATURAL_32
			-- Bytes needed to `render` Current using the global information on MD table sizes `a_sizes`.
		local
			l_bytes: NATURAL_32
		do
				-- Initialize the number of bytes read to 0
			l_bytes := 0

				-- Read the name_index
			l_bytes := l_bytes + name_index.rendering_size (a_sizes)

				-- Read the signature_index
			l_bytes := l_bytes + signature_index.rendering_size (a_sizes)

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
