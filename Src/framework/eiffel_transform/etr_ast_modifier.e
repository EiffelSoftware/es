note
	description: "Replaces ast nodes"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_AST_MODIFIER
inherit
	REFACTORING_HELPER
		export
			{NONE} all
		end

	ETR_SHARED
		export
			{NONE} all
		end

feature -- Operations

	insert_after(a_path: AST_PATH; a_transformable: ETR_TRANSFORMABLE) is
			-- insert `a_transformable' after `a_path'
		require
			non_void: a_path /= void and a_transformable /= void
			path_valid: a_path.is_valid
		local
			l_done: BOOLEAN
			l_parent: AST_EIFFEL
		do
			-- todo: make this more elegant. maybe store parent in AST_PATH
			l_parent := ast_parent(find_node (a_path))

			if attached {EIFFEL_LIST[AST_EIFFEL]}l_parent as par then
				-- insert into next after path
				from
					par.start
				until
					par.after or l_done
				loop
					-- passed the insertion mark, inserting left of here is always ok
					if par.item.path.branch_id > a_path.branch_id then
						par.put_left (a_transformable.target_node)
						l_done := true
					end
					par.forth
				end

				-- put at the end, all nodes are < path
				if not l_done then
					par.extend (a_transformable.target_node)
				end

				-- recalculate paths from parent node
				reindex_ast (par)
			end
		end

	insert_before(a_path: AST_PATH; a_transformable: ETR_TRANSFORMABLE) is
			-- insert `a_transformable' before `a_path'
		require
			non_void: a_path /= void and a_transformable /= void
			path_valid: a_path.is_valid
		local
			l_done: BOOLEAN
			l_parent: AST_EIFFEL
		do
			-- todo: make this more elegant. maybe store parent in AST_PATH
			l_parent := ast_parent(find_node (a_path))

			if attached {EIFFEL_LIST[AST_EIFFEL]}l_parent as par then
				-- insert into next after path
				from
					par.start
				until
					par.after or l_done
				loop
					-- at insertion mark, put left
					if par.item.path.branch_id = a_path.branch_id then
						par.put_left (a_transformable.target_node)
						l_done := true
					-- passed insertion mark, inserting here
					elseif par.item.path.branch_id > a_path.branch_id then
						par.put_left (a_transformable.target_node)
						l_done := true
					end
					par.forth
				end

				if not l_done then
					-- empty list, just extend
					par.extend (a_transformable.target_node)
				end

				-- recalculate paths from parent node
				reindex_ast (par)
			end
		end

	remove(a_path: AST_PATH) is
			-- remove item at `a_path'
		require
			non_void: a_path /= void
			path_valid: a_path.is_valid
		local
			-- supported:
			l_parent_list: EIFFEL_LIST[INSTRUCTION_AS]
			l_parent: AST_EIFFEL
			-- also needed: binary + unary operators, conditions in loops + branches
			-- + contracts etcetc
			l_position: INTEGER
		do
			-- position in parent:
			l_position := a_path.branch_id

			-- get parent
			l_parent := ast_parent (find_node (a_path))

			-- replace in supported parents
			if attached {EIFFEL_LIST[INSTRUCTION_AS]}l_parent as par then
				replace_in_instr_list(par, l_position, void)
				reindex_ast (par)
			elseif attached {BINARY_AS}l_parent as par then

			elseif attached {UNARY_AS}l_parent as par then

			elseif attached {IF_AS}l_parent as par then

			elseif attached {ELSIF_AS}l_parent as par then

			elseif attached {LOOP_AS}l_parent as par then

            end
		end

	replace_in_instr_list(a_list: EIFFEL_LIST[INSTRUCTION_AS]; a_position:INTEGER; an_instruction: detachable INSTRUCTION_AS) is
			-- replace item at `a_position' in `a_list' by `an_instruction'
		require
			non_void: a_list /= void
			pos_valid: a_position > 0 and a_position <= a_list.count
		do
			if attached an_instruction then
				a_list.put_i_th (an_instruction, a_position)
			else
				-- an_instruction = void
				-- delete item
				a_list.go_i_th (a_position)
				a_list.remove
			end
		end

	replace(a_path: AST_PATH; a_transformable: ETR_TRANSFORMABLE) is
			-- replace `a_transformable' at `a_path'
		require
			non_void: a_path /= void and a_transformable /= void
			path_valid: a_path.is_valid
		local
			-- supported:
			l_parent_list: EIFFEL_LIST[INSTRUCTION_AS]
			l_parent: AST_EIFFEL
			-- also needed: binary + unary operators, conditions in loops + branches
			-- + contracts etcetc
			l_position: INTEGER
		do
			-- position in parent:
			l_position := a_path.branch_id

			-- get parent
			l_parent := ast_parent (find_node (a_path))

			-- replace in supported parents
			if attached {EIFFEL_LIST[INSTRUCTION_AS]}l_parent as par and attached {INSTRUCTION_AS}a_transformable.target_node as instr then
				replace_in_instr_list(par, l_position, instr)
				reindex_ast (par)
			elseif attached {BINARY_AS}l_parent as par then

			elseif attached {UNARY_AS}l_parent as par then

			elseif attached {IF_AS}l_parent as par then

			elseif attached {ELSIF_AS}l_parent as par then

			elseif attached {LOOP_AS}l_parent as par then

            end
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
