note
	description: "Extracts a method"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_METHOD_EXTRACTOR
inherit
	ETR_SHARED
	REFACTORING_HELPER
		export
			{NONE} all
		end
	ETR_ERROR_HANDLER
	SHARED_TEXT_ITEMS
		export
			{NONE} all
		end

feature {NONE} -- Implementation

	extracted_arguments, extracted_results, used_locals, extracted_new_locals, obsolete_locals, changed_arguments: LINKED_LIST[STRING]

	vars_used: ARRAY[LIST[STRING]]
	var_def: ARRAY[HASH_TABLE[PAIR[INTEGER,INTEGER],STRING]]

	context: ETR_FEATURE_CONTEXT

	block_start, block_end: INTEGER

	is_result_possibly_undef: BOOLEAN

	extract_results
			-- find locals that were used after the block and defined within
			-- -> results of the extraced method
		local
			l_cur_var_used: LIST[STRING]
			l_current_instr: like block_start
		do
			from
				create extracted_results.make
				extracted_results.compare_objects
				l_current_instr := block_end+1
			until
				l_current_instr > vars_used.upper
			loop
				from
					l_cur_var_used := vars_used[l_current_instr]
					l_cur_var_used.start
				until
					l_cur_var_used.after
				loop
					if not extracted_results.has (l_cur_var_used.item) and attached (var_def[l_current_instr])[l_cur_var_used.item] as l_pair then
						if l_pair.first >= block_start and l_pair.first <= block_end then
							extracted_results.extend (l_cur_var_used.item)
						elseif l_pair.second >= block_start and l_pair.second <= block_end then
							-- the result has to be an argument too
							-- not sure it's assigned to!
							extracted_results.extend (l_cur_var_used.item)
							is_result_possibly_undef := true
						end
					end

					l_cur_var_used.forth
				end

				l_current_instr := l_current_instr + 1
			end

			-- check if result was defined within extracted block
			if context.has_return_value then
				l_current_instr := vars_used.count
				if attached (var_def[l_current_instr])[ti_result] as l_pair then
					if l_pair.first >= block_start and l_pair.first <= block_end then
						extracted_results.extend(ti_result)
					end
				end
			end
		end

	extract_changed_arguments
			-- find arguments that have to be written to
			-- have to copy them as locals!
		local
			l_current_instr: INTEGER
			l_cur_var: STRING
			l_cur_pos: INTEGER
		do
			-- go over all variable definitions
			-- and see if one inside the block is an argument
			from
				create changed_arguments.make
				changed_arguments.compare_objects
				l_current_instr := block_start
			until
				l_current_instr > block_end
			loop
				from
					var_def[l_current_instr].start
				until
					var_def[l_current_instr].after
				loop
					l_cur_pos := var_def[l_current_instr].item_for_iteration.first
					if l_cur_pos>=block_start and l_cur_pos<=block_end then
						l_cur_var := var_def[l_current_instr].key_for_iteration
						if not changed_arguments.has(l_cur_var) and extracted_arguments.has(l_cur_var) and not l_cur_var.is_equal (ti_result) then
							changed_arguments.extend(var_def[l_current_instr].key_for_iteration)
						end
					end
					var_def[l_current_instr].forth
				end

				l_current_instr := l_current_instr + 1
			end
		end

	extract_arguments
			-- find variables that were used in the block
			--   but their definitions MIGHT have been before
			--   or they were arguments
			-- -> arguments of the extracted method
		local
			l_cur_var_used: LIST[STRING]
			l_current_instr: like block_start
			l_cur_var_def: INTEGER
			l_cur_defs: HASH_TABLE[PAIR[INTEGER,INTEGER],STRING]
		do
			from
				create extracted_arguments.make
				extracted_arguments.compare_objects
				create used_locals.make
				used_locals.compare_objects
				l_current_instr := block_start
			until
				l_current_instr > block_end
			loop
				from
					l_cur_defs := var_def[l_current_instr]
					l_cur_defs.start
				until
					l_cur_defs.after
				loop
					-- if the variable was defined here store it as "used"
					if l_cur_defs.item_for_iteration.first = l_current_instr and not used_locals.has (l_cur_defs.key_for_iteration) then
						used_locals.extend (l_cur_defs.key_for_iteration)
					end

					l_cur_defs.forth
				end

				from
					l_cur_var_used := vars_used[l_current_instr]
					l_cur_var_used.start
				until
					l_cur_var_used.after
				loop
					if not extracted_arguments.has (l_cur_var_used.item) then
						-- all used arguments will be arguments of the new method
						if attached context.arg_by_name[l_cur_var_used.item] then
							extracted_arguments.extend (l_cur_var_used.item)
						else
							if not l_cur_var_used.item.is_equal (ti_result) and not used_locals.has (l_cur_var_used.item) then
								used_locals.extend (l_cur_var_used.item)
							end

							if attached (var_def[l_current_instr])[l_cur_var_used.item] as l_pair then
								l_cur_var_def := l_pair.first

								if l_cur_var_def < block_start  then
								-- if the variable was defined before the block
								-- it's an argument of the extracted method
								extracted_arguments.extend (l_cur_var_used.item)
								end
							end
						end
					end

					l_cur_var_used.forth
				end

				l_current_instr := l_current_instr + 1
			end
		end

	extract_new_locals
			-- find locals that were used in the block
			-- = used locals - extracted arguments - extracted results
		do
			from
				used_locals.start
				create extracted_new_locals.make
				extracted_new_locals.compare_objects
			until
				used_locals.after
			loop
				-- if its not a result and not an argument
				-- we need it as local
				if not extracted_arguments.has (used_locals.item) and not extracted_results.has (used_locals.item) then
					extracted_new_locals.extend (used_locals.item)
				end

				used_locals.forth
			end
		end

	extract_obsolete_locals
			-- find obsolete locals
			-- only used in the extracted block
		local
			l_cur_var_used: LIST[STRING]
			l_current_instr: like block_start
			l_rest_used_locals: like used_locals
			l_index: INTEGER
			l_is_def: BOOLEAN
		do
			-- loop over part of feature that is not extracted
			-- and gather used locals

			from
				l_current_instr := vars_used.lower
				create l_rest_used_locals.make
				l_rest_used_locals.compare_objects
			until
				l_current_instr > vars_used.upper
			loop
				-- skip block
				if l_current_instr=block_start then
					l_current_instr:=block_end
				else
					from
						l_cur_var_used := vars_used[l_current_instr]
						l_cur_var_used.start
					until
						l_cur_var_used.after
					loop
						if not l_rest_used_locals.has (l_cur_var_used.item) then
							l_rest_used_locals.extend (l_cur_var_used.item)
						end

						l_cur_var_used.forth
					end
				end
				l_current_instr := l_current_instr + 1
			end

			-- the results will still be used!
			from
				extracted_results.start
			until
				extracted_results.after
			loop
				if not l_rest_used_locals.has(extracted_results.item) then
					l_rest_used_locals.extend (extracted_results.item)
				end

				extracted_results.forth
			end

			-- compute obsolete locals
			-- basically: all locals - gathered locals
			from
				l_index := context.locals.lower
				create obsolete_locals.make
				obsolete_locals.compare_objects
			until
				l_index > context.locals.upper
			loop
				if not l_rest_used_locals.has (context.locals[l_index].name) then
					l_is_def := false
					-- make sure the local was not defined either
					if attached (var_def[var_def.upper])[context.locals[l_index].name] as l_def then
						-- no definitions after the block
						if l_def.first > block_end or l_def.second > block_end then
							l_is_def := true
						end
					end

					if block_start>1 and then attached (var_def[block_start-1])[context.locals[l_index].name] as l_def then
						-- no definitions before the block
						if l_def.first < block_start or l_def.second < block_start then
							l_is_def := true
						end
					end

					if not l_is_def then
						obsolete_locals.extend (context.locals[l_index].name)
					end
				end

				l_index := l_index + 1
			end
		end

	compute_extracted_method(a_start_path, a_end_path: AST_PATH; a_feature_name: STRING; a_feature_body: EIFFEL_LIST[INSTRUCTION_AS])
			-- puts things together to create the extracted method
		local
			l_feature_output_text: STRING
			l_ex_printer: ETR_EXTRACTED_METHOD_PRINTER
			l_body_output: ETR_AST_STRING_OUTPUT
			l_result_is_arg: BOOLEAN
			l_type_found: BOOLEAN
		do
			create l_feature_output_text.make_empty
			l_feature_output_text.append (a_feature_name)

			if is_result_possibly_undef then
				extracted_arguments.extend(extracted_results.first)
			end

			l_result_is_arg := extracted_arguments.has (ti_result)

			if not extracted_arguments.is_empty then
				-- print arguments
				l_feature_output_text.append (ti_l_parenthesis)
				from
					extracted_arguments.start
				until
					extracted_arguments.after
				loop
					-- get type (local, argument or result)
					-- and print the unresolved version
					if attached {ETR_CONTEXT_TYPED_VAR}context.arg_by_name[extracted_arguments.item] as l_arg then
						l_feature_output_text.append (l_arg.name + ti_colon + ti_space + print_type (l_arg.original_type, context))
					elseif attached {ETR_CONTEXT_TYPED_VAR}context.local_by_name[extracted_arguments.item] as l_arg then
						l_feature_output_text.append (l_arg.name + ti_colon + ti_space + print_type (l_arg.original_type, context))
					elseif extracted_arguments.item.is_equal (ti_result) then
						l_feature_output_text.append ("a_"+ti_result + ti_colon + ti_space + print_type (context.unresolved_type, context))
					else
						-- it might be an object-test local
						from
							context.object_test_locals.start
						until
							context.object_test_locals.after or l_type_found
						loop
							if context.object_test_locals.item.name.is_equal (extracted_arguments.item) then
								if a_start_path.is_child_of (context.object_test_locals.item.scope) then
									l_feature_output_text.append (extracted_arguments.item + ti_colon + ti_space + print_type (context.object_test_locals.item.type, context))
									l_type_found := true
								end
							end

							context.object_test_locals.forth
						end

						if not l_type_found then
							add_error("compute_extracted_method: Can't determine type of "+extracted_arguments.item)
						end

					end

					extracted_arguments.forth

					if not extracted_arguments.after then
						l_feature_output_text.append (ti_semi_colon+ti_space)
					end
				end
				l_feature_output_text.append (ti_r_parenthesis)
			end

			if not extracted_results.is_empty then
				-- add first result, ignore rest
				if extracted_results.count>1 then
					check
						not_supported: false
					end
				end

				-- get type (local)
				-- and print the unresolved version
				if attached {ETR_CONTEXT_TYPED_VAR}context.local_by_name[extracted_results.first] as l_arg then
					l_feature_output_text.append (ti_colon + ti_space + print_type (l_arg.original_type, context))
				elseif extracted_results.first.is_equal (ti_result) then
					l_feature_output_text.append (ti_colon + ti_space + print_type (context.unresolved_type, context))
				end
			end

			l_feature_output_text.append (ti_new_line)

			if not extracted_new_locals.is_empty or not changed_arguments.is_empty then
				l_feature_output_text.append (ti_local_keyword+ti_new_line)
				from
					extracted_new_locals.start
				until
					extracted_new_locals.after
				loop
					if attached {ETR_CONTEXT_TYPED_VAR}context.local_by_name[extracted_new_locals.item] as l_arg then
						l_feature_output_text.append (l_arg.name + ti_colon + ti_space + print_type (l_arg.original_type, context)+ti_new_line)
					end

					extracted_new_locals.forth
				end

				from
					changed_arguments.start
				until
					changed_arguments.after
				loop
					if attached {ETR_CONTEXT_TYPED_VAR}context.local_by_name[changed_arguments.item] as l_arg then
						l_feature_output_text.append ("l_"+l_arg.name + ti_colon + ti_space + print_type (l_arg.original_type, context)+ti_new_line)
					end

					changed_arguments.forth
				end
			end

			l_feature_output_text.append (ti_do_keyword+ti_new_line)
			-- changed arguments, assign to locals
			from
				changed_arguments.start
			until
				changed_arguments.after
			loop
				if extracted_results.has (changed_arguments.item) then
					l_feature_output_text.append (ti_result+ti_assign+changed_arguments.item+ti_new_line)
					changed_arguments.remove
				else
					l_feature_output_text.append ("l_"+changed_arguments.item+ti_assign+changed_arguments.item+ti_new_line)
					changed_arguments.forth
				end
			end

			-- pre-initialized result
			if is_result_possibly_undef or l_result_is_arg then
				if extracted_results.first.is_equal (ti_result) then
					l_feature_output_text.append (ti_result+ti_assign+"a_"+extracted_results.first+ti_new_line)
				else
					l_feature_output_text.append (ti_result+ti_assign+extracted_results.first+ti_new_line)
				end
			end

			-- print only block range
			-- replace result variable by "Result"
			create l_body_output.make
			create l_ex_printer.make (l_body_output, extracted_results, changed_arguments, a_start_path, a_end_path)
			l_ex_printer.print_feature_body(a_feature_body)
			l_feature_output_text.append (l_body_output.string_representation)
			l_feature_output_text.append (ti_end_keyword)

			reparse_printed_ast (context.original_written_feature.e_feature.ast, l_feature_output_text)
			create extracted_method.make_from_ast (reparsed_root, context.class_context, false)
		end

	compute_old_method(a_start_path, a_end_path: AST_PATH; a_extracted_feature_name: STRING; a_feature_ast: FEATURE_AS)
		local
			l_old_method_printer: ETR_OLD_METHOD_PRINTER
			l_feat_output: ETR_AST_STRING_OUTPUT
			l_instr_text: STRING
			l_call_text: STRING
		do
			l_call_text := a_extracted_feature_name
			if not extracted_arguments.is_empty then
				l_call_text.append (ti_l_parenthesis)
				from
					extracted_arguments.start
				until
					extracted_arguments.after
				loop
					l_call_text.append (extracted_arguments.item)

					extracted_arguments.forth

					if not extracted_arguments.after then
						l_call_text.append (ti_comma+ti_space)
					end
				end
				l_call_text.append (ti_r_parenthesis)
			end

			if not extracted_results.is_empty then
				l_instr_text := extracted_results.first + ti_assign + l_call_text
			else
				l_instr_text := l_call_text
			end
			l_instr_text := l_instr_text + ti_new_line

			create l_feat_output.make
			create l_old_method_printer.make (l_feat_output, obsolete_locals, a_start_path, a_end_path, l_instr_text)
			l_old_method_printer.print_feature (a_feature_ast)

			reparse_printed_ast (a_feature_ast, l_feat_output.string_representation)
			create old_method.make_from_ast (reparsed_root, context, false)
		end

feature -- Operations
	extracted_method: ETR_TRANSFORMABLE
			-- extracted method

	old_method: ETR_TRANSFORMABLE
			-- original method with the extracted part replaced by a call to the extracted method

	extract_method(a_feature: ETR_TRANSFORMABLE; a_start_path, a_end_path: AST_PATH; a_feature_name: STRING)
			-- extracts a method with name `a_feature_name' of `a_feature' starting at `a_start_path' and ending at `a_end_path'
		local
			l_use_def_gen: ETR_USE_DEF_CHAIN_GENERATOR
			l_instr_list: EIFFEL_LIST[INSTRUCTION_AS]
			l_feat_ast: FEATURE_AS
		do
			reset_errors
			is_result_possibly_undef := false

			-- check if valid context and valid ast!
			if attached {ETR_FEATURE_CONTEXT}a_feature.context as l_ft_ctxt then
				context := l_ft_ctxt
				if attached {EIFFEL_LIST[INSTRUCTION_AS]}find_node (a_start_path.parent_path, a_start_path.root) as instrs then
					l_instr_list := instrs
				else
					add_error("extract_method: Start path is not an instruction")
				end

				if attached {FEATURE_AS}a_feature.target_node as l_ft then
					l_feat_ast := l_ft
				end

				if not has_errors then
					-- find out what locals are defined/used where
					create l_use_def_gen.make (context)

					l_use_def_gen.generate_chain (a_feature.target_node, a_start_path, a_end_path)

					vars_used := l_use_def_gen.vars_used
					var_def := l_use_def_gen.var_def
					block_start := l_use_def_gen.block_start_position
					block_end := l_use_def_gen.block_end_position

					extract_arguments
					extract_changed_arguments
					extract_results
					extract_new_locals
					extract_obsolete_locals

					compute_extracted_method (a_start_path, a_end_path, a_feature_name, l_instr_list)
					compute_old_method (a_start_path, a_end_path, a_feature_name, l_feat_ast)
				end
			else
				add_error("extract_method: No feature context provided")
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
