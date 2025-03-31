note
	description: "[
			Object representing a value
			A value, typically to be used as an operand.
			Various other classes derive from this to make specific types of operand values.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	CIL_VALUE

create
	make,
	make_with_type

feature {NONE} --Initialization

	make (a_name: STRING_32; a_type: detachable CIL_TYPE)
			-- Create an object with `a_name` and type `a_type`
		do
			name := a_name
			type := a_type
		ensure
			name_set: name = a_name
			type_set: type = a_type
		end


	make_with_type (a_type: CIL_TYPE)
		do
			make ("", a_type)
		end

feature -- Access

	name: STRING_32

	type: detachable CIL_TYPE
			-- type of value.
			-- TODO check if it's better to use NULL pattern.

feature -- Change Element

	set_name (a_name: STRING_32)
			-- Set name.
		do
			name := a_name
		ensure
			name_set: name = a_name
		end

	set_type (a_type: like type)
			-- Set type of value.
		do
			type := a_type
		ensure
			type_set: type = a_type
		end

feature -- Output

	il_src_dump (a_file: FILE_STREAM): BOOLEAN
		do
				-- used for types
			if attached type as l_type then
				Result := l_type.il_src_dump (a_file)
			end
			Result := True
		end

	render (a_stream: FILE_STREAM; a_opcode: INTEGER; a_operand_type: INTEGER; a_result: SPECIAL [NATURAL_8]; a_offset: INTEGER): NATURAL_32
		do
			if attached type as l_type then
				Result := l_type.render (a_stream, a_result, a_offset)
			end
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
