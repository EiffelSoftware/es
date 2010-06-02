note
	description: "Helper functions for parsing."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_PARSING_HELPER
inherit
	ETR_SHARED_ERROR_HANDLER
	ETR_SHARED_PARSERS
	ETR_SHARED_LOGGER

feature -- Access

	parsed_ast: detachable AST_EIFFEL
			-- Result of `parse_printed_ast'

	parsed_expr: detachable EXPR_AS
			-- Result of `parse_expr'

	parsed_instruction: INSTRUCTION_AS
			-- Result of `parse_instruction'

	parsed_class: detachable CLASS_AS
			-- Result of `parse_class'

	parsed_instruction_list: detachable EIFFEL_LIST[INSTRUCTION_AS]
			-- Result of `parse_instruction_list'

	parsed_feature: detachable FEATURE_AS
			-- Result of `parse_feature'

	parsed_type: detachable TYPE_AS
			-- Result of `parse_type'		

feature -- Status

	is_using_compiler_factory: BOOLEAN
			-- Are we using a compiler factory to parse?

feature -- Operations

	set_compiler_factory (a_state: BOOLEAN)
			-- Set parsers to use a compiler factory
		do
			is_using_compiler_factory := a_state
		end

	parse_printed_ast (a_root_type: AST_EIFFEL; a_printed_ast: STRING; a_context_class: detachable CLASS_C)
			-- parse an ast of type `a_root_type'
		require
			non_void: a_root_type /= Void and a_printed_ast /= Void
		do
			parsed_ast := Void
			if attached {CLASS_AS}a_root_type then
				parse_class (a_printed_ast)
			elseif attached {FEATURE_AS}a_root_type then
				parse_feature (a_printed_ast, a_context_class)
			elseif attached {INSTRUCTION_AS}a_root_type then
				parse_instruction (a_printed_ast, a_context_class)
			elseif attached {EIFFEL_LIST[INSTRUCTION_AS]}a_root_type then
				parse_instruction_list (a_printed_ast, a_context_class)
			elseif attached {EXPR_AS}a_root_type then
				parse_expr (a_printed_ast, a_context_class)
			elseif attached {TYPE_AS}a_root_type then
				parse_type (a_printed_ast)
			else
				error_handler.add_error (Current, "reparse_printed_ast", "Root of type " + a_root_type.generating_type + " is not supported")
			end
		end

	parse_expr (a_printed_ast: STRING_8; a_context_class: detachable CLASS_C)
			-- Extracted from `parse_printed_ast'
		local
			l_parser: like etr_expr_parser
		do
			parsed_expr := void
			parsed_ast := void
			l_parser := etr_expr_parser
			setup_formal_parameters (l_parser, a_context_class)
			l_parser.set_syntax_version (syntax_version)
			l_parser.parse_from_string ("check " + a_printed_ast, a_context_class)
			if l_parser.error_count > 0 or l_parser.expression_node = void then
				error_handler.add_error (Current, "parse_expr", "Expression parsing failed")
				logger.log_error (a_printed_ast)
			else
				parsed_expr := l_parser.expression_node
				parsed_ast := parsed_expr
			end
		end

	parse_instruction_list (a_printed_ast: STRING_8; a_context_class: detachable CLASS_C)
			-- Extracted from `parse_printed_ast'
		local
			l_parser: like etr_feat_parser
		do
			parsed_instruction_list := void
			parsed_ast := void

			l_parser := etr_feat_parser
			l_parser.set_syntax_version (syntax_version)
			setup_formal_parameters (l_parser, a_context_class)
			l_parser.parse_from_string ("feature new_instr_dummy_feature do " + a_printed_ast + " end", Void)
			if l_parser.error_count > 0 or etr_feat_parser.feature_node = void then
				error_handler.add_error (Current, "parse_instruction_list", "Instruction-list parsing failed")
				logger.log_error (a_printed_ast)
			else
				if attached l_parser.feature_node as fn and then attached {DO_AS}fn.body.as_routine.routine_body as body then
					parsed_instruction_list := body.compound
					parsed_ast := parsed_instruction_list
				end
			end
		end

	parse_instruction (a_printed_ast: STRING_8; a_context_class: detachable CLASS_C)
			-- Extracted from `parse_printed_ast'
		local
			l_parser: like etr_feat_parser
		do
			parsed_instruction := void
			parsed_ast := void

			l_parser := etr_feat_parser
			l_parser.set_syntax_version (syntax_version)
			l_parser.parse_from_string ("feature new_instr_dummy_feature do " + a_printed_ast + " end", a_context_class)
			if l_parser.error_count > 0 or l_parser.feature_node = void then
				error_handler.add_error (Current, "parse_instruction", "Instruction parsing failed")
				logger.log_error (a_printed_ast)
			else
				if attached l_parser.feature_node as fn and then attached {DO_AS}fn.body.as_routine.routine_body as body then
					if body.compound.count>1 then
						error_handler.add_error (Current, "parse_instruction", "Instruction parsing failed")
					else
						parsed_instruction := body.compound.first
						parsed_ast := parsed_instruction
					end
				end
			end
		end

	parse_feature (a_printed_ast: STRING_8; a_context_class: detachable CLASS_C)
			-- Extracted from `parse_printed_ast'
		local
			l_parser: like etr_feat_parser
		do
			parsed_feature := void
			parsed_ast := void

			l_parser := etr_feat_parser
			l_parser.set_syntax_version (syntax_version)
			l_parser.parse_from_string ("feature " + a_printed_ast, Void)
			if l_parser.error_count > 0 or l_parser.feature_node = void then
				error_handler.add_error (Current, "parse_feature", "Feature parsing failed")
				logger.log_error (a_printed_ast)
			else
				parsed_feature := l_parser.feature_node
				parsed_ast := parsed_feature
			end
		end

	parse_class (a_printed_ast: STRING_8)
			-- Extracted from `parse_printed_ast'
		do
			parsed_class := void
			parsed_ast := void

			etr_class_parser.set_syntax_version (syntax_version)
			etr_class_parser.parse_from_string (a_printed_ast, Void)
			if etr_class_parser.error_count > 0 or etr_class_parser.root_node = void then
				error_handler.add_error (Current, "parse_class", "Class parsing failed")
				logger.log_error (a_printed_ast)
			else
				parsed_class := etr_class_parser.root_node
				parsed_ast := parsed_class
			end
		end

	parse_type (a_printed_ast: STRING_8)
			-- Parse `a_printed_ast' as type
		do
			parsed_type := void
			parsed_ast := void

			etr_type_parser.set_syntax_version (syntax_version)
			etr_type_parser.parse_from_string ("dummy "+a_printed_ast, Void)
			if etr_type_parser.error_count > 0 or etr_type_parser.type_node = void then
				error_handler.add_error (Current, "parse_type", "Type parsing failed")
				logger.log_error (a_printed_ast)
			else
				parsed_type := etr_type_parser.type_node
				parsed_ast := parsed_type
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

	etr_compiler_type_parser: EIFFEL_PARSER
			-- internal parser used to handle instructions
		once
			create Result.make_with_factory (new_compiler_factory)
			Result.set_type_parser
			Result.set_syntax_version(syntax_version)
		end

feature {ETR_SHARED_PARSERS} -- Non compiler parsers

	etr_non_compiler_type_parser: EIFFEL_PARSER
			-- internal parser used to handle instructions
		once
			create Result.make_with_factory (new_non_compiler_factory)
			Result.set_type_parser
			Result.set_syntax_version(syntax_version)
		end

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
