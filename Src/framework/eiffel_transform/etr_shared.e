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

feature -- Constants

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

feature -- Output

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

feature -- Access

	duplicated_ast: detachable AST_EIFFEL
			-- Result of `duplicate_ast'

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

feature -- Parser

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

	etr_instr_parser: EIFFEL_PARSER
			-- internal parser used to handle instructions
		once
			create Result.make_with_factory (create {AST_ROUNDTRIP_LIGHT_FACTORY})
--			create Result.make_with_factory (create {AST_ROUNDTRIP_COMPILER_LIGHT_FACTORY})
			Result.set_feature_parser
			Result.set_syntax_version(syntax_version)
		end

	reparsed_root: AST_EIFFEL

	reparse_printed_ast(a_root_type: AST_EIFFEL; a_printed_ast: STRING)
			-- parse an ast of type `a_root_type'
		require
			non_void: a_root_type /= void and a_printed_ast /= void
		do
			reset_errors
			reparsed_root := void
			if attached {CLASS_AS}a_root_type then
				etr_class_parser.parse_from_string (a_printed_ast,void)

				if etr_class_parser.error_count>0 then
					set_error("reparse_printed_ast: Class parsing failed")
				else
					reparsed_root := etr_class_parser.root_node
				end
			elseif attached {INSTRUCTION_AS}a_root_type then
				etr_instr_parser.parse_from_string ("feature new_instr_dummy_feature do "+a_printed_ast+" end",void)
				if etr_instr_parser.error_count>0 then
					set_error("reparse_printed_ast: Instruction parsing failed")
				else
					if attached etr_instr_parser.feature_node as fn and then attached {DO_AS}fn.body.as_routine.routine_body as body then
						reparsed_root := body.compound.first
					end
				end
			elseif attached {EXPR_AS}a_root_type then
				etr_expr_parser.parse_from_string (a_printed_ast,void)
				if etr_expr_parser.error_count>0 then
					set_error("reparse_printed_ast: Expression parsing failed")
				else
					reparsed_root := etr_expr_parser.expression_node
				end
			else
				set_error("reparse_printed_ast: Root of type "+a_root_type.generating_type+" is not supported")
			end
		end

feature -- New

	new_instr(an_instr: STRING; a_context: ETR_CONTEXT): ETR_TRANSFORMABLE
			-- create a new instruction from `an_instr' with context `a_context'
		require
			instr_attached: an_instr /= void
			context_attached: a_context /= void
		do
			reset_errors

			fixme("Command/Query-separation")
			etr_instr_parser.parse_from_string ("feature new_instr_dummy_feature do "+an_instr+" end",void)

			if etr_instr_parser.error_count>0 then
				set_error("new_instr: Parsing failed")
				create Result.make_invalid
			else
				if attached etr_instr_parser.feature_node as fn and then attached {DO_AS}fn.body.as_routine.routine_body as body then
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
			fixme("Command/Query-separation")
			etr_expr_parser.parse_from_string("check "+an_expr,void)

			if etr_expr_parser.error_count>0 then
				set_error("new_expr: Parsing failed")
				create Result.make_invalid
			else
				create Result.make_from_ast (etr_expr_parser.expression_node, a_context, false)
			end
		end

feature -- Operations

	parent_path(a_path: AST_PATH): AST_PATH
			-- constructs the path of `a_path's parent
		require
			non_void: a_path /= void
			path_valid: a_path.is_valid
			not_root: a_path.as_array.count>1
		local
			l_parent_string: STRING
			i: INTEGER
		do
			-- construct path of parent
			from
				i := a_path.as_array.lower
				create l_parent_string.make_empty
			until
				i > a_path.as_array.upper-1
			loop
				if i /= a_path.as_array.upper-1 then
					l_parent_string := l_parent_string + a_path.as_array[i].out + {AST_PATH}.separator.out
				else
					l_parent_string := l_parent_string + a_path.as_array[i].out
				end
				i := i+1
			end

			create Result.make_from_string (a_path.root, l_parent_string)
		ensure
			Result.is_valid
		end

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
