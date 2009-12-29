note
	description: "Replaces ast nodes"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_AST_MODIFIER
inherit
	ETR_SHARED
		export
			{NONE} all
		end
create
	make

feature {NONE} -- Creation

	make
			-- create a new instance
		do
			create {LINKED_LIST[ETR_AST_MODIFICATION]}modifications.make
			create modified_ast.make_invalid
		end

feature -- Access

	modified_ast: ETR_TRANSFORMABLE

	modifications: LIST[ETR_AST_MODIFICATION]

feature -- Operations

	add(a_modification: ETR_AST_MODIFICATION)
			-- add `a_modification' to `modifications'
		require
			non_void: a_modification /= void
		do
			modifications.extend (a_modification)
		end

	reset
			-- empty `modifications' and reset `output'
		do
			modifications.wipe_out
			output.reset
		end
		
	apply_with_context(a_root: AST_EIFFEL; a_context: ETR_CONTEXT)
			-- apply all in `modifications' and use `a_context' and `a_root'
		require
			non_void: a_context /= void and a_root /= void
		local
			l_printer: ETR_MODIFYING_PRINTER
		do
			-- pick parser depending on root node
			create l_printer.make (output, modifications)
			l_printer.print_ast_to_output (a_root)

			reparse_printed_ast(a_root, output.string_representation)

			if attached reparsed_root then
				create modified_ast.make_from_ast (reparsed_root, a_context, false)
			else
				create modified_ast.make_invalid
			end

--			if attached {CLASS_AS}a_root as cls then
--				etr_class_parser.parse_from_string (output.string_representation,void)

--				create modified_ast.make_from_ast (etr_class_parser.root_node, a_context, false)
--			elseif attached {INSTRUCTION_AS}a_root as instr then
--				etr_instr_parser.parse_from_string (output.string_representation,void)

--				if attached etr_instr_parser.feature_node as fn and then attached {DO_AS}fn.body.as_routine.routine_body as body then
--					create modified_ast.make_from_ast (body.compound.first, a_context, false)
--				end
--			elseif attached {EXPR_AS}a_root as expr then
--				etr_expr_parser.parse_from_string (output.string_representation,void)

--				create modified_ast.make_from_ast (etr_expr_parser.expression_node, a_context, false)
--			else
--				create modified_ast.make_invalid
--			end

			-- reset the modifications list and output
			reset
		end

	output: ETR_AST_STRING_OUTPUT
			-- string output of printer
		once
			create Result.make
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
