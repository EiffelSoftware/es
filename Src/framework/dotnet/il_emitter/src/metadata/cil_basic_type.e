note
	description: "Enumeration Representing CIL Basic Types"
	date: "$Date$"
	revision: "$Revision$"

once class
	CIL_BASIC_TYPE

create
	class_ref, -- type is a reference to a class
	method_ref, -- type is a reference to a method signature
	type_var, -- type is a generic variable
	method_param, -- type is a generic method param
	Void_, Bool, Char, i8, u8, i16, u16, i32, u32, i64, u64, inative, unative, r32, r64, object, string -- various CIL types

feature {NONE} -- Creation

	class_ref once end
	method_ref once end
	type_var once end
	method_param once end
	Void_ once end
	Bool once end
	Char once end
	i8 once end
	u8 once end
	i16 once end
	u16 once end
	i32 once end
	u32 once end
	i64 once end
	u64 once end
	inative once end
	unative once end
	r32 once end
	r64 once end
	object once end
	string once end

feature -- Access

	instances: ITERABLE [CIL_BASIC_TYPE]
			-- All known Basic Types
		once
			Result := <<
					{CIL_BASIC_TYPE}.class_ref,
					{CIL_BASIC_TYPE}.method_ref,
					{CIL_BASIC_TYPE}.type_var,
					{CIL_BASIC_TYPE}.method_param,
					{CIL_BASIC_TYPE}.Void_,
					{CIL_BASIC_TYPE}.Bool,
					{CIL_BASIC_TYPE}.Char,
					{CIL_BASIC_TYPE}.i8,
					{CIL_BASIC_TYPE}.u8,
					{CIL_BASIC_TYPE}.i16,
					{CIL_BASIC_TYPE}.u16,
					{CIL_BASIC_TYPE}.i32,
					{CIL_BASIC_TYPE}.u32,
					{CIL_BASIC_TYPE}.i64,
					{CIL_BASIC_TYPE}.u64,
					{CIL_BASIC_TYPE}.inative,
					{CIL_BASIC_TYPE}.unative,
					{CIL_BASIC_TYPE}.r32,
					{CIL_BASIC_TYPE}.r64,
					{CIL_BASIC_TYPE}.object,
					{CIL_BASIC_TYPE}.string
				>>
		ensure
			instance_free: class
		end

	index_of (a_value: CIL_BASIC_TYPE): NATURAL_8
			-- Index of first occurrence of item identical to `a_value'.
			-- -1 if none.
		local
			l_area: SPECIAL [CIL_BASIC_TYPE]
		do
			l_area := (create {ARRAYED_LIST [CIL_BASIC_TYPE]}.make_from_iterable ({CIL_BASIC_TYPE}.instances)).area
			Result := l_area.index_of (a_value, l_area.lower).to_natural_8
		ensure
			instance_free: class
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
