note
	description: "Prints an ast an incorporates modifications"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_MODIFYING_PRINTER
inherit
	ETR_AST_STRUCTURE_PRINTER
		rename
			process as process_or_replace
		redefine
			process_or_replace,
			process_eiffel_list
		end
	ETR_SHARED
		export
			{NONE} all
		end
create
	make

feature {NONE} -- Implementation

	location: AST_PATH
	replacement_text: STRING
	replacement_disabled: BOOLEAN

	repl_hash: HASH_TABLE[ETR_AST_MODIFICATION,AST_PATH]
	del_hash: HASH_TABLE[ETR_AST_MODIFICATION,AST_PATH]
	ins_hash: HASH_TABLE[SORTABLE_ARRAY[ETR_AST_MODIFICATION],AST_PATH]

	process_or_replace (l_as: AST_EIFFEL)
			-- process `l_as' and check for replacement
		local
			l_mod: ETR_AST_MODIFICATION
		do
			output.enter_block
			if attached l_as then
				l_mod := repl_hash.item (l_as.path)
			end

			if attached l_mod and not replacement_disabled then
				output.append_string (l_mod.replacement_text)
			else
				Precursor(l_as)
			end
			output.exit_block
		end

	mini_printer: ETR_AST_STRUCTURE_PRINTER
			-- prints small ast fragments to text
		once
			create Result.make_with_output(mini_printer_output)
		end

	mini_printer_output: ETR_AST_STRING_OUTPUT
			-- output used for `mini_printer'
		once
			create Result.make
		end

	ast_to_string(an_ast: AST_EIFFEL): STRING
			-- prints `an_ast' to text using `mini_printer'
		do
			mini_printer_output.reset
			mini_printer.print_ast_to_output(an_ast)

			Result := mini_printer_output.string_representation
		end

	shift_after_insert(mods_arr: ARRAY[ETR_AST_MODIFICATION]; pos: INTEGER)
			-- shifts locations after an insertion at `pos'
		local
			i: INTEGER
			l_mod: ETR_AST_MODIFICATION
			l_brid: INTEGER
		do
			-- all operations after pos have to be incremented
			from
				i:=mods_arr.lower
			until
				i>mods_arr.upper
			loop
				l_mod := mods_arr[i]
				l_brid := l_mod.branch_id

				if l_brid >= pos then
					l_mod.set_branch_id (l_brid+1)
				end
				i:=i+1
			end
		end

	parent_path(a_path: AST_PATH): AST_PATH
			-- constructs the path of `a_path's parent
		require
			non_void: a_path /= void
			path_valid: a_path.is_valid
			not_root: a_path.as_array.count>1
		local
			l_parent_string: STRING
			i: INTEGER
		do
			-- construct path of parent
			from
				i := a_path.as_array.lower
				create l_parent_string.make_empty
			until
				i > a_path.as_array.upper-1
			loop
				if i /= a_path.as_array.upper-1 then
					l_parent_string := l_parent_string + a_path.as_array[i].out + {AST_PATH}.separator.out
				else
					l_parent_string := l_parent_string + a_path.as_array[i].out
				end
				i := i+1
			end

			create Result.make_from_string (a_path.root, l_parent_string)
		end

feature {NONE} -- Creation

	make(an_output: ETR_AST_STRUCTURE_OUTPUT; modifications: LIST[ETR_AST_MODIFICATION])
			-- make with `an_output' and `modifications'
		local
			ins,del,repl: LINKED_LIST[ETR_AST_MODIFICATION]
			l_parent: AST_PATH
			l_parent_set: ARRAYED_SET[AST_PATH]
			l_par_groups: LINKED_LIST[TUPLE[AST_PATH,LINKED_LIST[ETR_AST_MODIFICATION]]]
			l_temp_mod_arr: SORTABLE_ARRAY[ETR_AST_MODIFICATION]
			i: INTEGER
		do
			-- set output
			make_with_output (an_output)

			-- separate based on type of modification and set branch ids
			from
				modifications.start
				create ins.make
				create del.make
				create repl.make
			until
				modifications.after
			loop
				modifications.item.set_branch_id (modifications.item.ref_ast.branch_id)
				if modifications.item.is_delete then
					del.extend (modifications.item)
				elseif modifications.item.is_replace then
					repl.extend (modifications.item)
				else -- is_insert_*
					ins.extend (modifications.item)
				end

				modifications.forth
			end

			-- init structures for replacement
			from
				create repl_hash.make (repl.count)
				repl.start
			until
				repl.after
			loop
				if attached ast_to_string(repl.item.new_transformable.target_node) as rep_str then
					repl.item.set_replacement_text(rep_str)
				else
					check false end
				end

				repl_hash.extend (repl.item, repl.item.ref_ast)
				repl.forth
			end

			-- init structures for deletion
			from
				create del_hash.make (del.count)
				del.start
			until
				del.after
			loop
				del_hash.extend (del.item, del.item.ref_ast)
				del.forth
			end

			-- init structures for insertion
			-- pass1: store parent list location and find different ones
			from
				ins.start
				create l_parent_set.make (ins.count)
				l_parent_set.compare_objects
			until
				ins.after
			loop
				l_parent := parent_path(ins.item.ref_ast)
				ins.item.set_list_parent(l_parent)
				l_parent_set.put (l_parent)
				ins.forth
			end

			-- pass2: create parent groups
			from
				l_parent_set.start
				create l_par_groups.make
			until
				l_parent_set.after
			loop
				l_par_groups.extend ([l_parent_set.item,create {LINKED_LIST[ETR_AST_MODIFICATION]}.make])
				l_parent_set.forth
			end

			-- pass3: group them
			fixme("This is O(num_parents*num_insertions)")
			from
				ins.start
			until
				ins.after
			loop
				-- insert into the matching group
				l_par_groups.do_if (
					-- insert into the list ...
					agent (x: TUPLE[AST_PATH,LINKED_LIST[ETR_AST_MODIFICATION]]; mod:ETR_AST_MODIFICATION)
						do
							if attached {LINKED_LIST[ETR_AST_MODIFICATION]}x.item(2) as list then
								list.extend (mod)
							end
						end(?,ins.item),
					-- ... if parent path is the matching one
					agent (x: TUPLE[AST_PATH,LINKED_LIST[ETR_AST_MODIFICATION]]; mod:ETR_AST_MODIFICATION):BOOLEAN
						do
							if attached {AST_PATH}x.item(1) as path then
								Result := path.is_equal(mod.list_parent)
							end
						end(?,ins.item)
						)
				ins.forth
			end

			-- pass4: create hash table
			from
				create ins_hash.make(l_par_groups.count)
				l_par_groups.start
			until
				l_par_groups.after
			loop
				if attached {AST_PATH}l_par_groups.item.item(1) as path and
				   attached {LINKED_LIST[ETR_AST_MODIFICATION]}l_par_groups.item.item(2) as list then

				   	from
				   		create l_temp_mod_arr.make (1,list.count)
				   		i := 1
				   		list.start
				   	until
				   		list.after
				   	loop
						l_temp_mod_arr.force (list.item, i)
				   		list.forth
				   		i:=i+1
				   	end

				   	ins_hash.extend (l_temp_mod_arr, path)
				end

				l_par_groups.forth
			end

			-- pass5: sort items in the hash table
			from
				ins_hash.start
			until
				ins_hash.after
			loop
				ins_hash.item_for_iteration.sort
				ins_hash.forth
			end
		end

feature -- Roundtrip

	process_eiffel_list (l_as: EIFFEL_LIST [AST_EIFFEL])
		local
			l_mods_arr: ARRAY[ETR_AST_MODIFICATION]
			i: INTEGER
			l_list_copy: like l_as
			l_target: AST_EIFFEL
			l_changed_items: LINKED_LIST[AST_EIFFEL]
			l_mod: ETR_AST_MODIFICATION
		do
			if attached l_as then
				l_mod := repl_hash.item (l_as.path)
			end

			if attached l_mod then
				output.append_string (l_mod.replacement_text)
			else
				-- shallow copy of original list
				-- because we're gonna reorder it!
				fixme("Is this ok?")
				l_list_copy := l_as.twin
				create l_changed_items.make

				-- get the items to be inserted in this list sorted by branch_id
				l_mods_arr := ins_hash[l_list_copy.path]

				if attached l_mods_arr and not l_mods_arr.is_empty then
					-- first pass: do insertions and deletions
					from
						l_list_copy.start
						i:=l_mods_arr.lower
					until
						l_list_copy.after or i > l_mods_arr.upper
					loop
						-- check for insertion here
						-- we always have a reference node, so index must fit
						if l_list_copy.index = l_mods_arr[i].branch_id then
							l_target := l_mods_arr[i].new_transformable.target_node
							if l_mods_arr[i].is_insert_after then
								l_list_copy.put_right(l_target)
								shift_after_insert(l_mods_arr, l_list_copy.index+1)
							else -- insert before
								l_list_copy.put_left(l_target)
								shift_after_insert(l_mods_arr, l_list_copy.index)
							end
							l_changed_items.extend (l_target)
							i:=i+1
						else
							l_list_copy.forth
						end
					end
				end

				-- second pass, process and check for deletion/replacement
				from
					l_list_copy.start
					l_changed_items.compare_references
				until
					l_list_copy.after
				loop
					if l_changed_items.has (l_list_copy.item) then
						-- don't do operations on new nodes$
						replacement_disabled := true
						process_child(l_list_copy.item)
						replacement_disabled := false
					elseif not attached del_hash.item(l_list_copy.item.path) then
						-- don't delete, replace eventually
						process_child (l_list_copy.item)
					else
						-- else don't print, i.e. delete	
					end

					l_list_copy.forth
				end
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
