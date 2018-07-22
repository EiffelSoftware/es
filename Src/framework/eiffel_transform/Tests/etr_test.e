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
	ETR_SHARED_TOOLS
		undefine
			default_create
		end
	ETR_SHARED_PARSERS
		undefine
			default_create
		end
	ETR_SHARED_BASIC_OPERATORS
		undefine
			default_create
		end
	ETR_SHARED_FACTORIES
		undefine
			default_create
		end
	SHARED_ERROR_HANDLER
		rename
			error_handler as sys_error_handler
		undefine
			default_create
		end

feature -- Test routines

	printer_test
			-- reads a complex syntax file, prints it out from structure and tries to reparse it
		note
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

			if l_library_dir /= void then
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
				l_parser.parse_from_ascii_string (l_output.string_representation, void)
				assert("Parsing failed", l_parser.error_count = 0)
			else
				assert ("$EIFFEL_SRC not set", false)
			end
		end

	test_ast_modification_invalid
			-- does some invalid ast modifications
		note
			testing:  "EiffelTransform", "covers/{ETR_BASIC_OPS}"
		local
			context: ETR_CONTEXT
			l_trans: ETR_TRANSFORMABLE
		do
			parsing_helper.set_compiler_factory (false)
			create context.make_empty

			error_handler.reset_errors
			l_trans := transformable_factory.new_conditional (transformable_factory.new_expr ("b>a",context), transformable_factory.new_instr ("a:=a-b",context), transformable_factory.new_expr ("b>a",context), context)
			assert("Error 1 not caught", error_handler.has_errors)

			error_handler.reset_errors
			l_trans := transformable_factory.new_conditional (transformable_factory.new_instr ("a:=a-b",context), transformable_factory.new_instr ("a:=a-b",context), transformable_factory.new_instr ("a:=a-b",context), context)
			assert("Error 2 not caught", error_handler.has_errors)

			error_handler.reset_errors
			l_trans := transformable_factory.new_conditional (transformable_factory.new_expr ("b>a",context), transformable_factory.new_instr ("a:=a-b",context),transformable_factory. new_instr ("a:=a-b",context), context)
			assert("Invalid error or error not reset", not error_handler.has_errors)
		end

	test_ast_modification_valid
			-- does some valid ast modifications
		note
			testing:  "EiffelTransform", "covers/{ETR_AST_STRUCTURE_PRINTER}", "covers/{ETR_BASIC_OPS}"
		local
			context: ETR_CONTEXT
			mod1,mod2: ETR_AST_MODIFICATION
			modifier: ETR_AST_MODIFIER
			conditional: ETR_TRANSFORMABLE
		do
			parsing_helper.set_compiler_factory (false)
			-- preparation
			create context.make_empty
			create modifier.make

			-- create conditional
			conditional :=  transformable_factory.new_conditional(transformable_factory.new_expr ("b>a",context), transformable_factory.new_instr ("a:=a-b",context), void, context)

			-- the else-part
			mod1 := basic_operators.list_append(create {AST_PATH}.make_from_parent(conditional.target_node.path, 4), transformable_factory.new_instr ("b:=b-a",context))
			-- the condition
			mod2 := basic_operators.replace (create {AST_PATH}.make_from_parent(conditional.target_node.path, 1), transformable_factory.new_expr ("a>b",context))
			modifier.add(mod1); modifier.add (mod2)
			modifier.apply_to (conditional)

			-- change operator to >=
			mod1 := basic_operators.replace_with_string (create {AST_PATH}.make_from_string("1.1.2"), ">=")
			modifier.add (mod1)
			modifier.apply_to (modifier.modified_transformable)

			-- reference
			parsing_helper.parse_printed_ast (modifier.modified_transformable.target_node,
			"if a >= b then %N"+
				"a := a - b %N"+
			"else %N"+
				"b := b - a %N"+
			"end", Void)

			assert("Invalid result", are_asts_equal(parsing_helper.parsed_ast, modifier.modified_transformable.target_node))
		end

	print_eiffel_files (a_directory: DIRECTORY)
			-- Recursively parses and reprints all classes in `a_directory'
		require
			exists: a_directory.exists
		local
			l_cur_file: KL_BINARY_INPUT_FILE
			l_subdir: DIRECTORY
			l_index: INTEGER
		do
			a_directory.open_read

			from
				a_directory.start
				a_directory.readentry
			until
				a_directory.lastentry = void
			loop
				if not a_directory.lastentry.is_equal (".") and not a_directory.lastentry.is_equal ("..") and not a_directory.lastentry.is_equal (".svn") then
					create l_cur_file.make (a_directory.name+"\"+a_directory.lastentry)
					if l_cur_file.exists then
						-- it's a file
						if a_directory.lastentry.ends_with (".e") then
							-- it's eiffel code
							test_print_file(l_cur_file)
						end
					else
						-- it's a directory
						create l_subdir.make (a_directory.name+"\"+a_directory.lastentry)
						if l_subdir.exists then
							-- recruse
							print_eiffel_files(l_subdir)
						else
							-- oups ?
							check
								false
							end
						end
					end
				end

				a_directory.readentry
			end

			a_directory.close
		end

	huge_printer_test
			-- Parses and reprints all classes in EIFFEL_SRC
		note
			testing:  "EiffelTransform", "covers/{ETR_AST_STRUCTURE_PRINTER}"
		local
			l_root_dir: DIRECTORY
			l_root_dir_name: STRING
			l_env: EXECUTION_ENVIRONMENT
		do
			create l_env
			l_root_dir_name := l_env.get("EIFFEL_SRC")

			create shared_parser.make_with_factory (create {AST_ROUNDTRIP_LIGHT_FACTORY})
			create shared_output.make
			create shared_printer.make_with_output(shared_output)

			if l_root_dir_name /= void then
				create l_root_dir.make(l_root_dir_name+"\framework\eiffel_transform")
				if l_root_dir.exists then
					print_eiffel_files(l_root_dir)
				end
			else
				assert ("$EIFFEL_SRC not set", false)
			end
		end

feature {NONE} -- Helpers

	shared_parser: EIFFEL_PARSER
	shared_output: ETR_AST_STRING_OUTPUT
	shared_printer: ETR_AST_STRUCTURE_PRINTER

	bp_vis: ETR_BP_SLOT_INITIALIZER
		once
			create Result
		end

	test_print_file (a_file: KL_BINARY_INPUT_FILE)
			-- reads a complex syntax file, prints it out from structure and tries to reparse it
		require
			exists: a_file.exists
		local
			l_class_ast: CLASS_AS
		do
			-- Reset
			error_handler.reset_errors
			sys_error_handler.wipe_out
			shared_parser.set_syntax_version (syntax_version)
			shared_output.reset

			a_file.open_read
			-- parse the class (no matchlist is generated)
			shared_parser.parse (a_file)
			a_file.close

			if shared_parser.error_count=0 then
				l_class_ast := shared_parser.root_node

				-- Print
				shared_printer.print_ast_to_output (l_class_ast)

				-- Test bp slot assignment
				bp_vis.init_from (l_class_ast)

				-- reparse the string representation
				-- somehow the syntax version gets reset when parsing
				shared_parser.set_syntax_version (syntax_version)
				shared_parser.parse_from_ascii_string (shared_output.string_representation, Void)

				if shared_parser.error_count >0 then
					io.put_string ("STOP")
				end

				assert("Parsing of "+a_file.name+" failed", shared_parser.error_count = 0)
			else
				-- initial parsing failed for some reason
			end
		end

	are_asts_equal (an_ast, another_ast: AST_EIFFEL): BOOLEAN
			-- compare asts by printing and comparing strings
		local
			l_ast1_str, l_ast2_str: STRING
		do
			l_ast1_str := ast_tools.ast_to_string (an_ast)
			l_ast2_str := ast_tools.ast_to_string (another_ast)

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


