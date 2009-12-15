note
	description: "Basic mutation operators"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_BASIC_OPS
inherit
	ETR_SHARED
		export
			{NONE} all
		end

	REFACTORING_HELPER
		export
			{NONE} all
		end

feature {NONE} -- Implementation

	end_keyword: KEYWORD_AS is
			-- simple end keyword with no location or text information
		once
			create Result.make_null
			Result.set_code ({EIFFEL_TOKENS}.te_end)
		ensure
			Result.is_end_keyword
		end

feature -- Transform

	new_if_then_branch(a_test: ETR_TRANSFORMABLE; if_part, else_part: detachable ETR_TRANSFORMABLE):ETR_TRANSFORMABLE is
			-- create node with: if a_test then if_part else else_part end
			-- use context from a_test
		local
			if_part_node, else_part_node: EIFFEL_LIST[INSTRUCTION_AS]
			result_node: IF_AS
			if_part_dup: like if_part
			else_part_dup: like else_part
		do
			-- todo: error/incompatibility handling

			if attached {EXPR_AS}a_test.target_node as condition then
				if attached if_part then
					duplicate_ast (if_part.target_node)
					-- check if its a single instruction or multiple
					if attached {INSTRUCTION_AS}duplicated_ast as instr then
						if_part_node := single_instr_list (instr)
					elseif attached {EIFFEL_LIST[INSTRUCTION_AS]}duplicated_ast as instrs then
						if_part_node := instrs
					end
				end

				if attached else_part then
					duplicate_ast (else_part.target_node)
					-- check if its a single instruction or multiple
					if attached {INSTRUCTION_AS}duplicated_ast as instr then
						else_part_node := single_instr_list (instr)
					elseif attached {EIFFEL_LIST[INSTRUCTION_AS]}duplicated_ast as instrs then
						else_part_node := instrs
					end
				end

				-- assemble new IF_AS
				create result_node.initialize (condition, if_part_node, void, else_part_node, end_keyword, void, void, void)

				adjust_for_context (result_node, a_test.context)
				-- index it as well
				index_ast_from_root (result_node)

				create Result.make_with_node (result_node, a_test.context)
			end

			-- what happens if there is some mismatch between contained nodes in the transformables?
			-- return void or some special null-transformable?
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
