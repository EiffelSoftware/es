note
	description: "[
			A boxed type, e.g. the reference to a System::* object which
			represents the basic type
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	CIL_BOXED_TYPE

inherit

	CIL_TYPE
		rename
			make as make_type
		redefine
			il_src_dump,
			render,
			type_names
		end

create
	make

feature {NONE} -- Initialization

	make (a_basic_type: CIL_BASIC_TYPE)
		do
			make_with_pointer_level (a_basic_type, 0)
		end

feature -- Output

	render (a_stream: FILE_STREAM; a_bytes: SPECIAL [NATURAL_8]; a_offset: INTEGER): NATURAL_8
		local
			l_system: NATURAL_32
			l_name: NATURAL_32
			l_result: ANY
			l_res: BOOLEAN
		do
			if attached {PE_WRITER} a_stream.pe_writer as l_writer then
				if pe_index = 0 then
						-- systemName in C++.
					l_system := l_writer.system_index

					l_name := l_writer.hash_string (type_names[{CIL_BASIC_TYPE}.index_of (basic_type)])
					l_result := a_stream.find ("System." + type_names[{CIL_BASIC_TYPE}.index_of (basic_type)])
					if attached {CIL_CLASS} l_result as l_class then
						l_res := l_class.pe_dump (a_stream)
						pe_index := l_class.pe_index
					end
				end
				{BYTE_SPECIAL_HELPER}.put_special_integer_32_with_natural_64 (a_bytes, pe_index | {PE_TABLES}.ttyperef |<< 24, a_offset)
				Result := 4
			end
		end

	il_src_dump (a_stream: FILE_STREAM): BOOLEAN
		do
				-- no point in looking up the type name in the assembly for this...
				-- TODO double check with the latest .Net framework.
			--a_stream.put_string ("[mscorlib]System.")
			a_stream.put_string ("[System.Runtime]System.")
			a_stream.put_string (type_names [{CIL_BASIC_TYPE}.index_of (basic_type) + 1])
			Result := True
		end

feature -- Static

	type_names: ARRAYED_LIST [STRING]
		once
			create Result.make_from_array (<<
					"", "", "", "", "", "Bool", "Char", "SByte", "Byte",
					"Int16", "UInt16", "Int32", "UInt32", "Int64", "UInt64", "IntPtr",
					"UIntPtr", "Single", "Double", "Object", "String"
				>>)
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
