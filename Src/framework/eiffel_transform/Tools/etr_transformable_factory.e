note
	description: "Transformable factory."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_TRANSFORMABLE_FACTORY
inherit
	ETR_SHARED_ERROR_HANDLER
	ETR_SHARED_PARSERS
	ETR_SHARED_TOOLS

feature -- New

	new_invalid: ETR_TRANSFORMABLE
			-- Create a new invalid transformable
		do
			create Result.make_invalid
		end

	new_instr (a_instr: STRING; a_context: ETR_CONTEXT): ETR_TRANSFORMABLE
			-- Create a new instruction from `a_instr' with context `a_context'
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

	new_expr (a_expr: STRING; a_context: ETR_CONTEXT): ETR_TRANSFORMABLE
			-- Create a new exression from `a_expr' with context `a_context'
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

	new_conditional(a_test: ETR_TRANSFORMABLE; if_part, else_part: detachable ETR_TRANSFORMABLE; a_context: ETR_CONTEXT): ETR_TRANSFORMABLE
			-- Create node corresponding to if `a_test' then `if_part' else `else_part' in a `a_context'
		require
			test_not_void: a_test /= void
			context_not_void: a_context /= void
			a_test_valid: a_test.is_valid
			if_part_valid: attached if_part implies if_part.is_valid
			else_part_valid: attached else_part implies else_part.is_valid
		local
			l_if_part_node, l_else_part_node: EIFFEL_LIST[INSTRUCTION_AS]
			l_if_part_trans, l_else_part_trans, l_test_trans: ETR_TRANSFORMABLE
			l_result_node: IF_AS
			l_test_node: EXPR_AS
			l_error_count: INTEGER
		do
			create Result.make_invalid
			l_error_count := error_handler.error_count

			if attached {EXPR_AS}a_test.target_node as condition then
				if attached if_part then
					-- Check if its a single instruction or multiple
					if attached {INSTRUCTION_AS}if_part.target_node as instr then
						l_if_part_node := ast_tools.single_instr_list (instr)
					elseif attached {EIFFEL_LIST[INSTRUCTION_AS]}if_part.target_node as instrs then
						l_if_part_node := instrs
					else
						error_handler.add_error (Current, "generate_conditional", "Contained ast of if_part is of incompatible type ("+if_part.target_node.generating_type+")")
					end
				end

				if attached else_part then
					-- Check if its a single instruction or multiple
					if attached {INSTRUCTION_AS}else_part.target_node as instr then
						l_else_part_node := ast_tools.single_instr_list (instr)
					elseif attached {EIFFEL_LIST[INSTRUCTION_AS]}else_part.target_node as instrs then
						l_else_part_node := instrs
					else
						error_handler.add_error (Current, "generate_conditional", "Contained ast of else_part is of incompatible type ("+else_part.target_node.generating_type+")")
					end
				end

				if l_error_count = error_handler.error_count then
					-- Transform all parts to a_context
					if attached if_part then
						l_if_part_trans := if_part.as_in_other_context (a_context)
						if attached {EIFFEL_LIST[INSTRUCTION_AS]}l_if_part_trans.target_node as l_if_part then
							l_if_part_node := l_if_part
						end
					end

					if attached else_part then
						l_else_part_trans := else_part.as_in_other_context (a_context)
						if attached {EIFFEL_LIST[INSTRUCTION_AS]}l_else_part_trans.target_node as l_else_part then
							l_else_part_node := l_else_part
						end
					end

					l_test_trans := a_test.as_in_other_context (a_context)
					if attached {EXPR_AS}l_test_trans.target_node as l_test then
						l_test_node := l_test
					end


					if l_error_count = error_handler.error_count then
						-- Assemble new IF_AS and transformable
						create l_result_node.initialize (l_test_node, l_if_part_node, void, l_else_part_node, create {KEYWORD_AS}.make_null, void, void, void)
						create Result.make_from_ast (l_result_node, a_context, false)
					end
				end
			else
				error_handler.add_error (Current, "generate_conditional", "Contained ast of a_test is not of type EXPR_AS (but  "+a_test.target_node.generating_type+")")
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
