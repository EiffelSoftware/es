note
	description: "Shared components of EiffelTransform"
	author: "$Author$"

	date: "$Date$"
	revision: "$Revision$"
class
	ETR_SHARED
inherit
	REFACTORING_HELPER
		export
			{NONE} all
		end
	ETR_ERROR_HANDLER

feature {NONE} -- Typing

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

feature {NONE} -- Constants

	path_initializer: ETR_AST_PATH_INITIALIZER
			-- shared instance of ETR_AST_PATH_INITIALIZER
		once
			create Result
		end

	ast_locator: ETR_AST_LOCATOR
			-- shared instance of ETR_AST_LOCATOR
		once
			create Result
		end

	basic_operators: ETR_BASIC_OPS
			-- shared instance of ETR_BASIC_OPS
		once
			create Result
		end

	syntax_version: NATURAL_8
			-- syntax version used
		once
			Result := {CONF_OPTION}.syntax_index_transitional
		end

feature {NONE} -- Output

	mini_printer: ETR_AST_STRUCTURE_PRINTER
			-- prints small ast fragments to text
		once
			create Result.make_with_output(mini_printer_output)
		end

	mini_printer_output: ETR_AST_STRING_OUTPUT
			-- output used for `mini_printer'
		once
			create Result.make
		end

	ast_to_string(an_ast: AST_EIFFEL): STRING
			-- prints `an_ast' to text using `mini_printer'
		do
			mini_printer_output.reset
			mini_printer.print_ast_to_output(an_ast)

			Result := mini_printer_output.string_representation
		end

feature {NONE} -- Access

	duplicated_ast: detachable AST_EIFFEL
			-- Result of `duplicate_ast'

	reparsed_root: detachable AST_EIFFEL
			-- Result of `reparse_printed_ast'

feature {NONE} -- Parser

	restore_syntax_versions
			-- Restores the syntax versions of the parsers
		do
			-- for some reason they get wiped sometimes ?!?!
			etr_class_parser.set_syntax_version (syntax_version)
			etr_expr_parser.set_syntax_version (syntax_version)
			etr_feat_parser.set_syntax_version (syntax_version)
		end

	etr_class_parser: EIFFEL_PARSER
			-- internal parser used to handle classes
		once
			create Result.make_with_factory (create {AST_ROUNDTRIP_LIGHT_FACTORY})
--			create Result.make_with_factory (create {AST_ROUNDTRIP_COMPILER_LIGHT_FACTORY})
			Result.set_syntax_version (syntax_version)
		end

	etr_expr_parser: EIFFEL_PARSER
			-- internal parser used to handle expressions
		once
			create Result.make_with_factory (create {AST_ROUNDTRIP_LIGHT_FACTORY})
--			create Result.make_with_factory (create {AST_ROUNDTRIP_COMPILER_LIGHT_FACTORY})
			Result.set_expression_parser
			Result.set_syntax_version(syntax_version)
		end

	etr_feat_parser: EIFFEL_PARSER
			-- internal parser used to handle instructions
		once
			create Result.make_with_factory (create {AST_ROUNDTRIP_LIGHT_FACTORY})
--			create Result.make_with_factory (create {AST_ROUNDTRIP_COMPILER_LIGHT_FACTORY})
			Result.set_feature_parser
			Result.set_syntax_version(syntax_version)
		end

	reparse_printed_ast(a_root_type: AST_EIFFEL; a_printed_ast: STRING)
			-- parse an ast of type `a_root_type'
		require
			non_void: a_root_type /= void and a_printed_ast /= void
		do
			reset_errors
			reparsed_root := void

			if attached {CLASS_AS}a_root_type then
				etr_class_parser.set_syntax_version(syntax_version)
				etr_class_parser.parse_from_string (a_printed_ast,void)

				if etr_class_parser.error_count>0 then
					add_error("reparse_printed_ast: Class parsing failed")
				else
					reparsed_root := etr_class_parser.root_node
				end
			elseif attached {FEATURE_AS}a_root_type then
				etr_feat_parser.set_syntax_version(syntax_version)
				etr_feat_parser.parse_from_string ("feature "+a_printed_ast,void)

				if etr_feat_parser.error_count>0 then
					add_error("reparse_printed_ast: Feature parsing failed")
				else
					reparsed_root := etr_feat_parser.feature_node
				end
			elseif attached {INSTRUCTION_AS}a_root_type then
				etr_feat_parser.set_syntax_version(syntax_version)
				etr_feat_parser.parse_from_string ("feature new_instr_dummy_feature do "+a_printed_ast+" end",void)
				if etr_feat_parser.error_count>0 then
					add_error("reparse_printed_ast: Instruction parsing failed")
				else
					if attached etr_feat_parser.feature_node as fn and then attached {DO_AS}fn.body.as_routine.routine_body as body then
						reparsed_root := body.compound.first
					end
				end
			elseif attached {EIFFEL_LIST[INSTRUCTION_AS]}a_root_type then
				etr_feat_parser.set_syntax_version(syntax_version)
				etr_feat_parser.parse_from_string ("feature new_instr_dummy_feature do "+a_printed_ast+" end",void)
				if etr_feat_parser.error_count>0 then
					add_error("reparse_printed_ast: Instruction-list parsing failed")
				else
					if attached etr_feat_parser.feature_node as fn and then attached {DO_AS}fn.body.as_routine.routine_body as body then
						reparsed_root := body.compound
					end
				end
			elseif attached {EXPR_AS}a_root_type then
				etr_expr_parser.set_syntax_version(syntax_version)
				etr_expr_parser.parse_from_string ("check "+a_printed_ast,void)
				if etr_expr_parser.error_count>0 then
					add_error("reparse_printed_ast: Expression parsing failed")
				else
					reparsed_root := etr_expr_parser.expression_node
				end
			else
				add_error("reparse_printed_ast: Root of type "+a_root_type.generating_type+" is not supported")
			end
		end

feature {NONE} -- New

	new_instr(an_instr: STRING; a_context: ETR_CONTEXT): ETR_TRANSFORMABLE
			-- create a new instruction from `an_instr' with context `a_context'
		require
			instr_attached: an_instr /= void
			context_attached: a_context /= void
		do
			reset_errors

			fixme("Command/Query-separation")
			etr_feat_parser.parse_from_string ("feature new_instr_dummy_feature do "+an_instr+" end",void)

			if etr_feat_parser.error_count>0 then
				add_error("new_instr: Parsing failed")
				create Result.make_invalid
			else
				if attached etr_feat_parser.feature_node as fn and then attached {DO_AS}fn.body.as_routine.routine_body as body then
					create Result.make_from_ast (body.compound.first, a_context, false)
				end
			end
		end

	new_expr(an_expr: STRING; a_context: ETR_CONTEXT): ETR_TRANSFORMABLE
			-- create a new exression from `an_expr' with context `a_context'
		require
			expr_attached: an_expr /= void
			context_attached: a_context /= void
		do
			reset_errors

			fixme("Command/Query-separation")
			etr_expr_parser.parse_from_string("check "+an_expr,void)

			if etr_expr_parser.error_count>0 then
				add_error("new_expr: Parsing failed")
				create Result.make_invalid
			else
				create Result.make_from_ast (etr_expr_parser.expression_node, a_context, false)
			end
		end

feature {NONE} -- Operations

	index_ast_from_root(an_ast: AST_EIFFEL)
			-- indexes and ast with root `an_ast'
		require
			non_void: an_ast /= void
		do
			path_initializer.process_from_root(an_ast)
		end

	reindex_ast(an_ast: AST_EIFFEL) is
			-- reindexes `an_ast'
		require
			non_void: an_ast /= void
		do
			path_initializer.process_from(an_ast)
		end

	duplicate_ast(an_ast: AST_EIFFEL)
			-- duplicates `an_ast' and stores the result in `duplicated_ast'
		require
			non_void: an_ast /= void
		do
			-- is cloning the way to go?
			-- alternative would be:
			-- print + reparse (are some ids lost? adjust for context again?)
			-- 		needs facility to print ast without matchlist
			-- recreating from scratch
			--		very dependant on ast structure

			duplicated_ast := an_ast.deep_twin
		end

	single_instr_list(instr: INSTRUCTION_AS): EIFFEL_LIST [like instr]
			-- creates list with a single instruction `instr'
		require
			instr_not_void: instr/=void
		do
			create Result.make (1)
			Result.extend (instr)
		ensure
			one: Result.count = 1
		end

	find_node(a_path: AST_PATH; a_root: AST_EIFFEL): detachable AST_EIFFEL
			-- finds a node from `a_path' and root `a_root'
		require
			non_void: a_path /= void and a_root /= void
			path_non_void: a_root.path /= void
			path_valid: a_path.is_valid and a_root.path.is_valid
		do
			ast_locator.find_from_root (a_path, a_root)

			if ast_locator.found then
				Result := ast_locator.found_node
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
