note
	description: "Renames feature arguments and locals"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_RENAMER
inherit
	REFACTORING_HELPER
		export
			{NONE} all
		end
	ETR_SHARED_ERROR_HANDLER
	ETR_SHARED_BASIC_OPERATORS

feature -- Operation
	transformation_result: ETR_TRANSFORMABLE
			-- Result of last transformation

	rename_local(a_transformable: ETR_TRANSFORMABLE; a_feature_name: STRING; an_old_name, a_new_name: STRING)
			-- Rename the local `an_old_name' to `a_new_name' in `a_transformable' of feature `a_feature_name'
		require
			fun_set_and_valid: a_transformable /= void and then a_transformable.is_valid
			name_set: a_new_name /= void and an_old_name /= void
		local
			l_resulting_context: ETR_FEATURE_CONTEXT
		do
			if attached a_transformable.context.class_context.written_in_features_by_name[a_feature_name] as l_feat_context then
				if l_feat_context.has_arguments then
					if attached l_feat_context.local_by_name[an_old_name] then
						-- create new changed context
						create l_resulting_context.make_from_other (l_feat_context)
						l_resulting_context.local_by_name[an_old_name].set_name (a_new_name)
						l_resulting_context.set_modified

						-- transform to the new context
						basic_operators.transform_to_context (a_transformable, l_resulting_context)

						transformation_result := basic_operators.transformation_result
					else
						error_handler.add_error (Current, "rename_local", "No local with name "+a_new_name)
					end
				else
					error_handler.add_error (Current, "rename_local", "Feature has no locals")
				end
			else
				error_handler.add_error (Current, "rename_local", "a_function does not have a feature-context")
			end
		end

	rename_argument(a_transformable: ETR_TRANSFORMABLE; a_feature_name: STRING; an_old_name, a_new_name: STRING)
			-- Rename the argument `an_old_name' to `a_new_name' in `a_transformable' of feature `a_feature_name'
		require
			fun_set_and_valid: a_transformable /= void and then a_transformable.is_valid
			name_set: a_new_name /= void and an_old_name /= void
		local
			l_resulting_context: ETR_FEATURE_CONTEXT
		do
			if attached a_transformable.context.class_context.written_in_features_by_name[a_feature_name] as l_feat_context then
				if l_feat_context.has_arguments then
					if attached l_feat_context.arg_by_name[an_old_name] then
						-- create new changed context
						create l_resulting_context.make_from_other (l_feat_context)
						l_resulting_context.arg_by_name[an_old_name].set_name (a_new_name)
						l_resulting_context.set_modified

						-- transform to the new context
						basic_operators.transform_to_context (a_transformable, l_resulting_context)

						transformation_result := basic_operators.transformation_result
					else
						error_handler.add_error (Current, "rename_argument", "No argument with name "+a_new_name)
					end
				else
					error_handler.add_error (Current, "rename_argument", "Feature has no arguments")
				end
			else
				error_handler.add_error (Current, "rename_argument", "a_function does not have a feature-context")
			end
		end

	rename_argument_at_position(a_function: ETR_TRANSFORMABLE; a_feature_name: STRING; an_argument_position: INTEGER; a_new_name: STRING)
			-- Rename the argument at `an_arg_position' in `a_transformable' of feature `a_feature_name'
		require
			fun_set_and_valid: a_function /= void and then a_function.is_valid
			name_set: a_new_name /= void
			position_positive: an_argument_position>0
		local
			l_resulting_context: ETR_FEATURE_CONTEXT
		do
			if attached a_function.context.class_context.written_in_features_by_name[a_feature_name] as l_feat_context then
				if l_feat_context.has_arguments then
					if l_feat_context.arguments.count >= an_argument_position then
						-- valid case

						-- create new changed context
						create l_resulting_context.make_from_other (l_feat_context)
						l_resulting_context.arguments[an_argument_position].set_name (a_new_name)
						l_resulting_context.set_modified

						-- transform to the new context
						basic_operators.transform_to_context (a_function, l_resulting_context)

						transformation_result := basic_operators.transformation_result
					else
						error_handler.add_error (Current, "rename_argument_at_position", "No argument at position "+an_argument_position.out)
					end
				else
					error_handler.add_error (Current, "rename_argument_at_position", "Feature has no argument")
				end
			else
				error_handler.add_error (Current, "rename_argument_at_position", "a_function does not have a feature-context")
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
