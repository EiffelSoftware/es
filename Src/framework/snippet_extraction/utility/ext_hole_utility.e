note
	description: "Common utility to work with holes in AST representation."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_HOLE_UTILITY

inherit
	EPA_UTILITY

feature {NONE} -- Hole Handling (Utiltiy)

	is_hole (a_ast: AST_EIFFEL): BOOLEAN
			-- Checks if `a_ast' is an AST repressentation of an `{EXT_HOLE}'.
		do
			Result := text_from_ast_with_printer (a_ast, hole_utility_ast_printer).starts_with ({EXT_HOLE}.hole_name_prefix)
		end

	get_hole_name (a_ast: AST_EIFFEL): STRING
			-- Returns the hole name of an AST that represents a hole,
			-- by returning the first part before a space and by stripping
			-- away possible new line characters.
		require
			a_ast_is_hole: is_hole (a_ast)
		local
			l_ast_as_text: STRING
		do
			l_ast_as_text := text_from_ast_with_printer (a_ast, hole_utility_ast_printer)
			l_ast_as_text.replace_substring_all ("%N", " ")

			Result := l_ast_as_text.split (' ').at (1)
		end

	get_hole_type (a_ast: AST_EIFFEL; a_context_class: CLASS_C; a_context_feature: FEATURE_I): STRING
			-- Tries to evaluate the corresponding type of the hole.
			-- See `{EXT_HOLE}.hole_type'.
		require
			attached a_ast
		local
			l_epa_ast_expression: EPA_AST_EXPRESSION
		do
				-- If determinable, hole type is set.
			if attached {INSTRUCTION_AS} a_ast then
				Result := "Void"
			elseif attached {EXPR_AS} a_ast as l_expr_ast then
				create l_epa_ast_expression.make_with_text (a_context_class,
															a_context_feature,
															text_from_ast (l_expr_ast),
															a_context_class)
				if attached l_epa_ast_expression.type as l_hole_type then
					Result := l_hole_type.dump
				end
			else
				-- `l_hole_type' remains void.
			end
		end

feature {NONE} -- Printer

	hole_utility_ast_printer: ETR_AST_STRUCTURE_PRINTER
			-- Internal printer.	
		once
			create Result.make_with_output (hole_utility_ast_printer_output)
		end

	hole_utility_ast_printer_output: ETR_AST_STRING_OUTPUT
			-- Internal printer output.
		once
			create Result.make_with_indentation_string ("%T")
		end

end
