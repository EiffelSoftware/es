note
	description: "Control flow graph builder"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_CFG_BUILDER

inherit
	AST_ITERATOR
		redefine
			process_if_as,
			process_inspect_as,
			process_loop_as
		end

	EPA_CFG_UTILITY

	ETR_SHARED_TOOLS

	ETR_SHARED_TRANSFORMABLE_FACTORY

	ETR_SHARED_OPERATORS

feature -- Access

	last_control_flow_graph: EPA_CONTROL_FLOW_GRAPH
			-- Last control flow graph built by `build_control_flow_graph'

feature -- Basic operations

	build (a_context_class: CLASS_C; a_feature: FEATURE_I)
			-- Build control flow graph for `a_feature' in context of `a_context_class',
			-- make result available in `last_control_flow_graph'.
		local
			l_do_as: detachable DO_AS
			l_compound: detachable EIFFEL_LIST [INSTRUCTION_AS]
			l_class_context: ETR_CLASS_CONTEXT
			l_context: ETR_FEATURE_CONTEXT
			l_transformable: ETR_TRANSFORMABLE
			l_start_node: EPA_AUXILARY_BLOCK
			l_end_node: EPA_AUXILARY_BLOCK
		do
			feature_ := a_feature
			context_class := a_context_class
			written_class := feature_.written_class

			create last_control_flow_graph.make
			create node_stack.make

				-- Process only if `a_feature' has body.
			if attached {BODY_AS} a_feature.body.body as l_body then
				if attached {ROUTINE_AS} l_body.content as l_routine then
					if attached {DO_AS} l_routine.routine_body as l_do then
							-- Use Current visitor to iterate through the feature body,
							-- and insert nodes and edges into `last_control_flow_graph'.
						l_compound := l_do.compound
					end
				end
			end

				-- Duplicate ASTs.
			create l_class_context.make (a_context_class)
			create l_context.make (a_feature, l_class_context)
			create l_transformable.make_from_ast (l_compound, l_context, True)

				-- Visit duplicated AST to build up CFG.
			process_feature_body (l_transformable.to_ast)
			check node_stack.count <= 1 end
			if node_stack.count = 1 then
				last_control_flow_graph.set_start_node (node_stack.item.start_node)
				last_control_flow_graph.set_end_node (node_stack.item.end_node)
			else
				l_start_node := new_auxilary_node
				last_control_flow_graph.extend_node (l_start_node)
				last_control_flow_graph.set_start_node (l_start_node)
				last_control_flow_graph.set_end_node (l_start_node)
			end

				-- Remove auxilary nodes when not needed.
			if not is_auxilary_nodes_created then
				remove_auxilary_nodes (last_control_flow_graph)
			end
		end

feature -- Status report

	is_single_instruction_block: BOOLEAN
			-- Should a basic block be created for every
			-- single instruction?
			-- If False, all instruction in the same basic block will
			-- be in a basic block.
			-- Default: False

	is_renaming_resolved: BOOLEAN
			-- Should feature renaming be resolved?
			-- If True, the AST nodes included in the generated CFG
			-- include only final feature names.
			-- Default: False

	is_auxilary_nodes_created: BOOLEAN
			-- Should auxilary nodes be inserted into the CFG?
			-- Auxilary nodes are dummy nodes which do not represent any AST,
			-- instead they usually inserted to make sure that every branching
			-- instruction has a single exit point.
			-- Default: False

feature -- Setting

	set_is_single_instruction_block (b: BOOLEAN)
			-- Set `is_single_instruction_block' with `b'.
		do
			is_single_instruction_block := b
		ensure
			is_single_instruction_block_set: is_single_instruction_block = b
		end

	set_is_renaming_resolved (b: BOOLEAN)
			-- Set `is_renaming_resolved' with `b'.
		do
			is_renaming_resolved := b
		ensure
			is_renaming_resolved_set: is_renaming_resolved = b
		end

	set_is_auxilary_nodes_created (b: BOOLEAN)
			-- Set `is_auxilary_nodes_created' with `b'.
		do
			is_auxilary_nodes_created := b
		ensure
			is_auxilary_nodes_created_set: is_auxilary_nodes_created = b
		end

feature{NONE} -- Implementation/Visit

	context_class: CLASS_C
			-- Context class of `feature_'

	written_class: CLASS_C
			-- Written class of `feature_'

	feature_: FEATURE_I
			-- Feature whose CFG is being built

	next_basic_block_id: INTEGER
			-- ID for next created basic block
		do
			Result := basic_block_id_cell.item
			basic_block_id_cell.put (Result + 1)
		end

	basic_block_id_cell: CELL [INTEGER]
			-- Cell to store last used basic block ID
		once
			create Result.put (1)
		end

	node_stack: LINKED_STACK [TUPLE [start_node: EPA_BASIC_BLOCK; end_node: EPA_BASIC_BLOCK]]
			-- Stack for start and end node of created branches.

feature{NONE} -- Implementation/Visit

	process_feature_body (l_as: detachable AST_EIFFEL)
		do
			if attached {EIFFEL_LIST [INSTRUCTION_AS]} l_as as l_compound then
				node_stack.extend (extended_instructions (l_compound))
			end
		end

	process_if_as (l_as: IF_AS)
		local
			l_branches: ARRAYED_LIST [TUPLE [condition: detachable EPA_BRANCHING_BLOCK; instructions: ARRAYED_LIST [INSTRUCTION_AS]]]
			l_cursor: CURSOR
		do
				-- Collect the list of branches.
			create l_branches.make (5)
			l_branches.extend ([new_if_branching_node (l_as.condition), l_as.compound])
			if attached {EIFFEL_LIST [ELSIF_AS]} l_as.elsif_list as l_elsif then
				l_cursor := l_elsif.cursor
				from
					l_elsif.start
				until
					l_elsif.after
				loop
					l_branches.extend ([new_if_branching_node (l_elsif.item_for_iteration.expr), l_elsif.item_for_iteration.compound])
					l_elsif.forth
				end
				l_elsif.go_to (l_cursor)
			end
			l_branches.extend ([Void, l_as.else_part])

			node_stack.extend (extended_branches (l_branches))
		end

	process_inspect_as (l_as: INSPECT_AS)
		local
			l_branches: ARRAYED_LIST [TUPLE [condition: detachable EPA_BRANCHING_BLOCK; instructions: ARRAYED_LIST [INSTRUCTION_AS]]]
			l_cursor: CURSOR
		do
				-- Collect the list of branches.
			create l_branches.make (5)
			if attached{EIFFEL_LIST [CASE_AS]} l_as.case_list as l_cases and then not l_cases.is_empty then
				create l_branches.make (l_cases.count + 1)
				l_cursor := l_cases.cursor
				from
					l_cases.start
				until
					l_cases.after
				loop
					l_branches.extend ([new_inspect_branching_node (l_as.switch, l_cases.item_for_iteration.interval), l_cases.item_for_iteration.compound])
					l_cases.forth
				end
				l_cases.go_to (l_cursor)
				l_branches.extend ([Void, l_as.else_part])
				node_stack.extend (extended_branches (l_branches))
			else
					-- This inspect is not a branching instruction, treat it as a sequential instruction.
				node_stack.extend (extended_instructions (l_as.else_part))
			end
		end

	process_loop_as (l_as: LOOP_AS)
		local
			l_nodes: TUPLE [start_node: EPA_BASIC_BLOCK; end_node: EPA_BASIC_BLOCK]
			l_final_snode: EPA_BASIC_BLOCK
			l_final_enode: EPA_BASIC_BLOCK
			l_block: EPA_INSTRUCTION_BLOCK
			l_branching_node: EPA_LOOP_BRANCHING_BLOCK
			l_sequential_edge: EPA_SEQUENTIAL_CFG_EDGE
			l_false_edge: EPA_FALSE_CFG_EDGE
			l_true_edge: EPA_TRUE_CFG_EDGE
			l_auxilary_node: EPA_AUXILARY_BLOCK
			l_variant_node: EPA_BASIC_BLOCK
		do
				-- Process from part.
			l_nodes := extended_instructions (l_as.from_part)
			l_final_snode := l_nodes.start_node
			l_final_enode := l_nodes.end_node

				-- Process loop invariant part.
			if attached {EIFFEL_LIST [TAGGED_AS]} l_as.invariant_part as l_invariants then
				l_block := new_invariant_node (l_invariants)
				last_control_flow_graph.extend_node (l_block)
				create l_sequential_edge.make (l_final_enode, l_block)
				last_control_flow_graph.extend_out_edge (l_final_enode, l_block, l_sequential_edge)
				l_final_enode := l_block
			end

				-- Process exit condition.
			l_branching_node := new_loop_branching_node (l_as.stop)
			last_control_flow_graph.extend_node (l_branching_node)
			create l_sequential_edge.make (l_final_enode, l_branching_node)
			last_control_flow_graph.extend_out_edge (l_final_enode, l_branching_node, l_sequential_edge)
			l_final_enode := l_branching_node

				-- Process loop body.
			l_nodes := extended_instructions (l_as.compound)
			create l_false_edge.make (l_branching_node, l_nodes.start_node)
			last_control_flow_graph.extend_out_edge (l_branching_node, l_nodes.start_node, l_false_edge)
			l_final_enode := l_nodes.end_node

				-- Process loop variant.
			if attached {VARIANT_AS} l_as.variant_part as l_variant then
				l_variant_node := new_variant_node (l_variant)
				last_control_flow_graph.extend_node (l_variant_node)
				create l_sequential_edge.make (l_final_enode, l_variant_node)
				last_control_flow_graph.extend_out_edge (l_final_enode, l_variant_node, l_sequential_edge)
				l_final_enode := l_variant_node
			end

			create l_sequential_edge.make (l_final_enode, l_branching_node)
			last_control_flow_graph.extend_out_edge (l_final_enode, l_branching_node, l_sequential_edge)

				-- Added an auxilary
			l_auxilary_node := new_auxilary_node
			last_control_flow_graph.extend_node (l_auxilary_node)
			create l_true_edge.make (l_branching_node, l_auxilary_node)
			last_control_flow_graph.extend_out_edge (l_branching_node, l_auxilary_node, l_true_edge)
			l_final_enode := l_auxilary_node

			node_stack.extend ([l_final_snode, l_final_enode])
		end

feature{NONE} -- Implementation/Visit

	new_variant_node (a_variant: VARIANT_AS): EPA_INSTRUCTION_BLOCK
			-- New block for loop variant `a_variant'
		do
			create Result.make_with_ast (next_basic_block_id, a_variant)
			Result.set_feature_ (feature_)
			Result.set_class_ (context_class)
			Result.set_written_class (written_class)
		end

	new_instruction_node (a_instructions: ARRAYED_LIST [INSTRUCTION_AS]): EPA_INSTRUCTION_BLOCK
			-- New instruction block containing `a_instructions'.
		do
			create Result.make_with_ast_list (next_basic_block_id, a_instructions)
			Result.set_feature_ (feature_)
			Result.set_class_ (context_class)
			Result.set_written_class (written_class)
		end

	new_if_branching_node (a_expr: EXPR_AS): EPA_IF_BRANCHING_BLOCK
			-- New branching node for if-statement containing `a_expr'
		do
			create Result.make (next_basic_block_id, a_expr)
			Result.set_feature_ (feature_)
			Result.set_class_ (context_class)
			Result.set_written_class (written_class)
		end

	new_loop_branching_node (a_expr: EXPR_AS): EPA_LOOP_BRANCHING_BLOCK
			-- New branching node for loop exit condition `a_expr'
		do
			create Result.make (next_basic_block_id, a_expr)
			Result.set_feature_ (feature_)
			Result.set_class_ (context_class)
			Result.set_written_class (written_class)
		end

	new_inspect_branching_node (a_switch: EXPR_AS; a_internvals: ARRAYED_LIST [INTERVAL_AS]): EPA_INSPECT_BRANCHING_BLOCK
			-- New branching node for inspect-statement containing `a_switch' and `a_internvals'
		do
			create Result.make (next_basic_block_id, a_switch, a_internvals)
			Result.set_feature_ (feature_)
			Result.set_class_ (context_class)
			Result.set_written_class (written_class)
		end

	new_auxilary_node: EPA_AUXILARY_BLOCK
			-- New auxilary node
		do
			create Result.make (next_basic_block_id)
			Result.set_feature_ (feature_)
			Result.set_class_ (context_class)
			Result.set_written_class (written_class)
		end

	new_invariant_node (a_invariants: EIFFEL_LIST [TAGGED_AS]): EPA_INSTRUCTION_BLOCK
			-- New node for loop invariant `a_invariants'.
		do
			create Result.make_with_ast (next_basic_block_id, a_invariants)
		end

	extended_branches (a_branches: ARRAYED_LIST [TUPLE [condition: detachable EPA_BRANCHING_BLOCK; instructions: ARRAYED_LIST [INSTRUCTION_AS]]]): TUPLE [start_block: EPA_BASIC_BLOCK; end_block: EPA_BASIC_BLOCK]
			-- Extend `a_branches' into `last_control_flow_graph', return the first and the last node of then added branch.
			-- Note: This routine violates Command and Query Separation Principle.
		require
			last_branch_valid: a_branches.last.condition = Void
		local
			l_snode: EPA_BASIC_BLOCK
			l_enode: EPA_BASIC_BLOCK
			l_nodes: TUPLE [start_block: EPA_BASIC_BLOCK; end_block: EPA_BASIC_BLOCK]
			l_data: like a_branches
			l_true_edge: EPA_TRUE_CFG_EDGE
			l_false_edge: EPA_FALSE_CFG_EDGE
			l_seq_edge: EPA_SEQUENTIAL_CFG_EDGE
		do
			if a_branches.count = 1 then
				l_nodes := extended_instructions (a_branches.first.instructions)
				l_snode := l_nodes.start_block
				l_enode := l_nodes.end_block
			else
					-- Insert start node and end node of current branch in CFG.
				l_snode := a_branches.first.condition
				l_enode := new_auxilary_node

				last_control_flow_graph.extend_node (l_snode)
				last_control_flow_graph.extend_node (l_enode)

					-- Process true-branch.
				l_nodes := extended_instructions (a_branches.first.instructions)
				create l_true_edge.make (l_snode, l_nodes.start_block)
				last_control_flow_graph.extend_out_edge (l_snode, l_nodes.start_block, l_true_edge)
				create l_seq_edge.make (l_nodes.end_block, l_enode)
				last_control_flow_graph.extend_out_edge (l_nodes.end_block, l_enode, l_seq_edge)

					-- Recursively process false-branches.
				a_branches.go_i_th (2)
				l_nodes := extended_branches (a_branches.duplicate (a_branches.count - 1))
				create l_false_edge.make (l_snode, l_nodes.start_block)
				last_control_flow_graph.extend_out_edge (l_snode, l_nodes.start_block, l_false_edge)
				create l_seq_edge.make (l_nodes.end_block, l_enode)
				last_control_flow_graph.extend_out_edge (l_nodes.end_block, l_enode, l_seq_edge)
			end
			Result := [l_snode, l_enode]
		end

	extended_instructions (a_instructions: detachable ARRAYED_LIST [INSTRUCTION_AS]): TUPLE [first_node: EPA_BASIC_BLOCK; last_node: EPA_BASIC_BLOCK]
			-- Extend basic blocks containing `a_list', and return the first and the last node representing those extended blocks.
			-- Note: This routine violates Command and Query Separation Principle.
		local
			l_block: EPA_BASIC_BLOCK
			l_snode: detachable EPA_BASIC_BLOCK
			l_enode: detachable EPA_BASIC_BLOCK
			l_instr_sections: ARRAYED_LIST [ARRAYED_LIST [INSTRUCTION_AS]]
			l_cursor: CURSOR
			l_instrs: ARRAYED_LIST [INSTRUCTION_AS]
			l_instr: INSTRUCTION_AS
			l_is_single_instruction_block: BOOLEAN
			l_final_start_node: EPA_BASIC_BLOCK
			l_final_end_node: EPA_BASIC_BLOCK
			l_last_node: detachable EPA_BASIC_BLOCK
			l_edge: EPA_SEQUENTIAL_CFG_EDGE
		do
			if a_instructions = Void or else a_instructions.is_empty then
					-- Create a dummy node for empty block.
				l_block := new_auxilary_node
				last_control_flow_graph.extend_node (l_block)
				Result := [l_block, l_block]
			else
					-- Store instructions into sections: every branching instruction in its own section,
					-- depending on `is_single_instruciton_block', several sequential instructions are in
					-- one section or every sequential instruction in its own section.
				l_is_single_instruction_block := is_single_instruction_block
				create l_instr_sections.make (2)
				create l_instrs.make (2)
				l_cursor := a_instructions.cursor
				from
					a_instructions.start
				until
					a_instructions.after
				loop
					l_instr := a_instructions.item_for_iteration
					if is_branching_instruction (l_instr) then
						if not l_instrs.is_empty then
							l_instr_sections.extend (l_instrs)
						end
						create l_instrs.make (2)
						l_instrs.extend (l_instr)
						l_instr_sections.extend (l_instrs)
						create l_instrs.make (2)
					else
						l_instrs.extend (l_instr)
						if l_is_single_instruction_block then
							l_instr_sections.extend (l_instrs)
							create l_instrs.make (2)
						end
					end
					a_instructions.forth
				end
				if not l_instrs.is_empty then
					l_instr_sections.extend (l_instrs)
				end
				a_instructions.go_to (l_cursor)

					-- Process instruction sections.
				from
					l_instr_sections.start
				until
					l_instr_sections.after
				loop
					l_instrs := l_instr_sections.item_for_iteration
					if l_instrs.count = 1 and then is_branching_instruction (l_instrs.first) then
							-- Create a branching node.
						l_instrs.first.process (Current)
						l_snode := node_stack.item.start_node
						l_enode := node_stack.item.end_node
						node_stack.remove
					else
						l_block := new_instruction_node (l_instrs)
						last_control_flow_graph.extend_node (l_block)
						l_snode := l_block
						l_enode := l_block
					end
						-- Create an edge connecting two last created blocks.
					if l_last_node = Void then
						l_last_node := l_enode
					else
						create l_edge.make (l_last_node, l_snode)
						last_control_flow_graph.extend_out_edge (l_last_node, l_snode, l_edge)
						l_last_node := l_enode
					end

						-- Set final start and end nodes of the whole instruction list.
					if l_final_start_node = Void then
						l_final_start_node := l_snode
					end
					l_final_end_node := l_enode
					l_instr_sections.forth
				end

				Result := [l_final_start_node, l_final_end_node]
			end
		ensure
			result_attached: Result /= Void
		end

	remove_auxilary_nodes (a_graph: like last_control_flow_graph)
			-- Remove auxilary nodes from `a_graph'.
		local
			l_nodes: DS_HASH_SET [EPA_BASIC_BLOCK]
			l_node: EPA_BASIC_BLOCK
		do
				-- Remove auxilary node.
			l_nodes := a_graph.node_set
			from
				l_nodes.start
			until
				l_nodes.after
			loop
				l_node := l_nodes.item_for_iteration
				if l_node.is_auxilary and then a_graph.node (l_node).successors.count = 1 then
					a_graph.merge_nodes (l_node, a_graph.node (l_node).successors.first.data)
				end
				l_nodes.forth
			end

				-- Remove circular edges in remaining auxilary node.
			l_nodes := a_graph.node_set
			from
				l_nodes.start
			until
				l_nodes.after
			loop
				l_node := l_nodes.item_for_iteration
				if l_node.is_auxilary then
					a_graph.out_edges_with_end_node (l_node, l_node).do_all (agent a_graph.remove_out_edges (l_node, ?))
				end
				l_nodes.forth
			end
		end

end
