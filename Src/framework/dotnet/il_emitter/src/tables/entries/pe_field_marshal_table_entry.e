note
	description: "[
					Object representing the table FieldMarshal
					The FieldMarshal table has two columns. It ‘links’ an existing row in the Field or Param table, to
			information in the Blob heap that defines how that field or parameter (which, as usual, covers the
			method return, as parameter number 0) shall be marshalled when calling to or from unmanaged code
			via PInvoke dispatch.
			Note that FieldMarshal information is used only by code paths that arbitrate operation with unmanaged
			code. In order to execute such paths, the caller, on most platforms, would be installed with elevated
			security permission. Once it invokes unmanaged code, it lies outside the regime that the CLI can
			check—it is simply trusted not to violate the type system.
		]"
	date: "$Date$"
	revision: "$Revision$"
	eis: "name=FieldMarshal", "src=https://www.ecma-international.org/wp-content/uploads/ECMA-335_6th_edition_june_2012.pdf#page=252&zoom=100,116,324", "protocol=uri"

class
	PE_FIELD_MARSHAL_TABLE_ENTRY

inherit
	PE_TABLE_ENTRY_BASE
		redefine
			same_as
		end

create
	make_with_data

feature {NONE} -- Intialization

	make_with_data (a_parent: PE_FIELD_MARSHAL; a_native_type: NATURAL_32)
		do
			parent := a_parent
			create native_type.make_with_index (a_native_type)
		end

feature -- Status

	same_as (e: like Current): BOOLEAN
			-- Is `e` same as `Current`?
			-- note: used to detect if an entry is already recorded.
		do
			Result := Precursor (e)
				or else (
					e.parent.is_equal (parent) and then
					e.native_type.is_equal (native_type)
				)
		end

feature -- Access

	parent: PE_FIELD_MARSHAL
			-- index a valid row in the Field or Param table

	native_type: PE_BLOB
			--  index a non-null 'blob' in the Blob heap

feature -- Operations

	table_index: NATURAL_32
		once
			Result := {PE_TABLES}.tfieldmarshal
		end

	render (a_sizes: SPECIAL [NATURAL_32]; a_dest: ARRAY [NATURAL_8]): NATURAL_32
		local
			l_bytes: NATURAL_32
		do
				-- Write parent and native_type to the buffer and update
				-- the number of bytes
			l_bytes := parent.render (a_sizes, a_dest, 0)
			l_bytes := l_bytes + native_type.render (a_sizes, a_dest, l_bytes)

				-- Return the number of bytes written
			Result := l_bytes
		end

	rendering_size (a_sizes: SPECIAL [NATURAL_32]): NATURAL_32
		local
			l_bytes: NATURAL_32
		do
				-- Read parent and native_type  from the buffer and update
				-- the number of bytes
			l_bytes := parent.rendering_size (a_sizes)
			l_bytes := l_bytes + native_type.rendering_size (a_sizes)

				-- Return the number of bytes readed
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
