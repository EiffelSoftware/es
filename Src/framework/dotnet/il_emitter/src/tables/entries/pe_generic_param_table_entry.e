note
	description: "Object representing the GenericParam table."
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=GenericParam", "src=https://www.ecma-international.org/wp-content/uploads/ECMA-335_6th_edition_june_2012.pdf#page=254&zoom=100,116,309", "protocol=uri"

class
	PE_GENERIC_PARAM_TABLE_ENTRY

inherit

	PE_TABLE_ENTRY_BASE
		redefine
			same_as
		end

create
	make_with_data

feature {NONE} -- Implementation

	make_with_data (a_number: NATURAL_16; a_flags: NATURAL_16; a_owner: PE_TYPE_OR_METHOD_DEF; a_name: NATURAL_32)
		do
			number := a_number
			flags := a_flags
			owner := a_owner
			create name.make_with_index (a_name)
		end

feature -- Status

	token_searching_supported: BOOLEAN = True

	same_as (e: like Current): BOOLEAN
			-- Is `e` same as `Current`?
			-- note: used to detect if an entry is already recorded.
		do
			Result := Precursor (e)
				or else (

					e.number = number and then
					e.flags = flags and then
					e.owner.is_equal (owner) and then
					e.name.is_equal (name)
				)
		end

feature -- Access

	number: NATURAL_16
			-- Defined as word two bytes.
			-- the 2-byte index of the generic parameter, numbered left-to-right, from zero.

	flags: NATURAL_16
			-- Defined as word two bytes.
			-- a 2-byte bitmask of type GenericParamAttributes
			-- see https://www.ecma-international.org/wp-content/uploads/ECMA-335_6th_edition_june_2012.pdf#page=277&zoom=100,116,488

	owner: PE_TYPE_OR_METHOD_DEF
			-- an index into the TypeDef or MethodDef table, specifying the Type or
			-- Method to which this generic parameter applies; more precisely, a
			-- TypeOrMethodDef coded index.

	name: PE_STRING
			-- a non-null index into the String heap, giving the name for the generic parameter.

feature -- Operations

	table_index: NATURAL_32
		once
			Result := {PE_TABLES}.tGenericParam
		end

	render (a_sizes: SPECIAL [NATURAL_32]; a_dest: ARRAY [NATURAL_8]): NATURAL_32
		local
			l_bytes: NATURAL_32
		do
			{BYTE_ARRAY_HELPER}.put_natural_16 (a_dest, number, 0)
			l_bytes := 2
			{BYTE_ARRAY_HELPER}.put_natural_16 (a_dest, flags, 2)
			l_bytes := l_bytes + 2

			l_bytes := l_bytes + owner.render (a_sizes, a_dest, l_bytes)
			l_bytes := l_bytes + name.render (a_sizes, a_dest, l_bytes)

			Result := l_bytes
		end

	rendering_size (a_sizes: SPECIAL [NATURAL_32]): NATURAL_32
		local
			l_bytes: NATURAL_32
		do
			l_bytes := 2
			l_bytes := l_bytes + 2

			l_bytes := l_bytes + owner.rendering_size (a_sizes)
			l_bytes := l_bytes + name.rendering_size (a_sizes)

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

