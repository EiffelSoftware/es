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
			a1_context, a2_context: ETR_CONTEXT
			a1_feat, a2_feat: FEATURE_I
			a1_instr, a2_instr: ETR_TRANSFORMABLE
		do
			-- create contexts
			a1 := universe.compiled_classes_with_name("A1").first
			a1_ast := a1.compiled_class.ast
			a2 := universe.compiled_classes_with_name("A2").first
			a2_ast := a2.compiled_class.ast
			a1_feat := a1.compiled_class.feature_named ("test")
			a2_feat := a2.compiled_class.feature_named ("test")

			-- create contexts
			create a1_context.make_from_feature (a1_feat)
			create a2_context.make_from_feature (a2_feat)

			-- code snippet in `a1_context'
--			a1_instr := new_instr("io.putstring(a1.generating_type)", a1_context)
--			a1_instr := new_instr("io.putstring(io.putstring(arg_c1_a1.c1_b))", a1_context)
			a1_instr := new_instr("io.putstring(a_c.c1_a)", a1_context)

			-- transform to `a2_context'
			basic_operators.transform_to_context (a1_instr, a2_context)
			a2_instr := basic_operators.transformation_result

			-- print transformed instruction
			io.put_string (ast_to_string(a2_instr.target_node))
		end

	execute
			-- Action performed when invoked from the
			-- command line.
		do
			-- reparse to have the original ast and not use a modified one from storage
--			reparse_class_by_name("A1")
--			reparse_class_by_name("A2")
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
