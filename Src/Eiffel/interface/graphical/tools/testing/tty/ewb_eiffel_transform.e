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

	reparse_class_by_name(a_class: STRING) is
			-- DEBUG. set class to reparse + remelt
		local
			target_class: CLASS_I
			cid: INTEGER
		do
			target_class := universe.compiled_classes_with_name(a_class).first
			cid := target_class.compiled_class.class_id
			restore_ast (ast_server.item (cid), create {ETR_CONTEXT})
		end

	test(a_context: ETR_CONTEXT) is
			-- test ast identifiers
		local
			da: DO_AS
			target_class: CLASS_I
			original_ast, working_ast: CLASS_AS
			instr1,instr2: INSTRUCTION_AS
			cid: INTEGER
		do
			-- retrieve some existing ast
			target_class := universe.compiled_classes_with_name("ETR_DUMMY").first
			original_ast := target_class.compiled_class.ast

			-- duplicate it and index it
			duplicate_ast (original_ast)
			working_ast ?= duplicated_ast
			index_ast_from_root (working_ast)

			-- get some instruction
			da ?= working_ast.features.first.features.first.body.as_routine.routine_body
			instr1 := da.compound.i_th (1)
			instr2 := da.compound.i_th (2)

			-- existing instructions:
			-- 1. io.putint(1)
			-- 2. io.putint(2)

			-- insert after the last item
			ast_modifier.insert_after (da.compound.last.path, new_instr("io.putint(3)",a_context))

			-- insert before the first item
			ast_modifier.insert_before (da.compound.first.path, new_instr("io.putint(0)",a_context))

			-- insert after the instr1
			ast_modifier.insert_after (instr1.path, new_instr("io.putreal (1.5)",a_context))

			-- replace old instr2
			ast_modifier.replace (instr2.path, new_instr("io.putreal (2.5)",a_context))

			-- replace instr1 by
			-- if a_var>0 then
			--   instr1
			-- else
			--   io.putint(8)
			-- end
			ast_modifier.replace (  instr1.path,
									basic_operators.new_if_then_branch (
																			new_expr("a_var > 0",a_context), -- condition
																			create {ETR_TRANSFORMABLE}.make_with_node(instr1,a_context), -- if_part
																			new_instr("io.putint(8)",a_context) -- else_part
																		)
								 )

			-- output should be:
			-- branch taken: 0 1 1.5 2.5 3 followed by
			-- not taken: 0 8 1.5 2.5 3

			-- save changes to class ETR_DUMMY
			if attached universe.compiled_classes_with_name("ETR_DUMMY") as t and then not t.is_empty then
				cid :=t.first.compiled_class.class_id
				replace_class_in_context (working_ast, a_context)
				mark_ast_changed (working_ast, a_context)
			end
		end


	execute
			-- Action performed when invoked from the
			-- command line.
		local
			context: ETR_CONTEXT
--			old_ast: CLASS_AS
		do
			-- make sure we're in the test project
			check
				not universe.compiled_classes_with_name("ETR_DUMMY").is_empty
			end

			-- at the moment this contains the whole universe + more
			create context

			-- reparse to have the original ast
			-- later we can just restore it because we duplicated (todo)
			reparse_class_by_name("ETR_DUMMY")

			test(context)

--			sample_use_1(context)
--			sample_use_2_new(context)
--			sample_use_3(context)

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
