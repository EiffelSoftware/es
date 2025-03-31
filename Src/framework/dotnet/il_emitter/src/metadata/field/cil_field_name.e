note
	description: "value: a field name (used as an operand)"
	date: "$Date$"
	revision: "$Revision$"

class
	CIL_FIELD_NAME

inherit

	CIL_VALUE
		rename
			make as make_value
		redefine
			il_src_dump,
			render
		end

create
	make

feature {NONE} -- Initialization

	make (a_field: CIL_FIELD)
			--| Can be used to make the field a reference to another
			--|assembly, in a rudimentary way
		do
			make_value("", Void)
			field := a_field
		ensure
			field_set: field = a_field
		end

feature -- Access

	field: CIL_FIELD
		-- The field reference.		

feature -- Output

	il_src_dump (a_file: FILE_STREAM): BOOLEAN
		do
			if field.type.basic_type = {CIL_BASIC_TYPE}.class_ref then
				if attached field.type.type_ref as l_type_ref and then
					l_type_ref.flags.flags & {CIL_QUALIFIERS_ENUM}.value /= 0
				then
					a_file.put_string ("valuetype ")
				else
					a_file.put_string ("class ")
				end
			end
			Result := field.type.il_src_dump (a_file)
			a_file.put_string (" ")
			a_file.put_string ({CIL_QUALIFIERS}.name (field.name, field.parent, False))
			Result := True
		end

	render (a_stream: FILE_STREAM; a_opcode: INTEGER; a_operand_code: INTEGER; a_result: SPECIAL [NATURAL_8]; a_offset: INTEGER): NATURAL_32
		local
			l_res: BOOLEAN
		do
			if attached {CIL_DATA_CONTAINER} field.parent as l_container and then l_container.in_assembly_ref then
				l_res := field.pe_dump (a_stream)
				{BYTE_SPECIAL_HELPER}.put_special_natural_32_with_natural_64 (a_result, field.pe_index | {PE_TABLES}.tmemberref |<< 24, a_offset)
			else
				{BYTE_SPECIAL_HELPER}.put_special_natural_32_with_natural_64 (a_result, field.pe_index | {PE_TABLES}.tfield |<< 24, a_offset)
			end
			Result := 4
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
