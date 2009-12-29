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

	test
			-- test context transformations
		local
			a1,a2: CLASS_I
			a1_ast,a2_ast: CLASS_AS
			a1_trans, a2_trans: ETR_TRANSFORMABLE
			a1_context, a2_context: ETR_CONTEXT
			l_target_path: AST_PATH
			l_target_node: AST_EIFFEL
			modifier: ETR_AST_MODIFIER
			mod1: ETR_AST_MODIFICATION

			a2_snippet: ETR_TRANSFORMABLE
		do
			-- goal:
			-- do a transformation in class a1
			-- transform it to the context of class a2
			-- apply it

			-- 1. do transformations in a1 as normal
			create modifier.make

			-- retrieve some existing ast
			a1 := universe.compiled_classes_with_name("A1").first
			a1_ast := a1.compiled_class.ast
			a2 := universe.compiled_classes_with_name("A2").first
			a2_ast := a2.compiled_class.ast

			-- create contexts
			create a1_context.make_from_class (a1.compiled_class.eiffel_class_c)
			create a2_context.make_from_class (a2.compiled_class.eiffel_class_c)

			-- create transformables
			create a1_trans.make_from_ast (a1_ast, a1_context, true)
			create a2_trans.make_from_ast (a2_ast, a2_context, true)

			-- second instruction of the second feature which is the putstring statement
			create l_target_path.make_from_string (a1_trans.target_node, "1.8.1.2.2.2.4.4.1.2")

			l_target_node := find_node(l_target_path, a1_trans.target_node)

			fixme("Allow creation of ETR_TRANSFORMABLE using path only!")

			-- wrap 2nd instruction with if and apply
			basic_operators.if_then_wrap 	(	new_expr("a_var > 0",a1_context), -- condition
												create {ETR_TRANSFORMABLE}.make_from_ast (l_target_node, a1_context, true), -- if_part
												new_instr("io.putint(0)",a1_context) -- else_part
											)

			fixme("This should be done automatically in the application phase")
			basic_operators.transform_to_context (basic_operators.transformation_result, a2_context)
			a2_snippet := basic_operators.transformation_result

			mod1 := basic_operators.list_put_ith (parent_path (l_target_path), 2, a2_snippet)
			modifier.add (mod1)
			modifier.apply_with_context (a2_trans.target_node, a2_context)

			if attached {CLASS_AS}modifier.modified_ast.target_node as new_ast then
				replace_class_with (a2_ast,new_ast)
				mark_class_changed (new_ast)
			end
		end

	execute
			-- Action performed when invoked from the
			-- command line.
		local
			context: ETR_CONTEXT
		do
			-- at the moment this contains the whole universe + more
			create context

			-- reparse to have the original ast and not use a modified one from storage
			reparse_class_by_name("A1")
			reparse_class_by_name("A2")
			test

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
