note
	description: "Summary description for {AFX_FEATURE_AST_STRUCTURE_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FEATURE_AST_STRUCTURE_NODE

inherit
	AFX_AST_STRUCTURE_NODE
		redefine
			is_feature_node
		end

create
	make

feature -- Access

	first_breakpoint_slot_number: INTEGER
			-- First breakpoint slot number in `feature_''s body
			-- Does not include slots for precondition/postconditions.

	last_breakpoint_slot_number: INTEGER
			-- Last breakpoint slot number in `feature_''s body
			-- Does not include slots for precondition/postconditions.

	surrounding_instruction (a_bpslot: INTEGER): detachable AFX_AST_STRUCTURE_NODE
			-- Instruction node at or surrounding `a_bpslot' in case if `a_bpslot' is not associated
			-- with an instruction, for example, stop condition in a loop.
			-- Void if no such instruction node is found.
		require
			a_bpslot_positive: a_bpslot > 0
		local
			l_node: detachable AFX_AST_STRUCTURE_NODE
		do
			l_node := node_at_break_point_internal (Current, a_bpslot)
			if l_node /= Void then
				from until
					l_node = Void or else l_node.is_instruction
				loop
					l_node := l_node.parent
				end
				Result := l_node
			end
		ensure
			good_result: Result /= Void implies Result.is_instruction
		end

	instructions_in_block (a_bpslot: INTEGER): LINKED_LIST [AFX_AST_STRUCTURE_NODE]
			-- Instructions that are in the same basic block including `a_bpslot'
			-- Empty list means no such instruction is found.			
		do
			create Result.make
			if attached {AFX_AST_STRUCTURE_NODE} surrounding_instruction (a_bpslot) as l_node then
				if attached {LINKED_LIST [AFX_AST_STRUCTURE_NODE]} l_node.sibling as l_sibling then
					l_sibling.do_if (
						agent Result.extend,
						agent (a_node: AFX_AST_STRUCTURE_NODE): BOOLEAN
							do
								Result := a_node.is_instruction
							end)
				end
			end
		ensure
			only_instruction_in_result:
				Result.for_all (agent (n: AFX_AST_STRUCTURE_NODE): BOOLEAN do Result := n.is_instruction end)
		end

	instructions_in_block_as (a_node: AFX_AST_STRUCTURE_NODE): LINKED_LIST [AFX_AST_STRUCTURE_NODE]
			-- Instructions that are in the same basic block as `a_node'. Result may include `a_node' itself.	
			-- Empty list means no such instruction is found.
		do
			create Result.make
			if attached {LINKED_LIST [AFX_AST_STRUCTURE_NODE]} a_node.sibling as l_sibling then
				l_sibling.do_if (
					agent Result.extend,
					agent (n: AFX_AST_STRUCTURE_NODE): BOOLEAN
						do
							Result := n.is_instruction
						end)
			end
		ensure
			only_instruction_in_result:
				Result.for_all (agent (n: AFX_AST_STRUCTURE_NODE): BOOLEAN do Result := n.is_instruction end)
		end

	node_at_break_point (a_bpslot: INTEGER): detachable AFX_AST_STRUCTURE_NODE
			-- Node in Current at break point `a_bpslot'.
			-- Void if there is no such node.
		require
			a_bpslot_positive: a_bpslot > 0
		do
			Result := node_at_break_point_internal (Current, a_bpslot)
		end

	node_at_break_point_internal (a_parent: AFX_AST_STRUCTURE_NODE; a_bpslot: INTEGER): detachable AFX_AST_STRUCTURE_NODE
			-- Node in `a_node' at break point `a_bpslot'.
			-- Void if there is no such node.
		require
			a_bpslot_positive: a_bpslot > 0
		local
			l_cursor: CURSOR
			l_trunks: LINKED_LIST [LINKED_LIST [AFX_AST_STRUCTURE_NODE]]
			l_children: LINKED_LIST [AFX_AST_STRUCTURE_NODE]
			l_cur2: CURSOR
		do
			if a_parent.breakpoint_slot = a_bpslot then
				Result := a_parent
			else
					-- Recursively check if some child node has break point `a_bpslot'.
				l_trunks := a_parent.children
				l_cursor := l_trunks.cursor
				from
					l_trunks.start
				until
					l_trunks.after or else Result /= Void
				loop
					l_children := l_trunks.item_for_iteration
					l_cur2 := l_children.cursor
					from
						l_children.start
					until
						l_children.after or else Result /= Void
					loop
						Result := node_at_break_point_internal (l_children.item_for_iteration, a_bpslot)
						l_children.forth
					end
					l_children.go_to (l_cur2)
					l_trunks.forth
				end
				l_trunks.go_to (l_cursor)
			end
		end

	next_break_point (a_bpslot: INTEGER): INTEGER
			-- The break point next to `a_bpslot' in `a_node' in the control flow graph
			-- 0 means that no such break point exists.
		do
			if attached {AFX_AST_STRUCTURE_NODE} node_at_break_point_internal (Current, a_bpslot) as l_node then
				Result := next_break_point_internal (l_node)
			end
		end

	first_node_with_break_point (a_node: AFX_AST_STRUCTURE_NODE): detachable AFX_AST_STRUCTURE_NODE
			-- First node in `a_node' (possibly is `a_node') which has an associated break point.
			-- Void if no such node is found.
		local
			l_cursor: CURSOR
			l_trunks: LINKED_LIST [LINKED_LIST [AFX_AST_STRUCTURE_NODE]]
			l_children: LINKED_LIST [AFX_AST_STRUCTURE_NODE]
			l_cur2: CURSOR
		do
			if a_node.has_breakpoint then
				Result := a_node
			else
				l_trunks := a_node.children
				l_cursor := l_trunks.cursor
				from
					l_trunks.start
				until
					l_trunks.after or else Result /= Void
				loop
					l_children := l_trunks.item_for_iteration
					l_cur2 := l_children.cursor
					from
						l_children.start
					until
						l_children.after or else Result /= Void
					loop
						Result := first_node_with_break_point (l_children.item_for_iteration)
						l_children.forth
					end
					l_children.go_to (l_cur2)
					l_trunks.forth
				end
				l_trunks.go_to (l_cursor)

			end
		end

	relevant_ast (a_bpslot: INTEGER): detachable AST_EIFFEL
			-- Return the AST part where `a_bpslot' can anchor at
			-- For if-statement, it is the condition part, for loop stop condition, it is the stop condition part.
			-- For inspect-statement, it is the switch part.
			-- For other ASTs, it is the AST itself.
			-- Void means no such AST is found.
		do
			if attached {AFX_AST_STRUCTURE_NODE} node_at_break_point_internal (Current, a_bpslot) as l_node then
				if attached {IF_AS} l_node.ast.ast as l_if then
					Result := l_if.condition
				elseif attached {ELSIF_AS} l_node.ast.ast as l_elsif then
					Result := l_elsif.expr
				elseif attached {INSPECT_AS} l_node.ast.ast as l_inspect then
					Result := l_inspect.switch
				end
			end
		end

feature -- Status report

	is_feature_node: BOOLEAN = True
			-- Does current represent a feature node?
			-- This means that `ast' is the DO_AS node for `feature_'

feature -- Setting

	set_first_breakpoint_slot_number (i: INTEGER)
			-- Set `first_breakpoint_slot_number' with `i'.
		do
			first_breakpoint_slot_number := i
		ensure
			first_breakpoint_slot_number_set: first_breakpoint_slot_number = i
		end

	set_last_breakpoint_slot_number (i: INTEGER)
			-- Set `last_breakpoint_slot_number' with `i'.
		do
			last_breakpoint_slot_number := i
		ensure
			last_breakpoint_slot_number_set: last_breakpoint_slot_number = i
		end

feature{NONE} -- Implementation

	next_break_point_internal (a_node: AFX_AST_STRUCTURE_NODE): INTEGER
			-- The break point next to `a_node' in the control flow graph
			-- 0 means that no such break point exists.
		local
			l_node: detachable AFX_AST_STRUCTURE_NODE
			l_cursor: CURSOR
			l_self_found: BOOLEAN
		do
			l_node := a_node
			if l_node /= Void then
				if attached {LINKED_LIST [AFX_AST_STRUCTURE_NODE]} l_node.sibling as l_sibling then
					l_cursor := l_sibling.cursor
					from
						l_sibling.start
					until
						l_sibling.after or else Result > 0
					loop
						if l_self_found then
							if attached {AFX_AST_STRUCTURE_NODE} first_node_with_break_point (l_sibling.item_for_iteration) as l_node_with_bp then
								Result := l_node_with_bp.breakpoint_slot
							end
						else
							l_self_found := l_sibling.item_for_iteration = l_node
						end
						l_sibling.forth
					end
					l_sibling.go_to (l_cursor)

					 	-- No such break point is found in the surrounding basic block of `a_node',
					 	-- Try to search parent of `a_node'.
					if Result = 0 and then attached a_node.parent as l_parent then
						Result := next_break_point_internal (l_parent)
					end
				end
			end
		end

invariant
	not_has_breakpoint: not has_breakpoint
	not_have_parent: parent = Void

end
