note
	description: "Computes the type of expressions. Based on AFX_EXPRESSION_TYPE_CHECKER"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_TYPE_CHECKER

inherit
	REFACTORING_HELPER
		export
			{NONE} all
		end
	AST_FEATURE_CHECKER_GENERATOR
		export
			{NONE} all
			{ANY} last_type
		end
	SHARED_AST_CONTEXT
		rename
			context as ast_context
		export
			{NONE} all
		end
	ETR_ERROR_HANDLER
	ETR_SHARED
		rename
			basic_operators as etr_basic_ops
		end

feature -- Type checking

	check_transformable (a_transformable: ETR_TRANSFORMABLE)
			-- Type check `a_transformable' in its context
			-- Store type in `last_type'.
		require
			non_void: a_transformable /= void
			valid: a_transformable.is_valid
			has_context: not a_transformable.context.is_empty
		do
			reset_errors

			check_ast_type_at(a_transformable.target_node, a_transformable.context, a_transformable.path)
		end

	check_ast_type (an_ast: AST_EIFFEL; a_context: ETR_CONTEXT)
			-- Type check `an_ast' in `a_context'.
			-- Store type in `last_type'.
		require
			non_void: an_ast /= void and a_context /= void
			not_empty: not a_context.is_empty
		do
			check_ast_type_at (an_ast, a_context, void)
		end

	check_ast_type_at (an_ast: AST_EIFFEL; a_context: ETR_CONTEXT; a_path: detachable AST_PATH)
			-- Type check `an_ast' in `a_context'.
			-- use `a_path' to determine a precise scope
		require
			non_void: an_ast /= void and a_context /= void
			not_empty: not a_context.is_empty
			valid: attached a_path implies a_path.is_valid
		local
			l_ast_string: STRING
			l_feat: FEATURE_I
		do
			reset_errors

			-- reparse the ast as expression, so it can be type-checked correctly
			l_ast_string := ast_to_string(an_ast)
			etr_expr_parser.parse_from_string("check "+l_ast_string,void)
			if etr_expr_parser.error_count > 0 then
				add_error("check_ast_type: Cannot parse an_ast as EXPR_AS")
			else
				init (ast_context)
				ast_context.set_is_ignoring_export (True)
				ast_context.initialize (a_context.class_context.written_class, a_context.class_context.written_class.actual_type, a_context.class_context.written_class.feature_table)

				if attached {ETR_FEATURE_CONTEXT}a_context as l_feat_context then
					l_feat := l_feat_context.original_written_feature
					init_object_test_locals (l_feat_context, a_path)
				end

				check_expr_type (a_context, etr_expr_parser.expression_node)
			end
		end

feature {NONE} -- Implementation

	init_object_test_locals (a_feature_context: ETR_FEATURE_CONTEXT; a_path: AST_PATH)
			-- init with object test locals from `a_feature_context'
		local
			l_local_info: LOCAL_INFO
			l_cur_local: ETR_OBJECT_TEST_LOCAL
			l_ot_id: ID_AS
		do
			if attached a_path then
				from
					a_feature_context.object_test_locals.start
				until
					a_feature_context.object_test_locals.after
				loop
					l_cur_local := a_feature_context.object_test_locals.item
					if a_path.is_child_of (l_cur_local.scope) then
						create l_local_info
						l_local_info.set_type (l_cur_local.type)
						l_local_info.set_is_used (True)
						create l_ot_id.initialize(l_cur_local.name)
						context.add_object_test_local (l_local_info, l_ot_id)
						context.add_object_test_expression_scope (l_ot_id)

						check
							attached context.object_test_local (names_heap.id_of (l_cur_local.name))
						end

					end

					a_feature_context.object_test_locals.forth
				end
			end
		end

	init_locals (a_feature_context: ETR_FEATURE_CONTEXT)
			-- adds the locals from `a_feature_context'
		local
			l_index: INTEGER
			l_local_info: LOCAL_INFO
			l_cur_local: ETR_CONTEXT_TYPED_VAR
		do
			if a_feature_context.has_locals then
				from
					l_index := a_feature_context.locals.lower
				until
					l_index > a_feature_context.locals.upper
				loop
					l_cur_local := a_feature_context.locals[l_index]
					create l_local_info
					l_local_info.set_type(l_cur_local.resolved_type)
					l_local_info.set_position (l_index)
					context.locals.put (l_local_info, names_heap.id_of (l_cur_local.name))
					l_index := l_index + 1
				end
			end
		end

	init_arguments (a_feature_context: ETR_FEATURE_CONTEXT)
			-- adds the arguments from `a_feature_context'
		local
			l_index: INTEGER
			l_local_info: LOCAL_INFO
			l_cur_arg: ETR_CONTEXT_TYPED_VAR
		do
			if a_feature_context.has_arguments then
				from
					l_index := a_feature_context.arguments.lower
				until
					l_index > a_feature_context.arguments.upper
				loop
					l_cur_arg := a_feature_context.arguments[l_index]
					create l_local_info
					l_local_info.set_type(l_cur_arg.resolved_type)
					l_local_info.set_position (l_index)
					context.locals.put (l_local_info, names_heap.id_of (l_cur_arg.name))
					l_index := l_index + 1
				end
			end
		end

	check_expr_type (a_context: ETR_CONTEXT; an_expr: EXPR_AS)
			-- typechecks `an_expr' in `a_context'
		local
			l_class: CLASS_C
			l_feat: FEATURE_I
			l_error_level: like error_level
		do
			l_class := a_context.class_context.written_class
			error_handler.wipe_out
			reset
			l_error_level := error_level
			ast_context.locals.wipe_out

			if attached {ETR_FEATURE_CONTEXT}a_context as l_feat_context then
				l_feat := l_feat_context.original_written_feature
				current_feature := l_feat

				init_locals(l_feat_context)
				init_arguments(l_feat_context)
			end

			context.init_attribute_scopes
			context.init_local_scopes
			type_a_checker.init_for_checking (l_feat, l_class, Void, error_handler)
			inherited_type_a_checker.init_for_checking (l_feat, l_class, Void, Void)

			if l_error_level = error_level then
				an_expr.process (Current)
			end
			if error_handler.error_list.count>0 then
				add_error("expression_or_instruction_type_check_and_code: Type checker returned error "+error_handler.error_list.last.generating_type)
			end
			error_handler.wipe_out
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
