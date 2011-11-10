note
	description: "Common utility to work with holes in AST representation."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_HOLE_UTILITY

inherit
	EPA_UTILITY

feature -- Hole Handling (Utiltiy)

	is_hole (a_ast: AST_EIFFEL): BOOLEAN
			-- Checks if `a_ast' is an AST repressentation of an `{EXT_HOLE}'.
		local
			l_ast_printer: ETR_AST_STRUCTURE_PRINTER
			l_ast_printer_output: ETR_AST_STRING_OUTPUT
		do
			create l_ast_printer_output.make_with_indentation_string ("%T")
			create l_ast_printer.make_with_output (l_ast_printer_output)

			Result := text_from_ast_with_printer (a_ast, l_ast_printer).starts_with ({EXT_HOLE}.hole_name_prefix)
		end

	get_hole_name (a_ast: AST_EIFFEL): STRING
			-- Returns the hole name of an AST that represents a hole,
			-- by returning the first part before a space and by stripping
			-- away possible new line characters.
		require
			a_ast_is_hole: is_hole (a_ast)
		local
			l_ast_as_text: STRING
			l_ast_printer: ETR_AST_STRUCTURE_PRINTER
			l_ast_printer_output: ETR_AST_STRING_OUTPUT
		do
			create l_ast_printer_output.make_with_indentation_string ("%T")
			create l_ast_printer.make_with_output (l_ast_printer_output)

			l_ast_as_text := text_from_ast_with_printer (a_ast, l_ast_printer)
			l_ast_as_text.replace_substring_all ("%N", " ")

			Result := l_ast_as_text.split (' ').at (1)
		end

end
