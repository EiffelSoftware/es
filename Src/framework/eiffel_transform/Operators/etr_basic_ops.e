note
	description: "Basic mutation operators"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_BASIC_OPS
inherit
	ETR_SHARED
	REFACTORING_HELPER
		export
			{NONE} all
		end
	COMPILER_EXPORTER
	SHARED_NAMES_HEAP
		export
			{NONE} all
		end
	ETR_ERROR_HANDLER

feature {NONE} -- Implementation

	end_keyword: KEYWORD_AS
			-- simple end keyword with no location or text information
		once
			create Result.make_null
			Result.set_code ({EIFFEL_TOKENS}.te_end)
		ensure
			Result.is_end_keyword
		end

	extract_renamings(a_feature_name: STRING; a_source_type, a_target_type: TYPE_A): detachable ETR_CT_RENAMED_CONSTRAINT_FEATURES
			-- extracts renamings of `a_source_type' and `a_target_type'
		require
			non_void: a_feature_name /= void and a_source_type /= void and a_target_type /= void
		local
			l_source_renaming, l_target_renaming: RENAMING_A
		do
			if attached {RENAMED_TYPE_A[TYPE_A]}a_source_type as l_ren then
				l_source_renaming := l_ren.renaming
			end
			if attached {RENAMED_TYPE_A[TYPE_A]}a_target_type as l_ren then
				l_target_renaming := l_ren.renaming
			end

			if l_source_renaming /= void or l_target_renaming /= void then
				create Result.make(a_feature_name, l_source_renaming, l_target_renaming)
			end
		end

	check_renamed_name_or_type(an_old_var, a_new_var: ETR_CONTEXT_TYPED_VAR): ETR_CT_CHANGED_ARG_LOCAL
				-- checks for changed name or type of local/arg
		local
			l_changed_type, l_changed_name: BOOLEAN
		do
			-- check for changed type
			if an_old_var.resolved_type.associated_class.class_id /= a_new_var.resolved_type.associated_class.class_id then
				l_changed_type := true
			end

			-- check for changed name
			if not a_new_var.name.is_equal (an_old_var.name) then
				l_changed_name := true
			end

			if l_changed_type and l_changed_name then
				create Result.make_changed_name_type(an_old_var.name, a_new_var.name, an_old_var.resolved_type.associated_class, a_new_var.resolved_type.associated_class)
			elseif l_changed_type then
				create Result.make_changed_type(an_old_var.name, an_old_var.resolved_type.associated_class, a_new_var.resolved_type.associated_class)
			elseif l_changed_name then
				create Result.make_changed_name(an_old_var.name, a_new_var.name)
			end
		end


feature -- Transformations

	transformation_result: ETR_TRANSFORMABLE
			-- result of last transformation

	transform_to_context(a_transformable: ETR_TRANSFORMABLE; a_target_context: ETR_CONTEXT)
			-- transform `a_transformable' into `a_target_context'
		require
			non_void: a_transformable /= void and a_target_context /= void
			valid_transformable: a_transformable.is_valid
		local
			l_source_context: ETR_CONTEXT
			l_changed_feature_types: LINKED_LIST[ETR_CT_CHANGED_FEATURE]
			l_changed_args_locals: LINKED_LIST[ETR_CT_CHANGED_ARG_LOCAL]
			l_constraint_renaming_list: LINKED_LIST[ETR_CT_RENAMED_CONSTRAINT_FEATURES]
			l_constraint_renaming: ETR_CT_RENAMED_CONSTRAINT_FEATURES
			l_changed_var: ETR_CT_CHANGED_ARG_LOCAL
			l_old_feat: ETR_FEATURE_CONTEXT
			l_cur_old_arg, l_cur_new_arg: ETR_CONTEXT_TYPED_VAR
			l_cur_old_local, l_cur_new_local: ETR_CONTEXT_TYPED_VAR
			l_index: INTEGER
			l_transformer: ETR_CONTEXT_TRANSFORMER
			l_output: ETR_AST_STRING_OUTPUT

			l_source_class_context, l_target_class_context: ETR_CLASS_CONTEXT
		do
			reset_errors
			transformation_result := void

			l_source_context := a_transformable.context

			if not l_source_context.is_empty and not a_target_context.is_empty then
				l_source_class_context := l_source_context.class_context
				l_target_class_context := a_target_context.class_context

				create l_changed_args_locals.make
				create l_changed_feature_types.make
				create l_constraint_renaming_list.make

				-- class to class transformation
				-- loop through features that were written in the source class
				-- for features with return value:
				-- check if there is a corresponding feature in the target class
				from
					l_source_class_context.written_in_features.start
				until
					l_source_class_context.written_in_features.after
				loop
					l_old_feat := l_source_class_context.written_in_features.item

					-- try to find matching feature
					-- fixme: add fun: matching_feature
					if l_old_feat.has_return_value and attached l_target_class_context.feature_of_id (l_old_feat.feature_id) as l_new_feat then
						-- check if type matches
						if l_old_feat.type.associated_class.class_id /= l_new_feat.type.associated_class.class_id then
							l_changed_feature_types.extend (create {ETR_CT_CHANGED_FEATURE}.make(l_old_feat.name, l_old_feat.type.associated_class, l_new_feat.type.associated_class))
						end

						l_constraint_renaming := extract_renamings (l_old_feat.name, l_old_feat.type, l_new_feat.type)
						if attached l_constraint_renaming then
							l_constraint_renaming_list.extend (l_constraint_renaming)
						end
					end

					l_source_class_context.written_in_features.forth
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

							l_changed_var := check_renamed_name_or_type(l_cur_old_arg, l_cur_new_arg)
							if attached l_changed_var then
								l_changed_args_locals.extend (l_changed_var)
							end

							l_constraint_renaming := extract_renamings (l_cur_old_arg.name, l_cur_old_arg.resolved_type, l_cur_new_arg.resolved_type)
							if attached l_constraint_renaming then
								l_constraint_renaming_list.extend (l_constraint_renaming)
							end

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

							l_changed_var := check_renamed_name_or_type(l_cur_old_local, l_cur_new_local)
							if attached l_changed_var then
								l_changed_args_locals.extend (l_changed_var)
							end

							l_constraint_renaming := extract_renamings (l_cur_old_local.name, l_cur_old_local.resolved_type, l_cur_new_local.resolved_type)
							if attached l_constraint_renaming then
								l_constraint_renaming_list.extend (l_constraint_renaming)
							end

							l_index := l_index + 1
						end
					end
				end
			end

			-- now visit the ETR_TRANSFORMABLE
			-- and perform replacements
			create l_output.make
			create l_transformer.make(l_output, l_changed_feature_types, l_changed_args_locals, l_constraint_renaming_list)
			-- print the ast to output
			l_transformer.print_ast_to_output (a_transformable.target_node)
			-- reparse it
			reparse_printed_ast (a_transformable.target_node, l_output.string_representation)

			if attached reparsed_root then
				create transformation_result.make_from_ast(reparsed_root, a_target_context, false)
			else
				add_error("transform_to_context: Failed to reparse result of transformation")
				create transformation_result.make_invalid
			end
		end

	generate_conditional(a_test: ETR_TRANSFORMABLE; if_part, else_part: detachable ETR_TRANSFORMABLE; a_context: ETR_CONTEXT)
			-- create node corresponding to if `a_test' then `if_part' else `else_part' in a `a_context'
		require
			test_not_void: a_test /= void
			context_not_void: a_context /= void
			a_test_valid: a_test.is_valid
			if_part_valid: attached if_part implies if_part.is_valid
			else_part_valid: attached else_part implies else_part.is_valid
		local
			l_if_part_node, l_else_part_node: EIFFEL_LIST[INSTRUCTION_AS]
			l_result_node: IF_AS
			l_test_node: EXPR_AS
		do
			reset_errors
			transformation_result := void

			if attached {EXPR_AS}a_test.target_node as condition then
				if attached if_part then
					-- check if its a single instruction or multiple
					if attached {INSTRUCTION_AS}if_part.target_node as instr then
						l_if_part_node := single_instr_list (instr)
					elseif attached {EIFFEL_LIST[INSTRUCTION_AS]}if_part.target_node as instrs then
						l_if_part_node := instrs
					else
						add_error("generate_conditional: contained ast of if_part is of incompatible type ("+if_part.target_node.generating_type+")")
					end
				end

				if attached else_part then
					-- check if its a single instruction or multiple
					if attached {INSTRUCTION_AS}else_part.target_node as instr then
						l_else_part_node := single_instr_list (instr)
					elseif attached {EIFFEL_LIST[INSTRUCTION_AS]}else_part.target_node as instrs then
						l_else_part_node := instrs
					else
						add_error("generate_conditional: contained ast of else_part is of incompatible type ("+else_part.target_node.generating_type+")")
					end
				end

				if not has_errors then
					-- Transform all parts to a_context
					if attached if_part then
						transform_to_context (if_part, a_context)
						if attached {EIFFEL_LIST[INSTRUCTION_AS]}transformation_result.target_node as l_if_part then
							l_if_part_node := l_if_part
						end
					end

					if attached else_part then
						transform_to_context (else_part, a_context)
						if attached {EIFFEL_LIST[INSTRUCTION_AS]}transformation_result.target_node as l_else_part then
							l_else_part_node := l_else_part
						end
					end

					transform_to_context (a_test, a_context)
					if attached {EXPR_AS}transformation_result.target_node as l_test then
						l_test_node := l_test
					end

					-- assemble new IF_AS and transformable
					create l_result_node.initialize (l_test_node, l_if_part_node, void, l_else_part_node, end_keyword, void, void, void)
					create transformation_result.make_from_ast (l_result_node, a_context, false)
				end
			else
				add_error("generate_conditional: contained ast of a_test is not of type EXPR_AS (but  "+a_test.target_node.generating_type+")")
			end
		end

feature -- Modifications (path-reference)

	insert_after(a_reference: AST_PATH; a_new_trans: ETR_TRANSFORMABLE): ETR_AST_MODIFICATION
			-- Insert `a_new_trans' after `a_reference'
		require
			non_void: a_reference /= void and a_new_trans /= void
		do
			create Result.make_insert_after (a_reference, a_new_trans)
		end

	insert_before(a_reference: AST_PATH; a_new_trans: ETR_TRANSFORMABLE): ETR_AST_MODIFICATION
			-- Insert `a_new_trans' before `a_reference'
		require
			non_void: a_reference /= void and a_new_trans /= void
		do
			create Result.make_insert_before (a_reference, a_new_trans)
		end

	delete(a_reference: AST_PATH): ETR_AST_MODIFICATION
			-- Delete `a_reference'
		require
			non_void: a_reference /= void
		do
			create Result.make_delete (a_reference)
		end

	replace(a_reference: AST_PATH; a_replacement: ETR_TRANSFORMABLE): ETR_AST_MODIFICATION
				-- Replace `a_reference' by `a_replacement'
		require
			non_void: a_reference /= void and a_replacement /= void
		do
			create Result.make_replace (a_reference, ast_to_string(a_replacement.target_node))
		end

	replace_with_string(a_reference: AST_PATH; a_replacement: STRING): ETR_AST_MODIFICATION
				-- Replace `a_reference' by `a_replacement'
		require
			non_void: a_reference /= void and a_replacement /= void
		do
			create Result.make_replace (a_reference, a_replacement)
		end

	list_prepend(a_list: AST_PATH; a_replacement: ETR_TRANSFORMABLE): ETR_AST_MODIFICATION
				-- Append `a_replacement' to `a_list'
		require
			non_void: a_list /= void and a_replacement /= void
		do
			create Result.make_list_prepend (a_list, a_replacement)
		end

	list_append(a_list: AST_PATH; a_replacement: ETR_TRANSFORMABLE): ETR_AST_MODIFICATION
				-- Prepend `a_replacement' to `a_list'
		require
			non_void: a_list /= void and a_replacement /= void
		do
			create Result.make_list_append (a_list, a_replacement)
		end

	list_put_ith(a_list: AST_PATH; a_position: INTEGER; a_replacement: ETR_TRANSFORMABLE): ETR_AST_MODIFICATION
				-- Replace item at position `a_position' in `a_list' by `a_replacement'
		require
			non_void: a_list /= void and a_replacement /= void
		do
			create Result.make_list_put_ith (a_list, a_position, a_replacement)
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
