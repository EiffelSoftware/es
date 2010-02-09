indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision: 1 $"

deferred class
	EGX_GRAPH_VISITOR_NODE_STATUS [N -> HASHABLE, L]

feature -- Access

	visitor: EGX_GRAPH_VISITOR [N, L]
			-- Graph associated with Current node status

	graph: EGX_GRAPH [N, L] is
			-- Graph associated with Current node status
		require
			is_ready: is_ready
		do
			Result := visitor.graph
		ensure
			good_result: Result = visitor.graph
		end

	next_unvisited_node: like node_type is
			-- Next unvisited node
		require
			is_ready: is_ready
			has_unvisited_node
		deferred
		ensure
			result_attached: Result /= Void
		end

feature -- Status report

	has_unvisited_node: BOOLEAN is
			-- Does `graph' has unvisited node?
		require
			is_ready: is_ready
		deferred
		end

	has_graph: BOOLEAN is
			-- Is some graph attached to `visitor'?
		require
			has_visitor: has_visitor
		do
			Result := visitor.graph /= Void
		ensure
			good_result: Result = visitor.graph /= Void
		end

	has_visitor: BOOLEAN is
			-- Is `visitor' attached?
		do
			Result := visitor /= Void
		ensure
			good_result: Result = visitor /= Void
		end

	is_ready: BOOLEAN is
			-- Is Current ready?
		do
			Result := has_visitor and then has_graph
		ensure
			good_result: Result = has_visitor and then has_graph
		end

	is_node_visited (a_node: N): BOOLEAN is
			-- Is `a_node' visited?
		require
			a_node_attached: a_node /= Void
			a_node_in_graph: graph.has_node (a_node)
		deferred
		end

feature{EGX_GRAPH_VISITOR} -- Setting

	set_visitor (a_visitor: like visitor) is
			-- Set `visitor' with `a_visitor'.
		require
			a_visitor_attached: a_visitor /= Void
		do
			visitor := a_visitor
		ensure
			visitor_set: visitor = a_visitor
		end

	reset is
			-- Reset Current, make sure all nodes in `graph' are marked as unvisited.
			-- Prepare for a new navigation by `visitor'.
		require
			is_ready: is_ready
		deferred
		end

feature{EGX_GRAPH_VISITOR} -- Implementation

	mark_node_as_visited (a_node: N) is
			-- Mark `a_node' as visited.
		require
			is_ready: is_ready
			a_node_unvisited: not is_node_visited (a_node)
		deferred
		ensure
			a_node_visited: is_node_visited (a_node)
		end

feature{NONE} -- Implementation

	node_type: EGX_GRAPH_NODE [N, L] is
			-- Node type
		do
		end

	edge_type: EGX_GRAPH_EDGE [N, L] is
			-- Edge type
		do
		end

invariant
	visitor_attached: visitor /= Void

end
