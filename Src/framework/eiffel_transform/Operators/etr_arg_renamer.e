note
	description: "Renames feature arguments"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_ARG_RENAMER
inherit
	ETR_SHARED
		export
			{NONE} all
		end
	REFACTORING_HELPER
		export
			{NONE} all
		end
	ETR_ERROR_HANDLER

feature
	transformation_result: ETR_TRANSFORMABLE
			-- result of last transformation

	rename_argument(a_function: ETR_TRANSFORMABLE; an_argument_position: INTEGER; a_new_name: STRING)
			-- rename the argument at `an_arg_position' in `a_fuction'
		require
			fun_set_and_valid: a_function /= void and then a_function.is_valid
			name_set: a_new_name /= void
			position_positive: an_argument_position>0
		local
			l_resulting_context: ETR_FEATURE_CONTEXT
		do
			reset_errors

			if attached {ETR_FEATURE_CONTEXT}a_function.context as l_feat_context then
				if l_feat_context.has_arguments then
					if l_feat_context.arguments.count >= an_argument_position then
						-- valid case

						-- create new changed context
						create l_resulting_context.make_from_other (l_feat_context)
						l_resulting_context.arguments[an_argument_position].set_name (a_new_name)

						-- transform to the new context
						basic_operators.transform_to_context (a_function, l_resulting_context)

						transformation_result := basic_operators.transformation_result
					else
						add_error("rename_argument: No argument at position "+an_argument_position.out)
					end
				else
					add_error("rename_argument: Feature has no argument")
				end
			else
				add_error("rename_argument: a_function does not have a feature-context")
			end
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
