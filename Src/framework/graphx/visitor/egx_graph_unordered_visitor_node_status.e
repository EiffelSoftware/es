indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision: 5 $"

class
	EGX_GRAPH_UNORDERED_VISITOR_NODE_STATUS [N -> HASHABLE, L]

inherit
	EGX_GRAPH_VISITOR_NODE_STATUS [N, L]

feature -- Access

	next_unvisited_node: like node_type is
			-- Next unvisited node
		local
			l_node: N
			l_next_node: N
			l_start_nodes: like start_nodes
			l_unvisited_nodes: like unvisited_nodes
			l_found: BOOLEAN
		do
			l_unvisited_nodes := unvisited_nodes
			from
				l_start_nodes := start_nodes
			until
				l_start_nodes.after or else l_found
			loop
				l_node := l_start_nodes.item
				if l_unvisited_nodes.has (l_node) then
					l_next_node := l_node
					l_found := True
				else
					l_start_nodes.forth
				end
			end
			if not l_found then
				l_unvisited_nodes.start
				l_next_node := l_unvisited_nodes.item_for_iteration
			end
			Result := graph.node (l_next_node)
		end

	start_nodes: LINKED_LIST [N] is
			-- List of nodes which will be visited first (during start node searching phase)
			-- Actually, this only influence the visit order of starting node in a graph subtree,
			-- because for non-starting nodes, their visiting order is determined by associated in-edges.
		do
			if start_nodes_internal = Void then
				create {LINKED_LIST [N]} start_nodes_internal.make
			end
			Result := start_nodes_internal
		ensure
			result_attached: Result /= Void
		end

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
		end

feature -- Setting

	reset is
			-- Reset Current, make sure all nodes in `graph' are marked as unvisited.
			-- Prepare for a new navigation by `visitor'.
		local
			l_nodes: DS_HASH_TABLE [like node_type, N]
			l_unvisited_nodes: like unvisited_nodes
		do
			l_nodes := graph.nodes
			create l_unvisited_nodes.make (l_nodes.count)
			if graph.node_equality_tester /= Void then
				l_unvisited_nodes.set_equality_tester (create {AGENT_BASED_EQUALITY_TESTER [N]}.make (graph.node_equality_tester))
			end
			from
				l_nodes.start
			until
				l_nodes.after
			loop
				l_unvisited_nodes.put_last (l_nodes.item_for_iteration.data)
				l_nodes.forth
			end
			unvisited_nodes := l_unvisited_nodes
			start_nodes.start
		end

feature{EGX_GRAPH_VISITOR} -- Implementation

	mark_node_as_visited (a_node: N) is
			-- Mark `a_node' as visited.
		do
			unvisited_nodes.remove (a_node)
		end

feature{NONE} -- Implementation

	unvisited_nodes: DS_HASH_SET [N]
			-- Unvisited nodes

	start_nodes_internal: like start_nodes
			-- Implementation of `start_nodes'

invariant
	start_nodes_attached: start_nodes /= Void

end
