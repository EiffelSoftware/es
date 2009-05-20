indexing
	description: "Constants for Code Generator."
	author: "Lucien Hansen"
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_CODE_GENERATOR_CONSTANTS

feature -- tokens

	t_tab: STRING is "%T"

	t_newline: STRING is "%N"

feature -- indents



feature -- header strings

	feature_header_comment: STRING is "Adds the custom serialization to 'a_form' object"

	feature_start_name_string: STRING is "create_custom_form_for_"

	feature_argument_string: STRING is "(a_form: SERIALIZED_FORM)"

	feature_precondition_string: STRING is "not_void: a_form /= void"

	feature_locals_string: STRING is "l_list"

	feature_locals_type: STRING is "ARRAYED_LIST [STRING]"

feature -- body strings




indexing
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
