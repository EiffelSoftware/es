indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision: 1 $"

class
	EGX_GRAPH_ORDERED_VISITOR_NODE_STATUS [N -> HASHABLE, L]

inherit
	EGX_GRAPH_VISITOR_NODE_STATUS [N, L]

feature -- Access

	next_unvisited_node: like node_type is
			-- Next unvisited node
		do
			Result := graph.node (unvisited_nodes.item)
		end

	node_order_tester: FUNCTION [ANY, TUPLE [N, N], BOOLEAN]
			-- Tester to test the order of two nodes.
			-- Used to sort nodes in a graph to decide which nodes get visited first.
			-- Actually, this only influence the visit order of starting node in a graph subtree,
			-- because for non-starting nodes, their visiting order is determined by associated in-edges.

feature -- Status report

	has_unvisited_node: BOOLEAN is
			-- Does `graph' has unvisited node?
		do
			Result := not unvisited_nodes.is_empty
		ensure then
			good_result: Result = not unvisited_nodes.is_empty
		end

	is_node_visited (a_node: N): BOOLEAN is
			-- Is `a_node' visited?
		do
			Result := not unvisited_nodes.has (a_node)
		ensure then
			good_result: Result = not unvisited_nodes.has (a_node)
		end

feature -- Setting

	mark_node_as_visited (a_node: N) is
			-- Mark `a_node' as visited.
		do
			unvisited_nodes.remove_by_item (a_node)
		end

	reset is
			-- Reset Current, make sure all nodes in `graph' are marked as unvisited.
			-- Prepare for a new navigation by `visitor'.
		local
			l_sorted_nodes: ARRAY [N]
			l_nodes: HASH_TABLE [like node_type, INTEGER]
			l_sorter: DS_ARRAY_QUICK_SORTER [N]
			l_index: INTEGER
			l_node_count: INTEGER
			l_unvisited_nodes: like unvisited_nodes
		do
				-- Copy nodes from `graph' for later sorting.
			l_nodes := graph.nodes
			l_node_count := l_nodes.count
			create l_sorted_nodes.make (1, l_nodes.count)
			from
				l_nodes.start
				l_index := 1
			until
				l_nodes.after
			loop
				l_sorted_nodes.put (l_nodes.item_for_iteration.data, l_index)
				l_nodes.forth
				l_index := l_index + 1
			end

				-- Sort nodes by `node_order_tester'.
			create l_sorter.make (create {AGENT_BASED_EQUALITY_TESTER [N]}.make (node_order_tester))
			l_sorter.sort (l_sorted_nodes)

				-- Copy sorted nodes into `unvisited_nodes' for later graph visiting.
			create l_unvisited_nodes
			from
				l_index := 1
			until
				l_index > l_node_count
			loop
				l_unvisited_nodes.extend (l_sorted_nodes.item (l_index))
				l_index := l_index + 1
			end
			unvisited_nodes := l_unvisited_nodes
			unvisited_nodes.start
		ensure then
			unvisited_nodes_attached: unvisited_nodes /= Void
		end

	set_node_order_tester (a_tester: like node_order_tester) is
			-- Set `node_order_tester' with `a_tester'.
		require
			a_tester_attached: a_tester /= Void
		do
			node_order_tester := a_tester
		ensure
			node_order_tester_set: node_order_tester = a_tester
		end

feature{NONE} -- Implementation

	unvisited_nodes: EGX_HASH_LINKED_LIST [N]
			-- Unvisited ndoes

invariant
	node_order_tester_attached: node_order_tester /= Void

end
