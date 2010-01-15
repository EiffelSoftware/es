note
	description: "Generates a use-define chain of an instruction-list in a feature-context"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_USE_DEF_CHAIN_GENERATOR
inherit
	AST_ITERATOR
		redefine
--			process_case_as,
--			process_inspect_as,
			process_instr_call_as,
			process_assign_as,
			process_creation_as,
			process_if_as,
--			process_elseif_as,
--			process_loop_as,
			process_nested_as,
			process_access_feat_as,
			process_expr_call_as
--			process_id_as
		end
create
	make

feature -- Access

	var_def: ARRAY[HASH_TABLE[INTEGER,STRING]]
		-- var_def[i][var_name] = j -> in instruction i var_name was defined in instruction j

	vars_used: ARRAY[LIST[STRING]]
		-- vars_used[i] = {a,b} -> in instruction i vars a and b were used

	block_start_position, block_end_position: INTEGER

feature {NONE} -- Implementation

	context: ETR_FEATURE_CONTEXT
		-- which feature are we in

	current_instruction: INTEGER
		-- number of instruction currently processed

	current_var_defs: HASH_TABLE[INTEGER,STRING]

	var_def_list: LINKED_LIST[like current_var_defs]
		-- temporary list-form of var_def

	var_used_list: LINKED_LIST[LIST[STRING]]
		-- temporary list-form of var_used

	temp_vars_used: LINKED_LIST[STRING]
		-- currently used variables

	last_was_unqualified: BOOLEAN
		-- are we in an unqualified call
		-- i.e. local, argument, class feature

	next_local_name: STRING
		-- name of next local

	is_next_call_local(a_call: CALL_AS): BOOLEAN
			-- is `a_call' a direct access to a local variable?
		do
			if attached {ACCESS_ID_AS}a_call as l_acc_id then
				if attached context.local_by_name[l_acc_id.access_name] then
					next_local_name := l_acc_id.access_name
					Result := True
				end
			end
		end

	intersection_merge_definitions (a_defs: LIST[like current_var_defs]): like current_var_defs
			-- merges `a_defs' into a new table
		local
			l_first: like current_var_defs
			l_exists: BOOLEAN
			l_lowest: INTEGER
		do
			create Result.make (20)

			if attached a_defs.first then
				l_first := a_defs.first

				-- loop over first item
				from
					l_first.start
				until
					l_first.after
				loop
					-- check if this item exists in all others
					from
						l_exists := True
						l_lowest := l_first.item_for_iteration
						a_defs.go_i_th (2)
					until
						a_defs.after or not l_exists
					loop
						l_exists := a_defs.item.has (l_first.key_for_iteration)
						if l_first.item_for_iteration < l_lowest then
							l_lowest := l_first.item_for_iteration
						end
						a_defs.forth
					end

					if l_exists then
						Result.extend (l_lowest, l_first.key_for_iteration)
					end

					l_first.forth
				end
			end
		end

	start_path, end_path: AST_PATH

	check_ref_paths(l_as: AST_EIFFEL)
		do
			if start_path.is_equal (l_as.path) then
				block_start_position := current_instruction
			end
			if end_path.is_equal (l_as.path) then
				block_end_position := current_instruction
			end
		end

feature {NONE} -- creation

	make(a_context: like context)
			-- make with `a_output' and `a_context'
		do
			context := a_context
		end

feature -- Operation

	generate_chain(a_ast: AST_EIFFEL; a_start_path: like start_path; a_end_path: like end_path)
			-- generate a chain starting from `a_ast'
		do
			start_path := a_start_path
			end_path := a_end_path

			current_instruction := 0

			-- create internal structures
			create var_def_list.make
			create var_used_list.make
			create current_var_defs.make(20)

			a_ast.process (Current)

			-- convert for external access
			from
				create vars_used.make (1, var_used_list.count)
				var_used_list.start
			until
				var_used_list.after
			loop
				vars_used[var_used_list.index] := var_used_list.item
				var_used_list.forth
			end

			from
				create var_def.make (1, var_def_list.count)
				var_def_list.start
			until
				var_def_list.after
			loop
				var_def[var_def_list.index] := var_def_list.item
				var_def_list.forth
			end
		end

feature {AST_EIFFEL} -- Roundtrip

--	process_case_as (l_as: CASE_AS)
--		do
--			current_instruction := current_instruction+1
--			-- store defined variables for this instruction
--			var_def_list.extend (current_var_defs.twin)

--			-- clear used variables
--			create temp_vars_used.make
--			-- and gather new ones			
--			safe_process(l_as.interval)
--			safe_process(l_as.compound)
--			-- store them
--			var_used_list.extend (temp_vars_used)
--			-- invalidate for debugging
--			temp_vars_used := void
--		end

--	process_inspect_as (l_as: INSPECT_AS)
--		do
--			current_instruction := current_instruction+1
--			-- store defined variables for this instruction
--			var_def_list.extend (current_var_defs.twin)

--			-- clear used variables
--			create temp_vars_used.make
--			-- and gather new ones			
--			safe_process(l_as.switch)
--			-- store them
--			var_used_list.extend (temp_vars_used)
--			-- invalidate for debugging
--			temp_vars_used := void

--			safe_process(l_as.case_list)
--			safe_process(l_as.else_part)
--		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
			current_instruction := current_instruction+1
			check_ref_paths(l_as)
			last_was_unqualified := true
			-- store defined variables for this instruction
			var_def_list.extend (current_var_defs.twin)

			-- clear used variables
			create temp_vars_used.make
			-- and gather new ones			
			safe_process(l_as.call)
			-- store them
			var_used_list.extend (temp_vars_used)
			-- invalidate for debugging
			temp_vars_used := void
		end

	process_expr_call_as (l_as: EXPR_CALL_AS)
		do
			last_was_unqualified := true
			safe_process (l_as.call)
		end

--	process_id_as (l_as: ID_AS)
--		do
--			-- if were in an unqualified call
--			-- the id might be a local/argument that is used
--			if last_was_unqualified then
--				if attached context.arg_by_name[l_as.name] or attached context.local_by_name[l_as.name] then
--					-- local or argument is being used!
--					temp_vars_used.extend (l_as.name)
--				end
--			end
--		end

	process_assign_as (l_as: ASSIGN_AS)
		local
			l_target_is_local: BOOLEAN
		do
			current_instruction := current_instruction+1
			check_ref_paths(l_as)

			-- if next is a local then add to variable definition
			if is_next_call_local (l_as.target) then
				-- in current_instruction next_local_name was defined
				current_var_defs.force (current_instruction, next_local_name)
				l_target_is_local := true
			end

			-- store defined variables for this instruction
			var_def_list.extend (current_var_defs.twin)

			-- clear used variables
			create temp_vars_used.make
			-- and gather new ones
			if not l_target_is_local then
				safe_process(l_as.target)
			end

			safe_process(l_as.source)
			-- store them
			var_used_list.extend (temp_vars_used)

			-- invalidate for debugging
			temp_vars_used := void
		end

	process_creation_as (l_as: CREATION_AS)
		do
			current_instruction := current_instruction+1
			check_ref_paths(l_as)
			-- store defined variables for this instruction
			var_def_list.extend (current_var_defs.twin)
			last_was_unqualified := true

			-- clear used variables
			create temp_vars_used.make
			-- and gather new ones			
			safe_process(l_as.type)
			safe_process(l_as.call)
			-- store them
			var_used_list.extend (temp_vars_used)
			-- invalidate for debugging
			temp_vars_used := void
		end

	process_nested_as (l_as: NESTED_AS)
		do
			safe_process (l_as.target)

			last_was_unqualified := false

			safe_process (l_as.message)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			-- if were in an unqualified call
			-- the id might be a local/argument that is used
			if last_was_unqualified then
				if attached context.arg_by_name[l_as.access_name] or attached context.local_by_name[l_as.access_name] then
					-- local or argument is being used!
					temp_vars_used.extend (l_as.access_name)
				end
			end

			safe_process(l_as.parameters)
		end

	process_if_as (l_as: IF_AS)
		local
			l_merge_list: LINKED_LIST[like current_var_defs]
			l_previous_defs, l_if_part_defs, l_else_part_defs: like current_var_defs
		do
			current_instruction := current_instruction+1
			if start_path.is_equal (l_as.path) then
				block_start_position := current_instruction
			end
			-- store defined variables for this instruction
			l_previous_defs := current_var_defs.twin
			var_def_list.extend (l_previous_defs)

			-- clear used variables
			create temp_vars_used.make
			-- and gather new ones			
			safe_process(l_as.condition)
			-- store them
			var_used_list.extend (temp_vars_used)
			-- invalidate for debugging
			temp_vars_used := void

			safe_process(l_as.compound)
			l_if_part_defs := current_var_defs.twin
			current_var_defs := l_previous_defs
			-- for now elsif is not supported!
--			safe_process(l_as.elsif_list)
			safe_process(l_as.else_part)
			l_else_part_defs := current_var_defs

			-- only keep defined variables if they were defined in both branches!
			create l_merge_list.make
			l_merge_list.extend (l_if_part_defs)
			l_merge_list.extend (l_else_part_defs)

			if end_path.is_equal (l_as.path) then
				block_end_position := current_instruction
			end

			current_var_defs := intersection_merge_definitions (l_merge_list)
		end

--	process_elseif_as (l_as: ELSIF_AS)
--		do
--			current_instruction := current_instruction+1
--			-- store defined variables for this instruction
--			var_def_list.extend (current_var_defs.twin)

--			-- clear used variables
--			create temp_vars_used.make
--			-- and gather new ones			
--			safe_process(l_as.expr)
--			-- store them
--			var_used_list.extend (temp_vars_used)
--			-- invalidate for debugging
--			temp_vars_used := void

--			safe_process(l_as.compound)
--		end

--	process_loop_as (l_as: LOOP_AS)
--		do
--			current_instruction := current_instruction+1
--			-- store defined variables for this instruction
--			var_def_list.extend (current_var_defs.twin)
--			-- clear used variables
--			create temp_vars_used.make
--			-- and gather new ones			
--			safe_process(l_as.from_part)
--			-- store them
--			var_used_list.extend (temp_vars_used)
--			-- invalidate for debugging
--			temp_vars_used := void

--			safe_process(l_as.stop)
--			safe_process(l_as.compound)
--		end

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
