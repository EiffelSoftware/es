note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	ETR_TEST

inherit
	EQA_TEST_SET
	ETR_SHARED

feature -- Test routines

	printer_test
			-- reads a complex syntax file, prints it out from structure and tries to reparse it
		indexing
			testing:  "EiffelTransform", "covers/{ETR_AST_STRUCTURE_PRINTER}"
		local
			l_class_file: KL_BINARY_INPUT_FILE
			l_class_ast: CLASS_AS
			l_printer: ETR_AST_STRUCTURE_PRINTER
			l_output: ETR_AST_STRING_OUTPUT
			l_parser: EIFFEL_PARSER
			l_library_dir: STRING
			l_env: EXECUTION_ENVIRONMENT
		do
			create l_env
			l_library_dir := l_env.get("EIFFEL_SRC")

			if attached l_library_dir then
				create l_parser.make_with_factory (create {AST_ROUNDTRIP_LIGHT_FACTORY})

				-- setup class to parse
				l_parser.set_syntax_version (syntax_version)

				create l_class_file.make (l_library_dir + "\framework\eiffel_transform\Demo\printer_test.ee")

				l_class_file.open_read
				-- parse the class (no matchlist is generated)
				l_parser.parse (l_class_file)
				l_class_file.close

				l_class_ast := l_parser.root_node

				-- setup printer
				create l_output.make
				create l_printer.make_with_output (l_output)
				l_printer.print_ast_to_output (l_class_ast)

				-- reparse the string representation
				-- somehow the syntax version gets reset when parsing
				l_parser.set_syntax_version (syntax_version)
				l_parser.parse_from_string (l_output.string_representation, void)
				assert("Parsing failed", l_parser.error_count = 0)
			else
				assert ("$EIFFEL_SRC not set", false)
			end
		end

	test_ast_modification_invalid
			-- does some invalid ast modifications
		indexing
			testing:  "EiffelTransform", "covers/{ETR_BASIC_OPS}"
		local
			context: ETR_CONTEXT
		do
			create context.make_empty

			basic_operators.generate_conditional (new_expr ("b>a",context), new_instr ("a:=a-b",context), new_expr ("b>a",context), context)
			assert("Error 1 not caught", basic_operators.has_errors)

			basic_operators.generate_conditional (new_instr ("a:=a-b",context), new_instr ("a:=a-b",context), new_instr ("a:=a-b",context), context)
			assert("Error 2 not caught", basic_operators.has_errors)

			basic_operators.generate_conditional (new_expr ("b>a",context), new_instr ("a:=a-b",context), new_instr ("a:=a-b",context), context)
			assert("Invalid error or error not reset", not basic_operators.has_errors)
		end

	test_ast_modification_valid
			-- does some valid ast modifications
		indexing
			testing:  "EiffelTransform", "covers/{ETR_AST_MODIFIER}", "covers/{ETR_AST_STRUCTURE_PRINTER}", "covers/{ETR_BASIC_OPS}"
		local
			context: ETR_CONTEXT
			mod1,mod2: ETR_AST_MODIFICATION
			modifier: ETR_AST_MODIFIER
			conditional: ETR_TRANSFORMABLE
		do
			-- preparation
			create context.make_empty
			create modifier.make

			-- create conditional
			basic_operators.generate_conditional (new_expr ("b>a",context), new_instr ("a:=a-b",context), void, context)
			conditional := basic_operators.transformation_result

			-- the else-part
			mod1 := basic_operators.list_append(create {AST_PATH}.make_from_parent(conditional.target_node, 4), new_instr ("b:=b-a",context))
			-- the condition
			mod2 := basic_operators.replace (create {AST_PATH}.make_from_parent(conditional.target_node, 1), new_expr ("a>b",context))
			modifier.add(mod1); modifier.add (mod2)
			modifier.apply_to (conditional)

			-- change operator to >=
			mod1 := basic_operators.replace_with_string (create {AST_PATH}.make_from_string(modifier.modified_ast.target_node, "1.1.2"), ">=")
			modifier.add (mod1)
			modifier.apply_to (modifier.modified_ast)

			-- reference
			reparse_printed_ast (modifier.modified_ast.target_node,
			"if a >= b then %N"+
				"a := a - b %N"+
			"else %N"+
				"b := b - a %N"+
			"end")

			assert("Invalid result", are_asts_equal(reparsed_root, modifier.modified_ast.target_node))
		end

feature {NONE} -- Helpers

	are_asts_equal(an_ast, another_ast: AST_EIFFEL): BOOLEAN
			-- compare asts by printing and comparing strings
		local
			l_ast1_str, l_ast2_str: STRING
		do
			l_ast1_str := ast_to_string (an_ast)
			l_ast2_str := ast_to_string (another_ast)

			Result := l_ast1_str.is_equal (l_ast2_str)
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


