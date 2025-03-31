note
	description: "Operand Size"
	date: "$Date$"
	revision: "$Revision$"

once class
	CIL_OPERAND_SIZE

create
	any, i8, u8, i16, u16, i32, u32, i64, u64, inative, r4, r8

feature {NONE} -- Creation

	any once end
	i8 once end
	u8 once end
	i16 once end
	u16 once end
	i32 once end
	u32 once end
	i64 once end
	u64 once end
	inative once end
	r4 once end
	r8 once end

feature -- Access

	instances: ITERABLE [CIL_OPERAND_SIZE]
		do
			Result := <<{CIL_OPERAND_SIZE}.any, {CIL_OPERAND_SIZE}.i8, {CIL_OPERAND_SIZE}.u8, {CIL_OPERAND_SIZE}.i16, {CIL_OPERAND_SIZE}.u16, {CIL_OPERAND_SIZE}.i32, {CIL_OPERAND_SIZE}.u32, {CIL_OPERAND_SIZE}.i64, {CIL_OPERAND_SIZE}.u64, {CIL_OPERAND_SIZE}.inative, {CIL_OPERAND_SIZE}.r4, {CIL_OPERAND_SIZE}.r8>>
		ensure
			static: class
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
