note
	description: "Summary description for {AFX_AST_STRUCTURE_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_AST_STRUCTURE_NODE

inherit
	DEBUG_OUTPUT

create
	make

feature{NONE} -- Initialization

	make (a_ast: like ast; a_wclass: like written_class; a_feature: like feature_; a_breakpoint: INTEGER; a_parent: like parent)
			-- Initialize Current.
		require
			a_ast_attached: a_ast /= Void
			a_wclass_attached: a_wclass /= Void
			a_feature_attached: a_feature /= Void
			a_breakpoint_non_negative: a_breakpoint >= 0
		do
			ast := a_ast;
			written_class := a_wclass
			feature_ := a_feature
			breakpoint_slot := a_breakpoint
			parent := a_parent
			create children.make
		end

feature -- Access

	ast: AFX_HASHABLE_AST
			-- AST associated with current node

	breakpoint_slot: INTEGER
			-- 1-based Break point slot associated with current node
			-- 0 means that there is no break point slot associated with current node.

	written_class: CLASS_C
			-- Class where `ast' is written

	feature_: FEATURE_I
			-- Feature where `ast' is from

	parent: detachable like Current
			-- Parent node of Current
			-- Void means there is no parent node. This will happen for ASTs in the out most level in a routine.

	children: LINKED_LIST [LINKED_LIST [like Current]]
			-- Child nodes of current node.
			-- Can be empty.

	sibling: detachable LINKED_LIST [like Current]
			-- Siblings of current.
			-- Elements in `sibling' are in the same basic block as current.
			-- `sibling' also include Current.

	depth: INTEGER
			-- Number of levels of parent
		do
			if attached parent as l_parent then
				Result := l_parent.depth + 1
			else
				Result := 1
			end
		ensure
			result_positive: Result > 0
		end

feature -- Status report

	has_breakpoint: BOOLEAN
			-- Is there a break point associated with current node?
		do
			Result := breakpoint_slot > 0
		ensure
			good_result: Result = (breakpoint_slot > 0)
		end

	has_parent: BOOLEAN
			-- Does current node has parent?
		do
			Result := attached parent as l_parent
		end

	is_feature_node: BOOLEAN
			-- Does current represent a feature node?
			-- This means that `ast' is the DO_AS node for `feature_'
		do
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := ast_node_string_representation (Current, 0)
		end

feature -- AST Type

	is_loop: BOOLEAN
			-- Is `ast' a loop?
		do
			Result := attached {LOOP_AS} ast.ast as l_loop
		end

	is_if: BOOLEAN
			-- Is `ast' an if-statement?
		do
			Result := attached {IF_AS} ast.ast as l_if
		end

	is_elseif: BOOLEAN
			-- Is `ast' an elseif-statement?
		do
			Result := attached {ELSIF_AS} ast.ast as l_elseif
		end

	is_inspect: BOOLEAN
			-- Is `ast' an inspect?
		do
			Result := attached {INSPECT_AS} ast.ast as l_inspect
		end

	is_check: BOOLEAN
			-- Is `ast' a check?
		do
			Result := attached {CHECK_AS} ast.ast as l_check
		end

	is_debug: BOOLEAN
			-- Is `ast' a debug?
		do
			Result := attached {DEBUG_AS} ast.ast as l_debug
		end

	is_instruction: BOOLEAN
			-- Is `ast' an instruction?
		do
			Result := attached {INSTRUCTION_AS} ast.ast as l_instru
		end

feature -- Setting

	set_breakpoint_slot (b: INTEGER)
			-- Set `breakpoint_slot' with `b'.
		require
			b_non_negative: b >= 0
		do
			breakpoint_slot := b
		ensure
			breakpoint_slot_set: breakpoint_slot = b
		end

	extend_child_to_last_trunk (a_child: like Current)
			-- Extend `a_child' at the end of last trunk in `children'.
		require
			a_child_attached: a_child /= Void
			last_trunk_exists: not children.is_empty
		do
			children.last.extend (a_child)
			a_child.set_sibling (children.last)
		end

	extend_trunk
			-- Extend a new trunk into `children'.
		do
			children.extend (create {LINKED_LIST [AFX_AST_STRUCTURE_NODE]}.make)
		end

	set_sibling (a_sibling: like sibling)
			-- Set `sibling' with `a_sibling'.
		do
			sibling := a_sibling
		ensure
			sibling_set: sibling = a_sibling
		end

feature{NONE} -- Implementation

feature -- AST node

	ast_node_string_representation (a_node: AFX_AST_STRUCTURE_NODE; a_level: INTEGER): STRING
			-- String representation for `a_node' at indentation level `a_level'
		local
			l_cursor: CURSOR
			l_cursor2: CURSOR
			l_nodes: LINKED_LIST [AFX_AST_STRUCTURE_NODE]
		do
			create Result.make (1024)
			Result.append (tab_string (a_level))

				-- Generate break point.
			if a_node.breakpoint_slot = 0 then
				Result.append ("  ")
			else
				if a_node.breakpoint_slot > 10 then
					Result.append (a_node.breakpoint_slot.out)
				else
					Result.append_character (' ')
					Result.append (a_node.breakpoint_slot.out)
				end
			end
			Result.append_character (' ')

				-- Generate node type.
			Result.append (a_node.ast.ast.generating_type)
			Result.append_character ('%N')

				-- Generate children nodes.
			l_cursor := a_node.children.cursor
			from
				a_node.children.start
			until
				a_node.children.after
			loop
				l_nodes := a_node.children.item_for_iteration
				if not l_nodes.is_empty then
					l_cursor2 := l_nodes.cursor
					from
						l_nodes.start
					until
						l_nodes.after
					loop
						Result.append (ast_node_string_representation (l_nodes.item_for_iteration, a_level + 2))
						l_nodes.forth
					end
					Result.append ("------------------------------%N")
					l_nodes.go_to (l_cursor2)
				end
				a_node.children.forth
			end
			a_node.children.go_to (l_cursor)
		end

	tab_string (a_level: INTEGER): STRING
			-- String for `a_level' tabs
		do
			create Result.make_filled (' ', a_level * 2)
		end

end
