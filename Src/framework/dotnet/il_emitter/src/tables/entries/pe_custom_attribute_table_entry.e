note
	description: "[
		Object representing the CustomAttribute table
		The CustomAttribute table stores data that can be used to instantiate a Custom Attribute (moreprecisely, an object of the specified Custom Attribute class) at runtime.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=CustomAttribute", "src=https://www.ecma-international.org/wp-content/uploads/ECMA-335_6th_edition_june_2012.pdf#page=242&zoom=100,116,794", "protocol=uri"

class
	PE_CUSTOM_ATTRIBUTE_TABLE_ENTRY

inherit

	PE_TABLE_ENTRY_BASE
		redefine
			same_as
		end

	DEBUG_OUTPUT

create
	make_with_data

feature {NONE} -- Intialization

	make_with_data (a_parent_index: PE_HAS_CUSTOM_ATTRIBUTE; a_type_index: PE_CUSTOM_ATTRIBUTE_TYPE; a_value_index: NATURAL_32)
		do
			parent_index := a_parent_index
			type_index := a_type_index
			create value_index.make_with_index (a_value_index)
		end

feature -- Status report

	debug_output: STRING
		do
			Result := "CA [parent=" + parent_index.debug_output + " type="+ type_index.debug_output +"]"
		end

feature -- Status

	same_as (e: like Current): BOOLEAN
			-- Is `e` same as `Current`?
			-- note: used to detect if an entry is already recorded.
		do
			Result := Precursor (e)
				or else (
					e.value_index.is_equal (value_index) and then
					e.type_index.is_equal (type_index) and then
					e.parent_index.is_equal (parent_index)
				)
		end

	less_than (other: like Current): BOOLEAN
			-- Is Current less than `other` in associated table?
		do
			Result := parent_index.less_than_index (other.parent_index)
		end

feature -- Access

	parent_index: PE_HAS_CUSTOM_ATTRIBUTE
			-- an index into a metadata table that has an associated HasCustomAttribute index.

	type_index: PE_CUSTOM_ATTRIBUTE_TYPE
			-- an index into the MethodDef or MemberRef table; more precisely, a CustomAttributeType index.

	value_index: PE_BLOB
			-- an index into the Blob heap.

feature -- Operations

	table_index: NATURAL_32
		once
			Result := {PE_TABLES}.tcustomattribute
		end

	render (a_sizes: SPECIAL [NATURAL_32]; a_dest: ARRAY [NATURAL_8]): NATURAL_32
		local
			l_bytes: NATURAL_32
		do
				-- Write parent_index, type_index and value_index to the buffer and update
				-- the number of bytes
			l_bytes := parent_index.render (a_sizes, a_dest, 0)
			l_bytes := l_bytes + type_index.render (a_sizes, a_dest, l_bytes)
			l_bytes := l_bytes + value_index.render (a_sizes, a_dest, l_bytes)

				-- Return the number of bytes written
			Result := l_bytes
		end

	rendering_size (a_sizes: SPECIAL [NATURAL_32]): NATURAL_32
		local
			l_bytes: NATURAL_32
		do
				-- Read parent_index, type_index and value_index from the buffer and update
				-- the number of bytes
			l_bytes := parent_index.rendering_size (a_sizes)
			l_bytes := l_bytes + type_index.rendering_size (a_sizes)
			l_bytes := l_bytes + value_index.rendering_size (a_sizes)

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
