note
	description: "Transformable factory"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_TRANSFORMABLE_FACTORY
inherit
	ETR_SHARED_ERROR_HANDLER
	REFACTORING_HELPER
		export
			{NONE} all
		end
	ETR_SHARED_PARSERS

feature -- New

	new_invalid: ETR_TRANSFORMABLE
			-- create a new invalid transformable
		do
			create Result.make_invalid
		end

	new_instr(a_instr: STRING; a_context: ETR_CONTEXT): ETR_TRANSFORMABLE
			-- create a new instruction from `a_instr' with context `a_context'
		require
			instr_attached: a_instr /= void
			context_attached: a_context /= void
		do
			parsing_helper.parse_instruction (a_instr)

			if parsing_helper.parsed_instruction /= void then
				create Result.make_from_ast (parsing_helper.parsed_instruction, a_context, false)
			else
				error_handler.add_error (Current, "new_instr", "Parsing failed")
				create Result.make_invalid
			end
		end

	new_expr(a_expr: STRING; a_context: ETR_CONTEXT): ETR_TRANSFORMABLE
			-- create a new exression from `a_expr' with context `a_context'
		require
			expr_attached: a_expr /= void
			context_attached: a_context /= void
		do
			parsing_helper.parse_expr (a_expr)

			if parsing_helper.parsed_expr /= void then
				create Result.make_from_ast (parsing_helper.parsed_expr, a_context, false)
			else
				error_handler.add_error (Current, "new_expr", "Parsing failed")
				create Result.make_invalid
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
