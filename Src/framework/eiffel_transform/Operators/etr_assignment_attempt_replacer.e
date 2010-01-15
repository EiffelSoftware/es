note
	description: "Replaces all assignment attempts by object tests"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_ASSIGNMENT_ATTEMPT_REPLACER
inherit
	ETR_SHARED
	REFACTORING_HELPER
		export
			{NONE} all
		end
	ETR_ERROR_HANDLER

feature -- Operations
	transformation_result: ETR_TRANSFORMABLE
			-- result of last transformation

	replace_assignment_attempts(a_transformable: ETR_TRANSFORMABLE)
			-- replaces assignment attempts in `a_transformable'
		local
			l_visitor: ETR_ASS_ATTMPT_REPL_VISITOR
			l_output: ETR_AST_STRING_OUTPUT
		do
			reset_errors
			transformation_result := void

			create l_output.make
			create l_visitor.make (l_output, a_transformable.context.class_context)
			l_visitor.print_ast_to_output (a_transformable.target_node)
			reparse_printed_ast (a_transformable.target_node, l_output.string_representation)

			if reparsed_root = void then
				add_error("replace_assignment_attempts: Reparsing of modified ast failed")
			else
				create transformation_result.make_from_ast (reparsed_root, a_transformable.context, false)
			end
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
