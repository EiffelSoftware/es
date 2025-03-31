note
	description: "[
		Value: a method name (used as an operand)
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	CIL_METHOD_NAME

inherit

	CIL_VALUE
		rename
			make as make_value
		redefine
			il_src_dump,
			render
		end
	REFACTORING_HELPER



create
	make

feature {NONE} -- Initialization

	make (a_method_sig: CIL_METHOD_SIGNATURE)
		do
			make_value("", Void)
			signature := a_method_sig
		ensure
			signature_set: signature = a_method_sig
		end

feature -- Access

	signature: CIL_METHOD_SIGNATURE


feature -- Output

	render (a_stream: FILE_STREAM; a_opcode: INTEGER; a_operand_type: INTEGER; a_byte: SPECIAL [NATURAL_8]; a_offset: INTEGER): NATURAL_32
		local
			l_res: BOOLEAN
		do
			if a_opcode = {CIL_INSTRUCTION_OPCODES}.index_of ({CIL_INSTRUCTION_OPCODES}.i_calli) then
				if signature.pe_index_type = 0 then
					l_res := signature.pe_dump (a_stream, True)
				end
				{BYTE_SPECIAL_HELPER}.put_special_natural_32_with_natural_64 (a_byte, signature.pe_index_type | ({PE_TABLES}.tstandalonesig |<< 24), a_offset)
			else
				if signature.pe_index = 0 and then signature.pe_index_call_site = 0 then
					l_res := signature.pe_dump (a_stream, False)
				end
				if signature.pe_index /= 0 then
					{BYTE_SPECIAL_HELPER}.put_special_natural_32_with_natural_64 (a_byte, signature.pe_index | ({PE_TABLES}.tmethoddef |<< 24), a_offset)
				elseif not signature.generic.is_empty then
					{BYTE_SPECIAL_HELPER}.put_special_natural_32_with_natural_64 (a_byte, signature.pe_index_call_site | ({PE_TABLES}.tmethodspec |<< 24), a_offset)
				else
					{BYTE_SPECIAL_HELPER}.put_special_natural_32_with_natural_64 (a_byte, signature.pe_index_call_site | ({PE_TABLES}.tmemberref |<< 24), a_offset)
				end
			end
			Result := 4
		end

	il_src_dump (a_file: FILE_STREAM): BOOLEAN
		do
			Result := signature.il_src_dump (a_file, false, false, false)
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
