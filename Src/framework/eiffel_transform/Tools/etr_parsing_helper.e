note
	description: "Helper functions for parsing"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_PARSING_HELPER
inherit
	ETR_SHARED_ERROR_HANDLER
	ETR_SHARED_PARSERS

feature -- Access

	reparsed_root: detachable AST_EIFFEL
			-- Result of `reparse_printed_ast'

	is_using_compiler_factory: BOOLEAN
			-- Are we using a compiler factory to parse?

feature -- Operations

	set_compiler_factory(a_state: BOOLEAN)
			-- Set parsers to use a compiler factory
		do
			is_using_compiler_factory := a_state
		end

	reparse_printed_ast(a_root_type: AST_EIFFEL; a_printed_ast: STRING)
			-- parse an ast of type `a_root_type'
		require
			non_void: a_root_type /= void and a_printed_ast /= void
		do
			reparsed_root := void

			if attached {CLASS_AS}a_root_type then
				etr_class_parser.set_syntax_version(syntax_version)
				etr_class_parser.parse_from_string (a_printed_ast,void)

				if etr_class_parser.error_count>0 then
					error_handler.add_error (Current, "reparse_printed_ast", "Class parsing failed")
				else
					reparsed_root := etr_class_parser.root_node
				end
			elseif attached {FEATURE_AS}a_root_type then
				etr_feat_parser.set_syntax_version(syntax_version)
				etr_feat_parser.parse_from_string ("feature "+a_printed_ast,void)

				if etr_feat_parser.error_count>0 then
					error_handler.add_error (Current, "reparse_printed_ast", "Feature parsing failed")
				else
					reparsed_root := etr_feat_parser.feature_node
				end
			elseif attached {INSTRUCTION_AS}a_root_type then
				etr_feat_parser.set_syntax_version(syntax_version)
				etr_feat_parser.parse_from_string ("feature new_instr_dummy_feature do "+a_printed_ast+" end",void)
				if etr_feat_parser.error_count>0 then
					error_handler.add_error (Current, "reparse_printed_ast", "Instruction parsing failed")
				else
					if attached etr_feat_parser.feature_node as fn and then attached {DO_AS}fn.body.as_routine.routine_body as body then
						reparsed_root := body.compound.first
					end
				end
			elseif attached {EIFFEL_LIST[INSTRUCTION_AS]}a_root_type then
				etr_feat_parser.set_syntax_version(syntax_version)
				etr_feat_parser.parse_from_string ("feature new_instr_dummy_feature do "+a_printed_ast+" end",void)
				if etr_feat_parser.error_count>0 then
					error_handler.add_error (Current, "reparse_printed_ast", "Instruction-list parsing failed")
				else
					if attached etr_feat_parser.feature_node as fn and then attached {DO_AS}fn.body.as_routine.routine_body as body then
						reparsed_root := body.compound
					end
				end
			elseif attached {EXPR_AS}a_root_type then
				etr_expr_parser.set_syntax_version(syntax_version)
				etr_expr_parser.parse_from_string ("check "+a_printed_ast,void)
				if etr_expr_parser.error_count>0 then
					error_handler.add_error (Current, "reparse_printed_ast", "Expression parsing failed")
				else
					reparsed_root := etr_expr_parser.expression_node
				end
			else
				error_handler.add_error (Current, "reparse_printed_ast", "Root of type "+a_root_type.generating_type+" is not supported")
			end
		end

feature {ETR_SHARED_PARSERS} -- Compiler parsers

	etr_compiler_class_parser: EIFFEL_PARSER
			-- internal parser used to handle classes
		once
			create Result.make_with_factory (new_compiler_factory)
			Result.set_syntax_version (syntax_version)
		end

	etr_compiler_expr_parser: EIFFEL_PARSER
			-- internal parser used to handle expressions
		once
			create Result.make_with_factory (new_compiler_factory)
			Result.set_expression_parser
			Result.set_syntax_version(syntax_version)
		end

	etr_compiler_feat_parser: EIFFEL_PARSER
			-- internal parser used to handle instructions
		once
			create Result.make_with_factory (new_compiler_factory)
			Result.set_feature_parser
			Result.set_syntax_version(syntax_version)
		end

feature {ETR_SHARED_PARSERS} -- Non compiler parsers

	etr_non_compiler_class_parser: EIFFEL_PARSER
			-- internal parser used to handle classes
		once
			create Result.make_with_factory (new_non_compiler_factory)
			Result.set_syntax_version (syntax_version)
		end

	etr_non_compiler_expr_parser: EIFFEL_PARSER
			-- internal parser used to handle expressions
		once
			create Result.make_with_factory (new_non_compiler_factory)
			Result.set_expression_parser
			Result.set_syntax_version(syntax_version)
		end

	etr_non_compiler_feat_parser: EIFFEL_PARSER
			-- internal parser used to handle instructions
		once
			create Result.make_with_factory (new_non_compiler_factory)
			Result.set_feature_parser
			Result.set_syntax_version(syntax_version)
		end

feature {NONE} -- Factories

	new_compiler_factory: AST_FACTORY
			-- new ast factory
		do
			create {AST_ROUNDTRIP_COMPILER_LIGHT_FACTORY}Result
		end

	new_non_compiler_factory: AST_FACTORY
			-- new ast factory
		do
			create {AST_ROUNDTRIP_LIGHT_FACTORY}Result
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
