note
	description: "Conversion operations output messages."
	author: "Teseo Schneider, Marco Piccioni"
	date: "09.04.09"

class
	CONVERTER_MESSAGES

feature --messages
	conversion_to_string (name, old_type: STRING): STRING
                        --
                do
                        Result := "Attribute " + name + " of type " + old_type + " automatically converted to a STRING with the %"out%" feature."
                end


        conversion_to_integer (name, old_type: STRING): STRING
                        --
                do
                        Result := "Attribute " + name + " of type " + old_type + " automatically converted to an INTEGER with the %"to_integer%" feature."
                end

        conversion_to_double (name, old_type: STRING): STRING
                        --
                do
                        Result := "Attribute " + name + " of type " + old_type + " automatically converted to a DOUBLE with the %"to_double%" feature."
                end

        conversion_to_boolean (name, old_type: STRING): STRING
                        --
                do
                        Result := "Attribute " + name + " of type " + old_type + " automatically converted to a BOOLEAN with the %"to_boolean%" feature."
                end

        conversion_impossible (name, old_type, new_type: STRING): STRING
                        --
                do
                        Result := "A default feature to convert the attribute " + name + " of type " + old_type + " to the type " + new_type + " does not exist."
                end

        constant_set(name, type, value: STRING): STRING
                        --
                do
                        Result := "New attribute " + name + " of type " + type + " set with its default value (" + value+")."
                end

        field_removed (name, old_type: STRING): STRING
                        --
                do
                        Result := "Attribute " + name + " of type " + old_type + " has been removed in the new version. Please check that it is not a renamed field."
                end
note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
