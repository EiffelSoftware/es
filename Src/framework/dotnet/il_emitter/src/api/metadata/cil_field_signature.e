note
	description: "Summary description for {CIL_FIELD_SIGNATURE}."
	date: "$Date$"
	revision: "$Revision$"

class
	CIL_FIELD_SIGNATURE


create
	make



feature {NONE} -- Initialization

	make
		do
			create field.make ("",create {CIL_TYPE}.make (create {CIL_BASIC_TYPE}.void_), create {CIL_QUALIFIERS}.make)
		end

feature -- Access		


	field: CIL_FIELD
		-- The field

feature -- Change Element

	set_name (a_name: READABLE_STRING_GENERAL)
			-- Set field name with `a_name'
		do
			field.set_name (a_name)
		end


	set_field_type (a_type: CIL_TYPE)
			-- Set field type with `a_type'
		do
			field.set_type (a_type)
		end


	set_flags (a_flags: CIL_QUALIFIERS)
			-- Set field flags with `a_flags'.
		do
			field.set_flags (a_flags)
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
