note
	description: "Operator to transform to another context."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_TRANSFORM_CONTEXT
inherit
	ETR_SHARED_ERROR_HANDLER
	ETR_SHARED_LOGGER
	ETR_SHARED_TOOLS
	ETR_SHARED_PARSERS

feature {NONE} -- Implementation

	add_constraint_renamings (a_feature_name: STRING; a_source_type, a_target_type: TYPE_A; a_renaming_list: LIST[ETR_CT_CONSTRAINT_RENAMING])
			-- Extracts renamings of `a_source_type' and `a_target_type'
		require
			non_void: a_feature_name /= void and a_source_type /= void and a_target_type /= void
		local
			l_source_renaming, l_target_renaming: RENAMING_A
			l_constraint_renaming: ETR_CT_CONSTRAINT_RENAMING
		do
			if attached {RENAMED_TYPE_A[TYPE_A]}a_source_type as l_ren then
				l_source_renaming := l_ren.renaming
			end
			if attached {RENAMED_TYPE_A[TYPE_A]}a_target_type as l_ren then
				l_target_renaming := l_ren.renaming
			end

			if l_source_renaming /= void or l_target_renaming /= void then
				create l_constraint_renaming.make(a_feature_name, l_source_renaming, l_target_renaming)
				a_renaming_list.extend (l_constraint_renaming)
			end
		end

	changed_name_or_type ( a_old_name, a_new_name: STRING; a_old_type, a_new_type: TYPE_A): ETR_CT_CHANGED_NAME_TYPE
				-- Checks for changed name or type of local/arg
		local
			l_changed_type, l_changed_name: BOOLEAN
		do
			-- Check for changed type
			if a_old_type.associated_class.class_id /= a_new_type.associated_class.class_id then
				l_changed_type := true
			end

			-- Check for changed name
			if not a_new_name.is_equal (a_old_name) then
				l_changed_name := true
			end

			if l_changed_type and l_changed_name then
				create Result.make_changed_name_type(a_old_name, a_new_name, a_old_type.associated_class, a_new_type.associated_class)
			elseif l_changed_type then
				create Result.make_changed_type(a_old_name, a_old_type.associated_class, a_new_type.associated_class)
			elseif l_changed_name then
				create Result.make_changed_name(a_old_name, a_new_name)
			end
		end

feature -- Access

	transformation_result: ETR_TRANSFORMABLE
			-- Result of last transformation

feature -- Transformations

	transform_to_context (a_transformable: ETR_TRANSFORMABLE; a_target_context: ETR_CONTEXT)
			-- Transform `a_transformable' into `a_target_context'
		require
			non_void: a_transformable /= void and a_target_context /= void
			valid_transformable: a_transformable.is_valid
		local
			l_source_context: ETR_CONTEXT
			l_changed_args_locals: LINKED_LIST[ETR_CT_CHANGED_NAME_TYPE]
			l_constraint_renaming_list: LINKED_LIST[ETR_CT_CONSTRAINT_RENAMING]
			l_changed_var: ETR_CT_CHANGED_NAME_TYPE
			l_old_feat, l_new_feat: FEATURE_I
			l_cur_old_arg, l_cur_new_arg: ETR_TYPED_VAR
			l_cur_old_local, l_cur_new_local: ETR_TYPED_VAR
			l_index: INTEGER
			l_transformer: ETR_CONTEXT_TRANSFORMING_VISITOR
			l_output: ETR_AST_STRING_OUTPUT
			l_source_feat_table: FEATURE_TABLE
			l_old_expl_type, l_new_expl_type: TYPE_A
			l_changed_type, l_changed_name: BOOLEAN
			l_source_class_context, l_target_class_context: ETR_CLASS_CONTEXT
		do
			transformation_result := void

			l_source_context := a_transformable.context

			if not l_source_context.is_empty and not a_target_context.is_empty then
				l_source_class_context := l_source_context.class_context
				l_target_class_context := a_target_context.class_context

				create l_changed_args_locals.make
				create l_constraint_renaming_list.make

				-- class to class transformation
				-- loop through features and check for renamings
				from
					l_source_feat_table := l_source_class_context.written_class.feature_table
					l_source_feat_table.start
				until
					l_source_feat_table.after
				loop
					l_old_feat := l_source_feat_table.item_for_iteration
					l_new_feat := l_target_class_context.class_context.written_class.feature_of_rout_id_set (l_old_feat.rout_id_set)

					if l_new_feat /= void then
						l_changed_var := void

						-- check if theres renamings
						if l_old_feat.feature_name_id /= l_new_feat.feature_name_id then
							l_changed_name := true
						end

						if l_old_feat.has_return_value and l_new_feat.has_return_value then
							-- check if the type changed
							l_old_expl_type := type_checker.explicit_type (l_old_feat.type, l_source_class_context.written_class, l_old_feat)
							l_new_expl_type := type_checker.explicit_type (l_new_feat.type, l_target_class_context.written_class, l_new_feat)

							if l_old_expl_type.associated_class.class_id /= l_new_expl_type.associated_class.class_id then
								l_changed_type := true
							end

							add_constraint_renamings (l_old_feat.feature_name, l_old_expl_type, l_new_expl_type, l_constraint_renaming_list)
						end

						if l_changed_type and l_changed_name then
							create l_changed_var.make_changed_name_type(l_old_feat.feature_name, l_new_feat.feature_name, l_old_expl_type.associated_class, l_new_expl_type.associated_class)
						elseif l_changed_type then
							create l_changed_var.make_changed_type(l_old_feat.feature_name, l_old_expl_type.associated_class, l_new_expl_type.associated_class)
						elseif l_changed_name then
							create l_changed_var.make_changed_name(l_old_feat.feature_name, l_new_feat.feature_name)
						end

						if l_changed_var /= void then
							l_changed_args_locals.extend (l_changed_var)
						end
					end

					l_source_feat_table.forth
				end

				if attached {ETR_FEATURE_CONTEXT}l_source_context as l_source_feat_context and attached {ETR_FEATURE_CONTEXT}a_target_context as l_target_feat_context then
					-- check for renamed arguments and changed types
					-- they are matched strictly by position!
					-- which may give completely wrong results
					if l_source_feat_context.has_arguments and l_target_feat_context.has_arguments then
						from
							l_index := 1
						until
							l_index > l_source_feat_context.arguments.count or else l_index > l_target_feat_context.arguments.count
						loop
							l_cur_old_arg := l_source_feat_context.arguments[l_index]
							l_cur_new_arg := l_target_feat_context.arguments[l_index]

							l_changed_var := changed_name_or_type(l_cur_old_arg.name, l_cur_new_arg.name, l_cur_old_arg.resolved_type, l_cur_new_arg.resolved_type)
							if attached l_changed_var then
								l_changed_args_locals.extend (l_changed_var)
							end

							add_constraint_renamings (l_cur_old_arg.name, l_cur_old_arg.resolved_type, l_cur_new_arg.resolved_type, l_constraint_renaming_list)

							l_index := l_index + 1
						end
					end

					-- check for renamed locals and changed types
					if l_source_feat_context.has_locals and l_target_feat_context.has_locals then
						from
							l_index := 1
						until
							l_index > l_source_feat_context.locals.count or l_index > l_target_feat_context.locals.count
						loop
							l_cur_old_local := l_source_feat_context.locals[l_index]
							l_cur_new_local := l_target_feat_context.locals[l_index]

							l_changed_var := changed_name_or_type(l_cur_old_local.name, l_cur_new_local.name, l_cur_old_local.resolved_type, l_cur_new_local.resolved_type)
							if attached l_changed_var then
								l_changed_args_locals.extend (l_changed_var)
							end

							add_constraint_renamings (l_cur_old_local.name, l_cur_old_local.resolved_type, l_cur_new_local.resolved_type, l_constraint_renaming_list)

							l_index := l_index + 1
						end
					end
				end
			end

			-- Now visit the ETR_TRANSFORMABLE
			-- and perform replacements
			create l_output.make
			create l_transformer.make(l_output, l_changed_args_locals, l_constraint_renaming_list)
			-- Print the ast to output
			l_transformer.print_ast_to_output (a_transformable.target_node)
			-- Reparse it
			parsing_helper.parse_printed_ast (a_transformable.target_node, l_output.string_representation)

			if attached parsing_helper.parsed_ast then
				create transformation_result.make(parsing_helper.parsed_ast, a_target_context, false)
			else
				error_handler.add_error (Current, "transform_to_context", "Failed to reparse result of transformation")
				create transformation_result.make_invalid
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
