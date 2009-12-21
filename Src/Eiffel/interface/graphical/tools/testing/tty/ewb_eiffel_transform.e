note
	description: "Entry point for tests of EiffelTransform"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_EIFFEL_TRANSFORM

inherit
	EWB_CMD

	SHARED_SERVER

	COMPILER_EXPORTER

	SHARED_DEGREES

	SHARED_EIFFEL_PARSER

	ETR_SHARED

	REFACTORING_HELPER

	ETR_COMPILATION_HELPER

feature -- Properties

	name: STRING
		do
			Result := "EiffelTransform"
		end

	help_message: STRING_GENERAL
		do
			Result := "EiffelTransform"
		end

	abbreviation: CHARACTER
		do
			Result := 'e'
		end

	printer_test
			-- print some test class
		local
			l_class_file: KL_BINARY_INPUT_FILE
			l_output_file: KL_BINARY_OUTPUT_FILE
			l_class_ast: CLASS_AS
			l_printer: ETR_AST_STRUCTURE_PRINTER
--			l_output: ETR_AST_STRING_OUTPUT
			l_output: ETR_AST_HIERARCHY_OUTPUT
			l_parser: EIFFEL_PARSER
		do
			create l_parser.make_with_factory (create {AST_ROUNDTRIP_LIGHT_FACTORY})

			-- setup class to parse
			l_parser.set_syntax_version ({CONF_OPTION}.syntax_index_transitional)
			create l_class_file.make (system.project_location.location + "\syntax_demo.ee")

			l_class_file.open_read

			-- parse the class (no matchlist is generated)
			l_parser.parse (l_class_file)
			l_class_file.close

			l_class_ast := l_parser.root_node
			index_ast_from_root (l_class_ast)

			create l_output.make

			create l_printer.make_with_output (l_output)
			l_printer.print_ast_to_output(l_class_ast)

			create l_output_file.make (system.project_location.location + "\syntax_demo.duplicated.ee")
			l_output_file.open_write
			l_output_file.put_string (l_output.string_representation)
			l_output_file.close
		end

	print_ast_to_console(an_ast: AST_EIFFEL)
			-- prints an ast to console
		local
			l_printer: ETR_AST_STRUCTURE_PRINTER
			l_output: ETR_AST_STRING_OUTPUT
		do
			create l_output.make
			create l_printer.make_with_output (l_output)
			l_printer.print_ast_to_output(an_ast)
			io.putstring (l_output.string_representation)
		end

	test(a_context: ETR_CONTEXT)
			-- test ast identifiers
		local
			da: DO_AS
			target_class: CLASS_I
			original_ast: CLASS_AS
			instr1,instr2: INSTRUCTION_AS
			modifier: ETR_AST_MODIFIER
			root_transformable: ETR_TRANSFORMABLE
		do
			create modifier.make

			-- retrieve some existing ast
			target_class := universe.compiled_classes_with_name("ETR_DUMMY").first
			original_ast := target_class.compiled_class.ast

			-- create transformable
			-- this creates a copy of an `original_ast' with path indexes
			create root_transformable.make_from_ast (original_ast, a_context, true)

			-- get some instructions
			if attached {CLASS_AS}root_transformable.target_node as cls then
				da ?= cls.features.first.features.first.body.as_routine.routine_body
				instr1 := da.compound.i_th (1)
				instr2 := da.compound.i_th (2)
			end

			-- existing instructions:
			-- 1. io.putint(1)
			-- 2. io.putint(2)

			-- insert before instr1
			modifier.add (basic_operators.insert_before (instr1, new_instr("io.putint(0)",a_context)))

			-- insert after instr2
			modifier.add (basic_operators.insert_after (instr2, new_instr("io.putint(3)",a_context)))

--			-- insert after the instr1
			modifier.add (basic_operators.insert_after (instr1, new_instr("io.putreal (1.5)",a_context)))

--			-- replace old instr2
			modifier.add (basic_operators.replace (instr2, new_instr("io.putreal (2.5)",a_context)))

			-- replace instr1 by
			-- if a_var>0 then
			--   instr1
			-- else
			--   io.putint(8)
			-- end
			basic_operators.if_then_wrap 	(	new_expr("a_var > 0",a_context), -- condition
												create {ETR_TRANSFORMABLE}.make_from_ast(instr1,a_context,true), -- if_part
												new_instr("io.putint(8)",a_context) -- else_part
											)

			modifier.add (basic_operators.replace(instr1,basic_operators.transformation_result))

			-- remove the last item (io.putint(3))
			-- this would fail because the original node is no longer present
--			modifier.add (basic_operators.delete(da.compound.last))

			-- apply changes, create a new copy of the ast with the changes
			modifier.apply_with_context (a_context)

--			print_ast_to_console (working_ast.features.first.features.first)

			-- output should be:
			-- branch taken: 0 1 1.5 2.5 3 followed by
			-- not taken: 0 8 1.5 2.5 3

			-- save changes to class ETR_DUMMY
			if attached universe.compiled_classes_with_name("ETR_DUMMY") as t and then not t.is_empty and attached {CLASS_AS}modifier.modified_ast.target_node as new_ast then
				replace_class_with (original_ast,new_ast)
				mark_class_changed (new_ast)
			end
		end

	test2(a_context: ETR_CONTEXT)
			-- test ast identifiers
		local
			da: DO_AS
			target_class: CLASS_I
			original_ast: CLASS_AS
			instr1,instr2: INSTRUCTION_AS
			modifier: ETR_AST_MODIFIER
			root_transformable: ETR_TRANSFORMABLE
			mod1, mod2, mod3, mod4, mod5: ETR_AST_MODIFICATION
		do
			create modifier.make

			-- retrieve some existing ast
			target_class := universe.compiled_classes_with_name("ETR_DUMMY").first
			original_ast := target_class.compiled_class.ast

			-- create transformable
			-- this creates a copy of an `original_ast' with path indexes
			create root_transformable.make_from_ast (original_ast, a_context, true)

			-- get some instructions
			if attached {CLASS_AS}root_transformable.target_node as cls then
				da ?= cls.features.first.features.first.body.as_routine.routine_body
				instr1 := da.compound.i_th (1)
				instr2 := da.compound.i_th (2)
			end

			basic_operators.if_then_wrap 	(	new_expr("a_var > 0",a_context), -- condition
												create {ETR_TRANSFORMABLE}.make_from_ast(instr1,a_context,true), -- if_part
												new_instr("io.putint(8)",a_context) -- else_part
											)

			-- create some modifications
			mod1 := basic_operators.insert_before (instr1, new_instr("io.putint(0)",a_context))
			mod2 := basic_operators.insert_after (instr2, new_instr("io.putint(3)",a_context))
			mod3 := basic_operators.insert_after (instr1, new_instr("io.putreal (1.5)",a_context))
			mod4 := basic_operators.replace (instr2, new_instr("io.putreal (2.5)",a_context))
			mod5 := basic_operators.replace(instr1,basic_operators.transformation_result)

			-- add them to the "transaction set"
			modifier.add (mod1); modifier.add (mod2); modifier.add (mod3)
			modifier.add (mod4); modifier.add (mod5)

			-- apply changes, creates a new copy of the ast with the changes (reset implicit)
			modifier.apply_with_context (a_context)

			-- we dont want this ast, create a new one
			-- only using modifier 1 and 2
			modifier.add (mod1); modifier.add (mod2)

			-- apply the changes
			modifier.apply_with_context (a_context)

			-- save changes to class ETR_DUMMY
			-- using modifier.modified_ast as new class node
			if attached universe.compiled_classes_with_name("ETR_DUMMY") as t and then not t.is_empty and attached {CLASS_AS}modifier.modified_ast.target_node as new_ast then
				replace_class_with (original_ast,new_ast)
				mark_class_changed (new_ast)
			end
		end

	execute
			-- Action performed when invoked from the
			-- command line.
		local
			context: ETR_CONTEXT
		do
			-- make sure we're in the test project
			check
				not universe.compiled_classes_with_name("ETR_DUMMY").is_empty
			end

			-- at the moment this contains the whole universe + more
			create context

			printer_test

			-- reparse to have the original ast
			reparse_class_by_name("ETR_DUMMY")

--			test(context)
			test2(context)

			eiffel_project.quick_melt
			io.put_string ("System melted with modified AST%N")
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
