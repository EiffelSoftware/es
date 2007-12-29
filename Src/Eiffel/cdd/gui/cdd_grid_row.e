indexing
	description: "Objects that represent a row in a CDD_GRID displaying the content of some CDD_TREE_NODE"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_GRID_ROW

inherit
	EV_GRID_ROW
		rename
			data as tree_node,
			set_data as set_tree_node
		redefine
			tree_node,
			set_tree_node,
			destroy
		end

feature -- Access

	tree_node: CDD_TREE_NODE
			-- Node beeing displayed by `Current'

feature -- Element change

	set_tree_node (a_tree_node: like tree_node) is
			-- Set `tree_node' to `a_tree_node' and subscribe as observer
			-- if `a_tree_node' points to a test routine
		do
			unattach
			Precursor (a_tree_node)
			if tree_node /= Void and then tree_node.is_leaf then
				if internal_refresh_agent = Void then
					internal_refresh_agent := agent refresh
				end
				tree_node.test_routine.refresh_actions.extend (internal_refresh_agent)
			end
		end

feature {NONE} -- Implementation

	internal_refresh_agent: PROCEDURE [ANY, TUPLE]
			-- Agent called if `tree_node' points to a test routine
			-- and this test routine receives a new outcome

feature {NONE} -- Implementation

	unattach is
			-- Remove `internal_refresh_agent' from test routines refresh action list.
		do
			if tree_node /= Void and then tree_node.is_leaf then
				tree_node.test_routine.refresh_actions.prune (internal_refresh_agent)
			end
		end

	destroy is
			-- Destroy `Current'.
		do
			Precursor
			unattach
		end

	refresh is
			-- Check last outcome of test routine in `tree_node' and
			-- properly update status item of `Current'.
		do
			if parent /= Void then
				clear
				parent.redraw
			end
		end

invariant

	subscribed_if_tree_node_points_to_routine: (tree_node /= Void and then tree_node.is_leaf) implies
		(internal_refresh_agent /= Void and then tree_node.test_routine.refresh_actions.has (internal_refresh_agent))

end
