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
		end

feature -- Access

	modified_ast: detachable ETR_TRANSFORMABLE

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
			-- empty `modifications'
		do
			modifications.wipe_out
		end

	apply_with_context(a_context: ETR_CONTEXT)
			-- apply all in `modifications' and use `a_context'
		require
			non_void: a_context /= void
		local
			l_new_node: ETR_TRANSFORMABLE
			l_ref_node: AST_EIFFEL
			l_path: AST_PATH
			l_modification: ETR_AST_MODIFICATION
		do
			-- duplicate ast
			if not modifications.is_empty then
				-- assume the root of all modifications is the same	
				create modified_ast.make_from_ast (modifications.first.ref_ast.path.root, a_context, true)
				new_root := modified_ast.target_node
			else
				create modified_ast.make_invalid
			end

			-- setup internal modifications (because we dont want to modify the original ones)
			from
				modifications.start
				create {LINKED_LIST[ETR_AST_MODIFICATION]}internal_modifications.make
			until
				modifications.after
			loop
				-- find the ref node in the new ast
				l_ref_node := find_node (modifications.item.ref_ast.path, new_root)

				if not modifications.item.is_delete then
					-- duplicate the new node
					create l_new_node.make_from_ast (modifications.item.new_transformable.target_node, a_context, true)
				end

				if modifications.item.is_delete then
					create l_modification.make_delete(l_ref_node)
				elseif modifications.item.is_insert_after then
					create l_modification.make_insert_after(l_ref_node, l_new_node)
				elseif modifications.item.is_insert_before then
					create l_modification.make_insert_before(l_ref_node, l_new_node)
				elseif modifications.item.is_replace then
					create l_modification.make_replace(l_ref_node, l_new_node)
				end
				internal_modifications.extend (l_modification)

				modifications.forth
			end

			-- apply modifications one by one
			from
				internal_modifications.start
			until
				internal_modifications.after
			loop
				if internal_modifications.item.is_delete then
					apply_delete(internal_modifications.item)
				elseif internal_modifications.item.is_insert_after then
					apply_insert_after(internal_modifications.item)
				elseif internal_modifications.item.is_insert_before then
					apply_insert_before(internal_modifications.item)
				elseif internal_modifications.item.is_replace then
					apply_replace(internal_modifications.item)
				end

				internal_modifications.forth
			end

			-- reset the modifications list
			reset
		end

feature {NONE} -- Implementation

	internal_modifications: LIST[ETR_AST_MODIFICATION]

	new_root: AST_EIFFEL

	apply_insert_after(a_modification: ETR_AST_MODIFICATION)
			-- apply `a_modification'
		local
			l_done: BOOLEAN
			l_parent, l_new_node: AST_EIFFEL
			l_path: AST_PATH
		do
			l_path := a_modification.ref_ast.path
			l_parent := ast_parent(l_path, new_root)
			l_new_node := a_modification.new_transformable.target_node

			-- check compatibility
			if attached {EIFFEL_LIST[AST_EIFFEL]}l_parent as par and then l_new_node.conforms_to(par.first) then
				-- insert into next after path
				from
					par.start
				until
					par.after or l_done
				loop
					-- passed the insertion mark, inserting left of here is always ok
					if par.item.path.branch_id > l_path.branch_id then
						par.put_left (l_new_node)
						l_done := true
					end
					par.forth
				end

				-- put at the end, all nodes are < path
				if not l_done then
					par.extend (l_new_node)
				end

				-- recalculate paths from parent node
				reindex_ast (par)
			end
		end

	apply_insert_before(a_modification: ETR_AST_MODIFICATION)
			-- apply `a_modification'
		local
			l_done: BOOLEAN
			l_parent, l_new_node: AST_EIFFEL
			l_path: AST_PATH
		do
			l_path := a_modification.ref_ast.path
			l_parent := ast_parent(l_path, new_root)
			l_new_node := a_modification.new_transformable.target_node

			-- check compatibility
			if attached {EIFFEL_LIST[AST_EIFFEL]}l_parent as par and then l_new_node.conforms_to(par.first) then
				-- insert into next after path
				from
					par.start
				until
					par.after or l_done
				loop
					-- at insertion mark, put left
					if par.item.path.branch_id = l_path.branch_id then
						par.put_left (l_new_node)
						l_done := true
					-- passed insertion mark, inserting here
					elseif par.item.path.branch_id > l_path.branch_id then
						par.put_left (l_new_node)
						l_done := true
					end
					par.forth
				end

				if not l_done then
					-- empty list, just extend
					par.extend (l_new_node)
				end

				-- recalculate paths from parent node
				reindex_ast (par)
			end
		end

	apply_delete(a_modification: ETR_AST_MODIFICATION)
			-- apply `a_modification'
		local
			-- supported:
			l_parent_list: EIFFEL_LIST[AST_EIFFEL]
			l_parent: AST_EIFFEL
			-- also needed: binary + unary operators, conditions in loops + branches
			-- + contracts etcetc
			l_position: INTEGER
			l_path: AST_PATH
		do
			l_path := a_modification.ref_ast.path

			-- position in parent:
			l_position := l_path.branch_id

			-- get parent
			l_parent := ast_parent (l_path, new_root)

			-- replace in supported parents
			if attached {EIFFEL_LIST[AST_EIFFEL]}l_parent as par then
				par.go_i_th (l_position)
				par.remove
				reindex_ast (par)
			elseif attached {BINARY_AS}l_parent as par then

			elseif attached {UNARY_AS}l_parent as par then

			elseif attached {IF_AS}l_parent as par then

			elseif attached {ELSIF_AS}l_parent as par then

			elseif attached {LOOP_AS}l_parent as par then
            end

            -- invalidate the old node (so we notice when we wan't to illegally modify it still)
            a_modification.ref_ast.set_path (void)
		end

	apply_replace(a_modification: ETR_AST_MODIFICATION)
			-- apply `a_modification'
		local
			-- supported:
			l_parent_list: EIFFEL_LIST[AST_EIFFEL]
			l_parent, l_new_node: AST_EIFFEL
			-- also needed: binary + unary operators, conditions in loops + branches
			-- + contracts etcetc
			l_position: INTEGER
			l_path: AST_PATH
		do
			l_path := a_modification.ref_ast.path
			l_new_node := a_modification.new_transformable.target_node

			-- position in parent:
			l_position := l_path.branch_id

			-- get parent
			l_parent := ast_parent (l_path, new_root)

			-- replace in supported parents
			if attached {EIFFEL_LIST[AST_EIFFEL]}l_parent as par and attached {AST_EIFFEL}l_new_node as item then
				-- check for catcall
				if l_new_node.conforms_to(par.first) then
					par.put_i_th (item, l_position)
					reindex_ast (par)
				end
			elseif attached {BINARY_AS}l_parent as par then

			elseif attached {UNARY_AS}l_parent as par then

			elseif attached {IF_AS}l_parent as par then

			elseif attached {ELSIF_AS}l_parent as par then

			elseif attached {LOOP_AS}l_parent as par then

            end
            -- invalidate the old node (so we notice when we wan't to illegally modify it still)
            a_modification.ref_ast.set_path (void)
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
