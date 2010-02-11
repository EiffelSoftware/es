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
	ETR_SHARED_AST_TOOLS
	ETR_SHARED_PARSERS
		rename
			error_handler as etr_error_handler
		export
			{ANY} parsing_helper
		end

feature -- Output

	print_type (a_type: TYPE_A; a_context: ETR_FEATURE_CONTEXT): STRING
			-- Prints `a_type' so it's parsable
		require
			type_non_void: a_type /= void
			context_set: a_context /= void
		local
			l_gen_count: INTEGER
			l_index: INTEGER
		do
			create Result.make_empty

			-- print attachment marks etc
			if attached {ATTACHABLE_TYPE_A}a_type as l_att_type then
				-- print attachment marks
				if l_att_type.has_attached_mark then
					Result.append_character ('!')
				elseif l_att_type.has_detachable_mark then
					Result.append_character ('?')
				end
			end

			-- print keywords
			if attached {CL_TYPE_A}a_type as l_cl_type then
				if l_cl_type.has_expanded_mark then
					Result.append ({SHARED_TEXT_ITEMS}.ti_expanded_keyword)
					Result.append_character (' ')
				elseif l_cl_type.has_reference_mark then
					Result.append ({SHARED_TEXT_ITEMS}.ti_reference_keyword)
					Result.append_character (' ')
				elseif l_cl_type.has_separate_mark then
					Result.append ({SHARED_TEXT_ITEMS}.ti_separate_keyword)
					Result.append_character (' ')
				end
			end

			if a_type.is_formal then
				if attached {FORMAL_A}a_type as l_formal then
					Result.append(a_context.class_context.written_class.generics[l_formal.position].formal.name.name)
				end
			elseif a_type.is_like_current then
				Result.append("like Current")
			elseif a_type.is_like_argument then
				if attached {LIKE_ARGUMENT}a_type as l_like_arg then
					Result.append("like "+a_context.arguments[l_like_arg.position].name)
				end
			elseif a_type.is_like then
				if attached {LIKE_FEATURE}a_type as l_like_feat then
					Result.append("like "+l_like_feat.feature_name)
				end
			elseif a_type.has_generics then
				if attached {GEN_TYPE_A}a_type as l_gen then
					Result.append (l_gen.associated_class.name_in_upper)

					-- recursively print generics
					l_gen_count := l_gen.generics.count

					if l_gen_count>0 then
						Result.append("[")
					end

					from
						l_index := 1
					until
						l_index > l_gen_count
					loop
						Result.append (print_type(l_gen.generics[l_index],a_context))
						if l_index /= l_gen_count then
							Result.append(",")
						end
						l_index := l_index+1
					end

					if l_gen_count>0 then
						Result.append("]")
					end
				end
			elseif attached {CL_TYPE_A}a_type as l_cl_t then
				Result.append (l_cl_t.associated_class.name_in_upper)
			elseif a_type.is_type_set then
				if attached {TYPE_SET_A}a_type as l_set then
					Result := print_type (l_set.first, a_context)
				end
			elseif a_type.has_renaming then
				if attached {RENAMED_TYPE_A[TYPE_A]}a_type as l_ren then
					Result := print_type(l_ren.actual_type, a_context)
				end
			else
				Result := a_type.dump -- can't handle, just use debug-dump
			end
		end

feature -- Type evaluation

	written_type_from_type_as (a_type: TYPE_AS; a_written_class: CLASS_C; a_feature: FEATURE_I): TYPE_A
			-- returns the type of `a_type' as it was written
		require
			type_non_void: a_type /= void
			context_set: a_written_class /= void and a_feature /= void
		local
			l_type_gen: AST_TYPE_A_GENERATOR
			l_generated_type, l_resolved_type: TYPE_A
			l_type_a_checker: TYPE_A_CHECKER
		do
			create l_type_gen
			create l_type_a_checker

			l_generated_type := l_type_gen.evaluate_type (a_type, a_written_class)
			l_type_a_checker.init_for_checking (a_feature, a_written_class, void, void)
			l_resolved_type := l_type_a_checker.solved(l_generated_type, void)

			Result := l_resolved_type
		end

	explicit_type_from_type_as (a_type: TYPE_AS; a_written_class: CLASS_C; a_feature: FEATURE_I): TYPE_A
			-- returns the explicit type of `a_type' in `a_context'
		require
			type_non_void: a_type /= void
			context_set: a_written_class /= void and a_feature /= void
		local
			l_written_type: TYPE_A
		do
			l_written_type := written_type_from_type_as(a_type, a_written_class, a_feature)
			Result := l_written_type.actual_type

			if not Result.is_explicit then
				-- recurse
				Result := explicit_type (Result, a_written_class)
			end
		ensure
			is_explicit: Result.is_explicit
			has_associated_class: Result.associated_class /= void
		end

	explicit_type (a_type: TYPE_A; a_written_class: CLASS_C): TYPE_A
			-- returns the explicit type of `a_type' in `a_context'
		require
			type_non_void: a_type /= void
			written_class_non_void: a_written_class /= void
		do
			if a_type.is_formal then
				if attached {FORMAL_A} a_type as l_formal then
					Result :=  l_formal.constraints (a_written_class)

					if attached {TYPE_SET_A}Result as typeset then
						Result := typeset.first

						if typeset.count>1 then
							check
								not_supported: false
							end
						end
					end
				end
			elseif a_type.has_like_current then
				Result := a_written_class.actual_type
			elseif a_type.has_like then
				Result := a_type.actual_type
			else
				Result := a_type
			end

			if Result.has_generics then
				Result := Result.associated_class.constraint_actual_type
			end

			if not Result.is_explicit then
				-- recurse
				Result := explicit_type (Result, a_written_class)
			end
		ensure
			is_explicit: Result.is_explicit
			has_associated_class: Result.associated_class /= void
		end

feature -- Type checking

	check_transformable (a_transformable: ETR_TRANSFORMABLE)
			-- Type check `a_transformable' in its context
			-- Store type in `last_type'.
		require
			non_void: a_transformable /= void
			valid: a_transformable.is_valid
			has_context: not a_transformable.context.is_empty
			correct_factory: parsing_helper.is_using_compiler_factory
		do
			check_ast_type_at(a_transformable.target_node, a_transformable.context, a_transformable.path)
		end

	check_ast_type (an_ast: AST_EIFFEL; a_context: ETR_CONTEXT)
			-- Type check `an_ast' in `a_context'.
			-- Store type in `last_type'.
		require
			non_void: an_ast /= void and a_context /= void
			not_empty: not a_context.is_empty
			correct_factory: parsing_helper.is_using_compiler_factory
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
			correct_factory: parsing_helper.is_using_compiler_factory
		local
			l_ast_string: STRING
			l_feat: FEATURE_I
		do
			-- reparse the ast as expression, so it can be type-checked correctly
			l_ast_string := ast_tools.ast_to_string(an_ast)
			etr_expr_parser.parse_from_string("check "+l_ast_string,void)
			if etr_expr_parser.error_count > 0 then
				etr_error_handler.add_error (Current, "check_ast_type", "Cannot parse an_ast as EXPR_AS")
			else
				init (ast_context)
				ast_context.set_is_ignoring_export (True)
				ast_context.initialize (a_context.class_context.written_class, a_context.class_context.written_class.actual_type, a_context.class_context.written_class.feature_table)

				if attached {ETR_FEATURE_CONTEXT}a_context as l_feat_context then
					l_feat := l_feat_context.written_feature
					init_object_test_locals (l_feat_context, a_path)
				end

				check_expr_type (a_context, etr_expr_parser.expression_node)
			end
		end

feature {NONE} -- Implementation

	init_object_test_locals (a_feature_context: ETR_FEATURE_CONTEXT; a_path: detachable AST_PATH)
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
						l_local_info.set_type (l_cur_local.resolved_type)
						l_local_info.set_is_used (True)
						create l_ot_id.initialize(l_cur_local.name)
						context.add_object_test_local (l_local_info, l_ot_id)
						context.add_object_test_expression_scope (l_ot_id)
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
			l_cur_local: ETR_TYPED_VAR
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
			l_cur_arg: ETR_TYPED_VAR
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
		require
			correct_factory: parsing_helper.is_using_compiler_factory
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
				l_feat := l_feat_context.written_feature
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
				etr_error_handler.add_error (Current, "check_expr_type", "Type checker returned error "+error_handler.error_list.last.generating_type)
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
