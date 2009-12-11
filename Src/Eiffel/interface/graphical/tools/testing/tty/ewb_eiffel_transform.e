note
	description: "Entry point for tests of EiffelTransform"
	author: ""
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

	ETR_SHARED_BASIC_OPS

	REFACTORING_HELPER

create
	make_with_arguments

feature {NONE} -- Initialization

	make_with_arguments (a_arguments: LINKED_LIST [STRING])
			-- Initialize `auto_test_arguments' with `a_arguments'.
		require
			a_arguments_attached: a_arguments /= Void
		do
			create {LINKED_LIST [STRING]} etr_arguments.make
			a_arguments.do_all (agent etr_arguments.extend)
		ensure
			arguments_set: etr_arguments /= Void and then etr_arguments.count = a_arguments.count
		end

feature -- Access

	etr_arguments: LINKED_LIST [STRING];
			-- Arguments to AutoFix command line

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

	sample_use_1(a_context: ETR_CONTEXT) is
			-- sample usage 1
		local
			l_class_file: KL_BINARY_INPUT_FILE
		do
			-- sample use 1
			-- replace whole class node by another (conforming) one

			create l_class_file.make (system.project_location.location+"\target.ee")
			l_class_file.open_read
			eiffel_parser.parse (l_class_file)
			l_class_file.close

			adjust_for_context(eiffel_parser.root_node, a_context)
			replace_class_in_context (eiffel_parser.root_node, a_context)
			mark_ast_changed (eiffel_parser.root_node, a_context)
		end

	sample_use_2(a_context: ETR_CONTEXT) is
			-- sample usage 2
		local
			cond: EXPR_AS
			da: DO_AS
			instr: INSTRUCTION_AS
			res: IF_AS
			target_class: CLASS_I
			original_ast: CLASS_AS
			cid: INTEGER
		do
			-- sample use 2
			-- encapsulates the first instruction in some feature with an if branch
			-- this is still way too ugly/complicated
			-- some of this to be put into the library with easier usage

			-- retrieve the existing ast
			target_class := universe.compiled_classes_with_name("ETR_DUMMY").first
			cid :=target_class.compiled_class.class_id
			original_ast := ast_server.item (cid)

			-- lets get some instruction to apply the transformer
			-- this can of course be done more elegantly/general
			-- its just for a simple demo
			da ?= original_ast.features.first.features.first.body.as_routine.routine_body
			instr := da.compound.first

			-- create a condition from text
			cond := new_expr("a_var>0",void)

			-- we could also assemble the AST ourselves:
--			cond := create {BIN_GT_AS}.initialize ( create {EXPR_CALL_AS}.initialize (
--																						create {ACCESS_ID_AS}.initialize (
--																															create {ID_AS}.initialize_from_id (system.names.id_of("a_var")),
--																															void)),
--																						create {INTEGER_CONSTANT}.make_with_value(0), void)

			-- assemble an IF_AS node:
			-- if cond then instr end
			res := if_wrap(single_instr_list (instr), cond, a_context)
			-- replace the first instruction
			-- the new first instruction in the do-body will be the new branch
			to_implement("An elegant way to replace/modify instructions. By id or so?")
			da.compound.put_i_th (res, 1)

			-- lets insert something to test
			da.compound.extend(new_instr ("io.put_integer(42)",void))

			replace_class_in_context (original_ast, a_context)

			-- make sure it conforms (will be put into the operator later)
			adjust_for_context (original_ast, a_context)

			mark_ast_changed (original_ast, a_context)
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

			-- reparse to have the original ast
			-- later we can just restore it because we duplicated (todo)
			reparse_class_by_name("ETR_DUMMY")

--			sample_use_1(context)
			sample_use_2(context)

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
