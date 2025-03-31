note
	description: "Summary description for {PE_SIGNATURE_GENERATOR}."
	date: "$Date$"
	revision: "$Revision$"

class
	PE_SIGNATURE_GENERATOR


inherit

	ANY
		redefine
			default_create
		end

feature {NONE} -- Initilization

	default_create
		do
			create work_area.make_filled (0, 400 * 1024)
		end

feature -- Access

	work_area: SPECIAL [INTEGER]
			-- 400 * 1024

	basic_types: SPECIAL [INTEGER]
		do
			Result := <<
										0,
                                        0,
                                        0,
                                        0,
                                        {PE_TYPES_ENUM}.ELEMENT_TYPE_VOID,
                                        {PE_TYPES_ENUM}.ELEMENT_TYPE_bool,
                                        {PE_TYPES_ENUM}.ELEMENT_TYPE_CHAR,
                                        {PE_TYPES_ENUM}.ELEMENT_TYPE_I1,
                                        {PE_TYPES_ENUM}.ELEMENT_TYPE_U1,
                                        {PE_TYPES_ENUM}.ELEMENT_TYPE_I2,
                                        {PE_TYPES_ENUM}.ELEMENT_TYPE_U2,
                                        {PE_TYPES_ENUM}.ELEMENT_TYPE_I4,
                                        {PE_TYPES_ENUM}.ELEMENT_TYPE_U4,
                                        {PE_TYPES_ENUM}.ELEMENT_TYPE_I8,
                                        {PE_TYPES_ENUM}.ELEMENT_TYPE_U8,
                                        {PE_TYPES_ENUM}.ELEMENT_TYPE_I,
                                        {PE_TYPES_ENUM}.ELEMENT_TYPE_U,
                                        {PE_TYPES_ENUM}.ELEMENT_TYPE_R4,
                                        {PE_TYPES_ENUM}.ELEMENT_TYPE_R8,
                                        0,
                                        {PE_TYPES_ENUM}.ELEMENT_TYPE_STRING
			>>
		ensure
			instance_free: class
		end

	object_base: INTEGER assign set_object_base

feature -- Element Change

	set_object_base (a_base: INTEGER)
			-- Set `object_base` with `a_base`
		do
			object_base := a_base
		ensure
			object_base_set: object_base = a_base
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
