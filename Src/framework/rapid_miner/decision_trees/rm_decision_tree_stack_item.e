note
	description: "This class is used internally by the rapid miner decision tree parsing algorithm."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_DECISION_TREE_STACK_ITEM
create
	make

feature -- Access

	node: RM_DECISION_TREE_NODE
			-- A reference to a node

	condition: STRING
			-- Stores the condition

	depth: INTEGER
			-- The depth of `node' in the decision tree.

feature -- Interface

	set_condition (a_condition: STRING)
			-- Set `condition' to `a_condition'
		do
			condition := a_condition
		ensure
			condition = a_condition
		end

feature {NONE} -- Construction

	make (a_node: RM_DECISION_TREE_NODE; a_condition: STRING; a_depth: INTEGER)
		-- `a_node' the node to be saved
		-- `a_condition' the condition to leave `a_node'
		-- `a_depth' the tree-depth of `a_node'
		do
			node := a_node
			condition := a_condition
			depth := a_depth
		end

invariant
	invariant_clause: True -- Your invariant here

end
