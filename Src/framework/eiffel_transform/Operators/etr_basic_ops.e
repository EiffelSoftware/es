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

feature -- Transformations

	transformation_result: detachable ETR_TRANSFORMABLE
		-- result of last transformation

	if_then_wrap_in_context(a_test: ETR_TRANSFORMABLE; if_part, else_part: detachable ETR_TRANSFORMABLE; a_context: ETR_CONTEXT) is
			-- create node corresponding to if `a_test' then `if_part' else `else_part' end with `a_context'
		require
			test_not_void: a_test /= void
			context_not_void: a_context /= void
		local
			l_if_part_node, l_else_part_node: EIFFEL_LIST[INSTRUCTION_AS]
			l_result_node: IF_AS
			l_if_part_dup: like if_part
			l_else_part_dup: like else_part
		do
			if attached {EXPR_AS}a_test.target_node as condition then
				if attached if_part then
					duplicate_ast (if_part.target_node)
					-- check if its a single instruction or multiple
					if attached {INSTRUCTION_AS}duplicated_ast as instr then
						l_if_part_node := single_instr_list (instr)
					elseif attached {EIFFEL_LIST[INSTRUCTION_AS]}duplicated_ast as instrs then
						l_if_part_node := instrs
					end
				end

				if attached else_part then
					duplicate_ast (else_part.target_node)
					-- check if its a single instruction or multiple
					if attached {INSTRUCTION_AS}duplicated_ast as instr then
						l_else_part_node := single_instr_list (instr)
					elseif attached {EIFFEL_LIST[INSTRUCTION_AS]}duplicated_ast as instrs then
						l_else_part_node := instrs
					end
				end

				-- assemble new IF_AS
				create l_result_node.initialize (condition, l_if_part_node, void, l_else_part_node, end_keyword, void, void, void)

				-- index it as well
				index_ast_from_root (l_result_node)

				create transformation_result.make_from_ast (l_result_node, a_context, false)
			else
				transformation_result := new_invalid_transformable
			end
		end

	if_then_wrap(a_test: ETR_TRANSFORMABLE; if_part, else_part: detachable ETR_TRANSFORMABLE) is
			-- create node corresponding to if `a_test' then `if_part' else `else_part' end with context from `a_test'
		require
			test_not_void: a_test /= void
		do
			if_then_wrap_in_context(a_test, if_part, else_part, a_test.context)
		end

feature -- Modifications (path-reference)

	insert_after(a_reference: AST_PATH; a_new_trans: ETR_TRANSFORMABLE): ETR_AST_MODIFICATION
			-- Insert `a_new_trans' after `a_reference'
		require
			non_void: a_reference /= void and a_new_trans /= void
		do
			create Result.make_insert_after (a_reference, a_new_trans)
		end

	insert_before(a_reference: AST_PATH; a_new_trans: ETR_TRANSFORMABLE): ETR_AST_MODIFICATION
			-- Insert `a_new_trans' before `a_reference'
		require
			non_void: a_reference /= void and a_new_trans /= void
		do
			create Result.make_insert_before (a_reference, a_new_trans)
		end

	delete(a_reference: AST_PATH): ETR_AST_MODIFICATION
			-- Delete `a_reference'
		require
			non_void: a_reference /= void
		do
			create Result.make_delete (a_reference)
		end

	replace(a_reference: AST_PATH; a_replacement: ETR_TRANSFORMABLE): ETR_AST_MODIFICATION
				-- Replace `a_reference' by `a_replacement'
		require
			non_void: a_reference /= void and a_replacement /= void
		do
			create Result.make_replace (a_reference, a_replacement)
		end

	list_prepend(a_list: AST_PATH; a_replacement: ETR_TRANSFORMABLE): ETR_AST_MODIFICATION
				-- Append `a_replacement' to `a_list'
		require
			non_void: a_list /= void and a_replacement /= void
		do
			create Result.make_list_prepend (a_list, a_replacement)
		end

	list_append(a_list: AST_PATH; a_replacement: ETR_TRANSFORMABLE): ETR_AST_MODIFICATION
				-- Prepend `a_replacement' to `a_list'
		require
			non_void: a_list /= void and a_replacement /= void
		do
			create Result.make_list_append (a_list, a_replacement)
		end

	list_put_ith(a_list: AST_PATH; a_position: INTEGER; a_replacement: ETR_TRANSFORMABLE): ETR_AST_MODIFICATION
				-- Replace item at position `a_positin' in `a_list' by `a_replacement'
		require
			non_void: a_list /= void and a_replacement /= void
		do
			create Result.make_list_put_ith (a_list, a_position, a_replacement)
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
