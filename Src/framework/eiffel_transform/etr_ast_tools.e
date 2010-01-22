note
	description: "Summary description for {ETR_AST_TOOLS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_AST_TOOLS

feature {NONE} -- Implementation

	shared_printer: ETR_AST_STRUCTURE_PRINTER
			-- prints small ast fragments to text
		once
			create Result.make_with_output(shared_printer_output)
		end

	shared_printer_output: ETR_AST_STRING_OUTPUT
			-- output used for `mini_printer'
		once
			create Result.make
		end

feature -- Access

	duplicated_ast: detachable AST_EIFFEL
			-- Result of `duplicate_ast'

feature -- Output

	ast_to_string(an_ast: AST_EIFFEL): STRING
			-- prints `an_ast' to text using `mini_printer'
		do
			shared_printer_output.reset
			shared_printer.print_ast_to_output(an_ast)

			Result := shared_printer_output.string_representation
		end

feature -- Operations

	duplicate_ast(an_ast: AST_EIFFEL)
			-- duplicates `an_ast' and stores the result in `duplicated_ast'
		require
			non_void: an_ast /= void
		do
			-- is cloning the way to go?
			-- alternative would be:
			-- print + reparse (are some ids lost? adjust for context again?)
			-- 		needs facility to print ast without matchlist
			-- recreating from scratch
			--		very dependant on ast structure

			duplicated_ast := an_ast.deep_twin
		end

	single_instr_list(instr: INSTRUCTION_AS): EIFFEL_LIST [like instr]
			-- creates list with a single instruction `instr'
		require
			instr_not_void: instr/=void
		do
			create Result.make (1)
			Result.extend (instr)
		ensure
			one: Result.count = 1
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
