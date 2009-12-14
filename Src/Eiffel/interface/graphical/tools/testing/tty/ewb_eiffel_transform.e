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

	path_test is
			-- test ast identifiers
		local
			da: DO_AS
			target_class: CLASS_I
			original_ast, working_ast: CLASS_AS
			instr: INSTRUCTION_AS
			string_path: STRING
			found_node, parent_node: AST_EIFFEL
		do
			-- retrieve some existing ast
			target_class := universe.compiled_classes_with_name("ETR_DUMMY").first
			original_ast := target_class.compiled_class.ast

			-- duplicate it and index it
			duplicate_ast (original_ast)
			working_ast ?= duplicated_ast
			index_ast (working_ast)

			-- get some instruction
			da ?= working_ast.features.first.features.first.body.as_routine.routine_body
			instr := da.compound.first

			-- store its path
			string_path := instr.path.as_string

			-- find this node from the root and the string
			found_node := find_node (create {AST_PATH}.make_from_string(working_ast, string_path))

			check
				equal: found_node = instr
			end

			-- fetch its parent container (1 level above)
			-- the EIFFEL_LIST of the do-body in this case
			parent_node := find_node (create {AST_PATH}.make_from_child(found_node, 1))
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

			path_test

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
