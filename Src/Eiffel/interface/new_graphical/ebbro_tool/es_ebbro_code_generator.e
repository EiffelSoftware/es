indexing
	description: "Generate Code for Custom Serialized Form Feature. In the future could be used to generate other code as well."
	author: "Lucien Hansen"
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_CODE_GENERATOR

inherit
	ES_EBBRO_CODE_GENERATOR_CONSTANTS

create
	make

feature -- init

	make is
			-- currently not used
		do
		end


feature -- Basic Operations

	custom_form_feature (a_list: ARRAYED_LIST [STRING_8]; a_class_name: STRING): STRING is
			-- generate the custom serialization "add" feature for a given list of attribute names
		local
			l_name: STRING
		do
			create l_name.make_from_string (a_class_name)
			l_name.to_lower

			create Result.make_from_string (t_tab)
			Result.append (feature_start_name_string)
			Result.append (l_name + " ")
			Result.append (feature_argument_string)
			Result.append (" is" + t_newline)
			Result.append (t_tab + t_tab + t_tab + "-- ")
			Result.append (feature_header_comment+t_newline)
			Result.append (t_tab + t_tab + "require" + t_newline)
			Result.append (t_tab + t_tab + t_tab + feature_precondition_string + t_newline)
			Result.append (t_tab + t_tab + "local" + t_newline)
			Result.append (t_tab + t_tab + t_tab + feature_locals_string + ": " + feature_locals_type + t_newline)
			Result.append (t_tab + t_tab + "do" + t_newline)
			Result.append (t_tab + t_tab + t_tab + "create " + feature_locals_string + ".make(1," + a_list.count.out + ")" + t_newline)
			from
				a_list.start
			until
				a_list.after
			loop
				Result.append (t_tab + t_tab + t_tab + feature_locals_string + ".extend(%"" + a_list.item + "%")" + t_newline)
				a_list.forth
			end

			Result.append (t_tab + t_tab + t_newline)
			Result.append (t_tab + t_tab + t_tab + "a_form.put_serialized_form(" + feature_locals_string + ",%"" + a_class_name + "%")")
			Result.append (t_tab + t_tab + t_newline)
			Result.append (t_tab + t_tab + t_newline)
			Result.append (t_tab + t_tab + "end" + t_newline)


		end




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
