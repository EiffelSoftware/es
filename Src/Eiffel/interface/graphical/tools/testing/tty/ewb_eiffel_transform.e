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

	test(a_context: ETR_CONTEXT)
			-- test ast identifiers
		local
			da: DO_AS
			target_class: CLASS_I
			original_ast: CLASS_AS
			instr1,instr2: INSTRUCTION_AS
			modifier: ETR_AST_MODIFIER
			root_transformable: ETR_TRANSFORMABLE
			mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8: ETR_AST_MODIFICATION
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

			-- else part is branch 4 of IF_AS
			mod1 := basic_operators.list_append (create {AST_PATH}.make_from_parent(instr1, 4), new_instr("io.putint(2)",a_context))

			mod2 := basic_operators.list_append (da.compound.path, new_instr("io.putint(7)",a_context))
			mod3 := basic_operators.list_append (da.compound.path, new_instr("io.putint(8)",a_context))
			mod4 := basic_operators.list_append (da.compound.path, new_instr("io.putint(9)",a_context))
			mod5 := basic_operators.list_prepend (da.compound.path, new_instr("io.putint(-1)",a_context))
			mod6 := basic_operators.list_prepend (da.compound.path, new_instr("io.putint(-2)",a_context))
			mod7 := basic_operators.list_prepend (da.compound.path, new_instr("io.putint(-3)",a_context))

			-- replace instr 2
			mod8 := basic_operators.list_put_ith (da.compound.path, 2, new_instr("io.putint(4)",a_context))


			-- add them to the "transaction set"
			modifier.add (mod1);
			modifier.add (mod2);
 			modifier.add (mod3)
			modifier.add (mod4);
			modifier.add (mod5);
			modifier.add (mod6)
			modifier.add (mod7);
			modifier.add (mod8)

			-- apply changes, creates a new copy of the ast with the changes (reset implicit)
			modifier.apply_with_context (root_transformable.target_node, a_context)

			-- apply some of them again. they should not be affected by previous application!
--			modifier.add (mod1); modifier.add (mod2)
--			modifier.apply_with_context (root_transformable.target_node, a_context)

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

			-- reparse to have the original ast and not use a modified one from storage
			reparse_class_by_name("ETR_DUMMY")
			test(context)

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
