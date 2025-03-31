note
	description: "Object Representing an special kind of Class: Enum"
	date: "$Date$"
	revision: "$Revision$"


class
	CIL_ENUM

inherit

	CIL_CLASS
		rename
			make as make_class
		redefine
			il_src_dump,
			pe_dump
		end
	REFACTORING_HELPER

create
	make

feature {NONE} -- Implementation

	make (a_name: STRING_32; a_flags: CIL_QUALIFIERS; a_size: CIL_VALUE_SIZE)
		do
			value_size := a_size
			make_class (a_name, create {CIL_QUALIFIERS}.make_with_flags (a_flags.flags | {CIL_QUALIFIERS_ENUM}.value), -1, -1)
		ensure
			value_size_set: value_size = a_size
		end

feature -- Access

	value_size: CIL_VALUE_SIZE

feature -- Element change

	add_value (a_name: STRING_32; a_value: INTEGER_64): CIL_FIELD
			-- Add an enumeration, give it a name and a value
			-- This creates the Field definition for the enumerated value
		local
			l_type: CIL_TYPE
			l_field: CIL_FIELD
		do
			create l_type.make_with_container (Current)
			create l_field.make (a_name, l_type, create {CIL_QUALIFIERS}.make_with_flags ({CIL_QUALIFIERS_ENUM}.enumfield))
			l_field.add_enum_value (a_value, value_size)
			add (l_field)
			Result := l_field
		end

feature -- Output

	il_src_dump (a_stream: FILE_STREAM): BOOLEAN
		do
			il_src_dump_class_header (a_stream)
			a_stream.put_string (" {")
			a_stream.put_new_line
			a_stream.flush
				-- Call {CIL_DATA_CONTAINER}.pe_dump
			Result := pe_dump_dc (a_stream)

			a_stream.put_string ("  .field public specialname rtspecialname ")
			{CIL_FIELD}.il_src_dump_type_name (a_stream, value_size)
			a_stream.put_string (" value__")
			a_stream.put_new_line
			a_stream.flush
			a_stream.put_string (" }")
			a_stream.put_new_line
			a_stream.flush
			Result := True
		end

	pe_dump (a_stream: FILE_STREAM): BOOLEAN
		local
			l_pe_flags: INTEGER
			l_typename_index: NATURAL_32
			l_namespace_index: NATURAL_32
			l_field_index: NATURAL_32
			l_method_index: NATURAL_32
			l_extends: NATURAL_32
			l_extends_class: PE_TYPEDEF_OR_REF
			l_table: PE_TABLE_ENTRY_BASE
			l_typedef_entry: PE_TYPE_DEF_TABLE_ENTRY
			l_enclosing: NATURAL_32
			l_dis: NATURAL_32
			l_sz: CELL [NATURAL_32]
			l_tsize: CIL_BASIC_TYPE
			l_type: CIL_TYPE
			l_field: CIL_FIELD
			l_sig: ARRAY [NATURAL_8]
			l_sig_index: NATURAL_32
			l_name_index: NATURAL_32
			l_resolution: PE_RESOLUTION_SCOPE
		do
			if not in_assembly_ref then
				l_pe_flags := transfer_flags
				if attached {PE_WRITER} a_stream.pe_writer as l_writer then
					l_typename_index := l_writer.hash_string (name)
					l_namespace_index := parent_namespace (a_stream)
					l_extends := l_writer.enum_base
					l_field_index := l_writer.next_table_index ({PE_TABLES}.tfield)
					l_method_index := l_writer.next_table_index ({PE_TABLES}.tmethoddef)
					create l_extends_class.make_with_tag_and_index ({PE_TYPEDEF_OR_REF}.typeref, l_extends)
					if attached {CIL_CLASS} parent as l_parent then
						l_namespace_index := 0
					end
					create {PE_TYPE_DEF_TABLE_ENTRY} l_typedef_entry.make_with_data (l_pe_flags, l_typename_index, l_namespace_index, l_extends_class, l_field_index, l_method_index)
					pe_index := l_writer.add_table_entry (l_typedef_entry)

					if attached {CIL_CLASS} parent as l_parent then
						l_enclosing := parent_class (a_stream)
						create {PE_NESTED_CLASS_TABLE_ENTRY} l_table.make_with_data (pe_index, l_enclosing)
						l_dis := l_writer.add_table_entry (l_table)
					end
						-- Call {CIL_DATA_CONTAINER}.pe_dump
					Result := pe_dump_dc (a_stream)
						-- should only be the enumerations
					inspect value_size
					when {CIL_VALUE_SIZE}.i8 then
						l_tsize := {CIL_BASIC_TYPE}.i8
					when {CIL_VALUE_SIZE}.i16 then
						l_tsize := {CIL_BASIC_TYPE}.i16
					when {CIL_VALUE_SIZE}.i32 then
						l_tsize := {CIL_BASIC_TYPE}.i32
					when {CIL_VALUE_SIZE}.i64 then
						l_tsize := {CIL_BASIC_TYPE}.i64
					else
						l_tsize := {CIL_BASIC_TYPE}.i32
					end

						-- Add the value member
					create l_type.make_with_pointer_level (l_tsize, 0)
					create l_field.make ("value__", l_type, create {CIL_QUALIFIERS}.make_with_flags (0))

					create l_sz.put (0)
					l_sig := {PE_SIGNATURE_GENERATOR_HELPER}.field_sig (l_field, l_sz)

					l_sig_index := l_writer.hash_blob (l_sig, l_sz.item)
					l_name_index := l_writer.hash_string (l_field.name)
					create {PE_FIELD_TABLE_ENTRY} l_table.make_with_data ({PE_FIELD_TABLE_ENTRY}.Public | {PE_FIELD_TABLE_ENTRY}.SpecialName | {PE_FIELD_TABLE_ENTRY}.RTSpecialName, l_name_index, l_sig_index)
					pe_index := l_writer.add_table_entry (l_table)
				end
			elseif pe_index = 0 then -- !peIndex
				if attached {CIL_CLASS} parent as l_parent then
					Result := l_parent.pe_dump (a_stream)
					create l_resolution.make_with_tag_and_index ({PE_RESOLUTION_SCOPE}.typeref, l_parent.pe_index)
					if attached {PE_WRITER} a_stream.pe_writer as l_writer then
						l_typename_index := l_writer.hash_string (name)
						create {PE_TYPE_REF_TABLE_ENTRY} l_table.make_with_data (l_resolution, l_typename_index, l_namespace_index)
						pe_index := l_writer.add_table_entry (l_table)
					end
				else
					create l_resolution.make_with_tag_and_index ({PE_RESOLUTION_SCOPE}.assemblyref, parent_assembly (a_stream))
					if attached {PE_WRITER} a_stream.pe_writer as l_writer then
						l_typename_index := l_writer.hash_string (name)
						l_namespace_index := parent_namespace (a_stream)
						create {PE_TYPE_REF_TABLE_ENTRY} l_table.make_with_data (l_resolution, l_typename_index, l_namespace_index)
						pe_index := l_writer.add_table_entry (l_table)
					end
				end
			end
			Result := True
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
