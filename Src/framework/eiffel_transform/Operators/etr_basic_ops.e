note
	description: "Basic mutation operators"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_BASIC_OPS
inherit
	ETR_SHARED
		export
			{NONE} all
		end

	REFACTORING_HELPER
		export
			{NONE} all
		end
	COMPILER_EXPORTER
	ETR_ERROR_HANDLER


feature {NONE} -- Implementation

	end_keyword: KEYWORD_AS is
			-- simple end keyword with no location or text information
		once
			create Result.make_null
			Result.set_code ({EIFFEL_TOKENS}.te_end)
		ensure
			Result.is_end_keyword
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
			source_feature,target_feature: E_FEATURE
			source_class,target_class: CLASS_C
			source_written_in_features: LIST[E_FEATURE]
			cur_feat: E_FEATURE
			changed_feature_types: LINKED_LIST[ETR_CT_CHANGED_FEATURE]
			changed_arguments: LINKED_LIST[ETR_CT_CHANGED_ARGUMENT]
			source_arg, target_arg: TYPE_A

			l_transformer: ETR_CONTEXT_TRANSFORMER
			l_output: ETR_AST_STRING_OUTPUT
			l_old_name, l_new_name: STRING
			l_old_type, l_new_type: CLASS_C
			l_index: INTEGER
			l_arg_changed_type,l_arg_changed_name: BOOLEAN
		do
			reset_errors

			if not a_transformable.context.is_empty and not a_target_context.is_empty then
				source_class := a_transformable.context.written_class
				target_class := a_target_context.written_class

				-- class to class transformation
				fixme("May not consider generic features or inline agents")

				-- loop through features that were written in the source class
				-- for features with return value:
				-- check if there is a corresponding feature in the target class
				from
					source_written_in_features := source_class.written_in_features
					source_written_in_features.start
					create changed_feature_types.make
				until
					source_written_in_features.after
				loop
					cur_feat := source_written_in_features.item
					if cur_feat.has_return_value and attached target_class.feature_of_feature_id (cur_feat.feature_id) as new_feat then
						-- matching feature id's
						-- check if type matches
						if attached {CL_TYPE_A}cur_feat.type as old_type and attached {CL_TYPE_A}new_feat.type as new_type then
							-- we only care for class ids, attachment-marks etc don't change naming
							if old_type.class_id /= new_type.class_id then
								-- store for checking
								changed_feature_types.extend (create {ETR_CT_CHANGED_FEATURE}.make(cur_feat.name, old_type.associated_class, new_type.associated_class))
							end
						end
					end

					source_written_in_features.forth
				end

				if a_target_context.is_feature and a_transformable.context.is_feature then
					-- feature to feature transformation

					source_feature := a_transformable.context.written_feature
					target_feature := a_target_context.written_feature

					-- check for renamed arguments and changed types
					from
						source_feature.arguments.start
						create changed_arguments.make
					until
						source_feature.arguments.after
					loop
						-- match arguments by position
						source_arg := source_feature.arguments.item

						target_arg := void

						l_index := source_feature.arguments.index

						if target_feature.argument_count >= l_index then
							target_arg := target_feature.arguments.i_th (l_index)
						end

						fixme("How do we decide if a conversion even makes sense? Just let compilation fail?")

						if attached target_arg then
							l_arg_changed_name := false
							l_arg_changed_type := false

							-- check for changed type
							if source_arg.associated_class.class_id /= target_arg.associated_class.class_id then
								l_old_type := source_arg.associated_class
								l_new_type := target_arg.associated_class

								l_arg_changed_type := true
							end

							-- check for changed name
							l_old_name := source_feature.argument_names.i_th (l_index)
							l_new_name := target_feature.argument_names.i_th (l_index)

							if not l_old_name.is_equal (l_new_name) then
								l_arg_changed_name := true
							end

							if l_arg_changed_type and l_arg_changed_name then
								changed_arguments.extend (create {ETR_CT_CHANGED_ARGUMENT}.make_changed_name_type(l_old_name, l_new_name, l_old_type, l_new_type))
							elseif l_arg_changed_type then
								changed_arguments.extend (create {ETR_CT_CHANGED_ARGUMENT}.make_changed_type(l_old_name, l_old_type, l_new_type))
							elseif l_arg_changed_name then
								changed_arguments.extend (create {ETR_CT_CHANGED_ARGUMENT}.make_changed_name(l_old_name, l_new_name))
							end
						end

						source_feature.arguments.forth
					end
				end

				-- now visit the ETR_TRANSFORMABLE
				-- and perform replacements
				create l_output.make
				create l_transformer.make(l_output, changed_feature_types, changed_arguments)
				-- print the ast to output
				l_transformer.print_ast_to_output (a_transformable.target_node)
				-- reparse it
				reparse_printed_ast (a_transformable.target_node, l_output.string_representation)

				if attached reparsed_root then
					create transformation_result.make_from_ast(reparsed_root, a_target_context, false)
				end
			end
		end

	generate_conditional(a_test: ETR_TRANSFORMABLE; if_part, else_part: detachable ETR_TRANSFORMABLE; a_context: ETR_CONTEXT) is
			-- create node corresponding to if `a_test' then `if_part' else `else_part' end with `a_context'
		require
			test_not_void: a_test /= void
			context_not_void: a_context /= void
			a_test_valid: a_test.is_valid
			if_part_valid: attached if_part implies if_part.is_valid
			else_part_valid: attached else_part implies else_part.is_valid
		local
			l_if_part_node, l_else_part_node: EIFFEL_LIST[INSTRUCTION_AS]
			l_result_node: IF_AS
			l_if_part_dup: like if_part
			l_else_part_dup: like else_part
		do
			reset_errors

			if attached {EXPR_AS}a_test.target_node as condition then
				if attached if_part then
					duplicate_ast (if_part.target_node)
					-- check if its a single instruction or multiple
					if attached {INSTRUCTION_AS}duplicated_ast as instr then
						l_if_part_node := single_instr_list (instr)
					elseif attached {EIFFEL_LIST[INSTRUCTION_AS]}duplicated_ast as instrs then
						l_if_part_node := instrs
					else
						set_error("generate_conditional: contained ast of if_part is of incompatible type ("+if_part.target_node.generating_type+")")
					end
				end

				if attached else_part then
					duplicate_ast (else_part.target_node)
					-- check if its a single instruction or multiple
					if attached {INSTRUCTION_AS}duplicated_ast as instr then
						l_else_part_node := single_instr_list (instr)
					elseif attached {EIFFEL_LIST[INSTRUCTION_AS]}duplicated_ast as instrs then
						l_else_part_node := instrs
					else
						set_error("generate_conditional: contained ast of else_part is of incompatible type ("+else_part.target_node.generating_type+")")
					end
				end

				if not has_errors then
					-- assemble new IF_AS and transformable
					create l_result_node.initialize (condition, l_if_part_node, void, l_else_part_node, end_keyword, void, void, void)
					create transformation_result.make_from_ast (l_result_node, a_context, false)
				end
			else
				set_error("generate_conditional: contained ast of a_test is not of type EXPR_AS (but  "+a_test.target_node.generating_type+")")
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
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
