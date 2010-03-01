note
	description: "Method extraction: Generates a use-define chain of an instruction-list in a feature-context."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_USE_DEF_CHAIN_GENERATOR
inherit
	AST_ITERATOR
		redefine
			process_inspect_as,
			process_instr_call_as,
			process_assign_as,
			process_creation_as,
			process_if_as,
			process_loop_as,
			process_nested_as,
			process_access_feat_as,
			process_expr_call_as,
			process_result_as,
			process_object_test_as,
			process_assigner_call_as,
			process_tagged_as,
			process_nested_expr_as,
			process_creation_expr_as,
			process_inline_agent_creation_as,
			process_bracket_as
		end
	SHARED_TEXT_ITEMS
		export
			{NONE} all
		end

feature -- Access

	instructions: ARRAY[ETR_DF_INSTR]
			-- Instructions

feature {NONE} -- Implementation (Attributes)

	instr_list: LINKED_LIST[like cur_instr]
			-- Internal structure to store instructions

	cur_instr: ETR_DF_INSTR
			-- Current instruction

	elseif_defs, caselist_defs: LINKED_LIST[like current_var_defs]
			-- Variabels defined in variable-length-branches

	context: ETR_FEATURE_CONTEXT
		-- which feature are we in

	current_instruction: INTEGER
		-- number of instruction currently processed

	current_var_defs: HASH_TABLE[PAIR[INTEGER,INTEGER],STRING]
		-- current variable definitions

	last_was_unqualified: BOOLEAN
		-- are we in an unqualified call
		-- i.e. local, argument, class feature

	next_local_name: STRING
		-- name of next local

feature {NONE} -- Implementation (Features)

	is_next_call_local (a_call: CALL_AS): BOOLEAN
			-- is `a_call' a direct access to a local variable?
		do
			if attached {ACCESS_ID_AS}a_call as l_acc_id then
				if context.has_locals and then attached context.local_by_name[l_acc_id.access_name] then
					next_local_name := l_acc_id.access_name
					Result := True
				end
			elseif attached {RESULT_AS}a_call as l_res then
				next_local_name := ti_result
				Result := True
			end
		end

	union_merge_definitions (a_previous_defs: like current_var_defs; a_defs: LIST[like current_var_defs]): like current_var_defs
			-- merges `a_defs' into a new table
		local
			l_first: like current_var_defs
			l_low, l_high: INTEGER
		do
			create Result.make (20)

			if a_defs.is_empty then
				Result := current_var_defs
			else
				from
					a_defs.start
				until
					a_defs.after
				loop
					from
						a_defs.item.start
					until
						a_defs.item.after
					loop
						if not Result.has(a_defs.item.key_for_iteration) then
							if attached a_previous_defs[a_defs.item.key_for_iteration] as l_prev then
								Result.extend(create {PAIR[INTEGER,INTEGER]}.make(l_prev.first, a_defs.item.item_for_iteration.second), a_defs.item.key_for_iteration)
							else
								Result.extend(a_defs.item.item_for_iteration, a_defs.item.key_for_iteration)
							end
						elseif attached Result[a_defs.item.key_for_iteration] as old_item then
							if old_item.first<a_defs.item.item_for_iteration.first then
								l_low := old_item.first
							else
								l_low := a_defs.item.item_for_iteration.first
							end
							if old_item.second>a_defs.item.item_for_iteration.second then
								l_high := old_item.second
							else
								l_high := a_defs.item.item_for_iteration.second
							end

							if l_low = old_item.first or l_high = old_item.second then
								Result.force(create {PAIR[INTEGER,INTEGER]}.make(l_low, l_high), a_defs.item.key_for_iteration)
							end
						end

						a_defs.item.forth
					end
					a_defs.forth
				end
			end
		end

	process_case_list (l_as: EIFFEL_LIST[CASE_AS])
		local
			l_prev_var_def: like current_var_defs
			l_cursor: INTEGER
		do
			l_prev_var_def := current_var_defs.twin
			from
				l_cursor := l_as.index
				l_as.start
			until
				l_as.after
			loop
				-- restore defined variables
				current_var_defs := l_prev_var_def.twin

				-- process the compound and store defs
				safe_process(l_as.item.compound)
				caselist_defs.extend(current_var_defs)
				l_as.forth
			end
			l_as.go_i_th(l_cursor)
		end

	process_elseif_list (l_as: EIFFEL_LIST[ELSIF_AS])
		local
			l_prev_var_def: like current_var_defs
			l_cursor: INTEGER
		do
			l_prev_var_def := current_var_defs.twin
			from
				l_cursor := l_as.index
				l_as.start
			until
				l_as.after
			loop
				current_instruction := current_instruction+1
				-- restore defined variables
				current_var_defs := l_prev_var_def.twin
				create cur_instr.make (current_instruction, l_as.path, current_var_defs)

				-- and gather new ones			
				safe_process(l_as.item.expr)
				-- store them
				instr_list.extend (cur_instr)

				-- process the compound and store defs
				safe_process(l_as.item.compound)
				elseif_defs.extend(current_var_defs)
				l_as.forth
			end
			l_as.go_i_th(l_cursor)
		end

feature -- Operation

	generate_chain (a_context: like context; a_ast: AST_EIFFEL)
			-- generate a chain starting from `a_ast' in `a_context'
		do
			context := a_context

			-- reset internal state
			current_instruction := 0
			cur_instr := void
			elseif_defs := void
			caselist_defs := void
			last_was_unqualified := false
			next_local_name := void

			-- create internal structures
			create current_var_defs.make(20)
			create instr_list.make

			a_ast.process (Current)

			from
				create instructions.make (1, instr_list.count)
				instr_list.start
			until
				instr_list.after
			loop
				instructions[instr_list.index] := instr_list.item
				instr_list.forth
			end
		ensure
			counts_match: current_instruction = instructions.count
		end

feature {AST_EIFFEL} -- Roundtrip (Branches)

	process_if_as (l_as: IF_AS)
		local
			l_merge_list: LINKED_LIST[like current_var_defs]
			l_previous_defs: like current_var_defs
			l_if_instr: ETR_DF_INSTR
		do
			current_instruction := current_instruction+1

			create cur_instr.make (current_instruction, l_as.path, current_var_defs)
			l_if_instr := cur_instr

			-- and gather new ones			
			safe_process(l_as.condition)
			-- store them
			instr_list.extend (cur_instr)
			-- store defined variables for this instruction
			l_previous_defs := current_var_defs

			create l_merge_list.make

			-- process if part
			if attached l_as.compound then
				current_var_defs := l_previous_defs.twin
				l_as.compound.process (Current)
				l_merge_list.extend (current_var_defs)
			end

			-- process else-if part
			if attached l_as.elsif_list then
				current_var_defs := l_previous_defs.twin
				create elseif_defs.make
				process_elseif_list(l_as.elsif_list)
				l_merge_list.append (elseif_defs)
			end

			-- process else part
			if attached l_as.else_part then
				current_var_defs := l_previous_defs.twin
				l_as.else_part.process (Current)
				l_merge_list.extend (current_var_defs)
			end

			l_if_instr.set_last_contained_id (current_instruction)

			current_var_defs := union_merge_definitions (l_previous_defs, l_merge_list)
		end

	process_loop_as (l_as: LOOP_AS)
		local
			l_merge_list: LINKED_LIST[like current_var_defs]
			l_prev_var_def: like current_var_defs
			l_loop_instr: ETR_DF_INSTR
			l_first_instr: like current_instruction
		do
			l_first_instr := current_instruction+1

			-- first process the from part
			safe_process(l_as.from_part)

			-- now process the loop instruction
			current_instruction := current_instruction+1
			create cur_instr.make (current_instruction, l_as.path, current_var_defs)
			l_loop_instr := cur_instr
			l_loop_instr.set_first_contained_id (l_first_instr)

			safe_process(l_as.stop)
			instr_list.extend (cur_instr)

			-- store for merge
			create l_merge_list.make
			l_prev_var_def := current_var_defs.twin
			l_merge_list.extend (l_prev_var_def.twin)

			safe_process(l_as.compound)

			l_loop_instr.set_last_contained_id (current_instruction)

			l_merge_list.extend (current_var_defs)

			current_var_defs :=  union_merge_definitions (l_prev_var_def, l_merge_list)
		end

	process_inspect_as (l_as: INSPECT_AS)
		local
			l_merge_list: LINKED_LIST[like current_var_defs]
			l_previous_defs: like current_var_defs
			l_inspect_instr: ETR_DF_INSTR
		do
			current_instruction := current_instruction+1

			create cur_instr.make (current_instruction, l_as.path, current_var_defs)
			l_inspect_instr := cur_instr

			-- store defined variables for this instruction
			l_previous_defs := current_var_defs

			-- and gather new ones			
			safe_process(l_as.switch)
			-- store them
			instr_list.extend (cur_instr)

			create l_merge_list.make

			-- process case list part
			if attached l_as.case_list then
				current_var_defs := l_previous_defs.twin
				create caselist_defs.make
				process_case_list(l_as.case_list)
				l_merge_list.append (caselist_defs)
			end

			-- process else part
			if attached l_as.else_part then
				current_var_defs := l_previous_defs.twin
				l_as.else_part.process (Current)
				l_merge_list.extend (current_var_defs)
			end

			l_inspect_instr.set_last_contained_id (current_instruction)

			current_var_defs := union_merge_definitions (l_previous_defs, l_merge_list)
		end

feature {AST_EIFFEL} -- Roundtrip (Definitions)

	process_object_test_as (l_as: OBJECT_TEST_AS)
		do
			if attached l_as.name then
				current_var_defs.force (create {PAIR[INTEGER,INTEGER]}.make(current_instruction,current_instruction), l_as.name.name)
				cur_instr.add_definition (l_as.name.name)
			end
			Precursor(l_as)
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
		local
			l_target_is_local: BOOLEAN
			l_is_array: BOOLEAN
		do
			current_instruction := current_instruction+1
			create cur_instr.make (current_instruction, l_as.path, current_var_defs)

			-- array
			if attached {BRACKET_AS}l_as.target as l_br then
				l_is_array := True

				if attached {EXPR_CALL_AS}l_br.target as l_call and then is_next_call_local (l_call.call) then
					-- in current_instruction next_local_name was defined
					current_var_defs.force (create {PAIR[INTEGER,INTEGER]}.make(current_instruction,current_instruction), next_local_name)
					cur_instr.add_definition (next_local_name)
					l_target_is_local := true
				end
			end

			-- and gather new ones
			if not l_is_array then
				safe_process(l_as.target)
			else
				if attached {BRACKET_AS}l_as.target as l_br then
					if not l_target_is_local then
						safe_process(l_br.target)
					end
					safe_process(l_br.operands)
				end
			end

			safe_process(l_as.source)
			-- store them
			instr_list.extend (cur_instr)
		end

	process_assign_as (l_as: ASSIGN_AS)
		local
			l_target_is_local: BOOLEAN
		do
			current_instruction := current_instruction+1
			create cur_instr.make (current_instruction, l_as.path, current_var_defs)

			-- if next is a local then add to variable definition
			if is_next_call_local (l_as.target) then
				-- in current_instruction next_local_name was defined
				current_var_defs.force (create {PAIR[INTEGER,INTEGER]}.make(current_instruction,current_instruction), next_local_name)
				cur_instr.add_definition (next_local_name)
				l_target_is_local := true
			end

			-- and gather new ones
			if not l_target_is_local then
				safe_process(l_as.target)
			end

			safe_process(l_as.source)
			-- store them
			instr_list.extend (cur_instr)
		end

	process_creation_as (l_as: CREATION_AS)
		local
			l_target_is_local: BOOLEAN
		do
			current_instruction := current_instruction+1

			create cur_instr.make (current_instruction, l_as.path, current_var_defs)

			-- if next is a local then add to variable definition
			if is_next_call_local (l_as.target) then
				-- in current_instruction next_local_name was defined
				current_var_defs.force (create {PAIR[INTEGER,INTEGER]}.make(current_instruction,current_instruction), next_local_name)
				cur_instr.add_definition (next_local_name)
				l_target_is_local := true
			end

			safe_process(l_as.type)

			last_was_unqualified := false
			safe_process(l_as.call)

			-- store them
			instr_list.extend (cur_instr)
		end

feature {AST_EIFFEL} -- Roundtrip (Usage)

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
			current_instruction := current_instruction+1
			create cur_instr.make (current_instruction, l_as.path, current_var_defs)
			last_was_unqualified := true

			-- and gather new ones			
			safe_process(l_as.call)
			-- store them
			instr_list.extend (cur_instr)
		end

	process_expr_call_as (l_as: EXPR_CALL_AS)
		do
			last_was_unqualified := true
			safe_process (l_as.call)
		end

	process_creation_expr_as (l_as: CREATION_EXPR_AS)
		do
			l_as.type.process (Current)
			last_was_unqualified := false
			safe_process (l_as.call)
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS)
		do
			safe_process (l_as.target)

			last_was_unqualified := false

			safe_process (l_as.message)
		end

	process_bracket_as (l_as: BRACKET_AS)
		do
			l_as.target.process (Current)

			last_was_unqualified := true

			l_as.operands.process (Current)

			last_was_unqualified := false
		end

	process_nested_as (l_as: NESTED_AS)
		do
			safe_process (l_as.target)

			last_was_unqualified := false

			safe_process (l_as.message)
		end

	process_result_as (l_as: RESULT_AS)
		do
			-- result is being used
			cur_instr.add_use (ti_result)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			-- if were in an unqualified call
			-- the id might be a local/argument that is used
			if last_was_unqualified then
				if not context.class_context.has_feature_named(l_as.access_name) then
					-- local or argument is being used!
					cur_instr.add_use (l_as.access_name)
				end
			end

			safe_process(l_as.parameters)
		end

feature {AST_EIFFEL} -- Roundtrip (Ignored)

	process_tagged_as (l_as: TAGGED_AS)
		do
			-- don't process
		end

	process_inline_agent_creation_as (l_as: INLINE_AGENT_CREATION_AS)
		do
			-- don't process
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
