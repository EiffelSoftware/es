indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision: 1 $"

deferred class
	EGX_GRAPH_NODE [N -> HASHABLE, L]

inherit
	HASHABLE

feature -- Access

	data: N
			-- Data contained in Current node

	graph: EGX_GRAPH [N, L]
			-- Graph to which Current node belongs
			-- Void if Current node does not belong to any graph.

	in_edges: LIST [like edge_type] is
			-- List of edges ending at Current graph, i.e., in-edges
			-- There is no certain node order gauranteed.
		deferred
		ensure
			result_attached: Result /= Void
		end

	out_edges: LIST [like edge_type] is
			-- List of edges starting from Current graph, i.e., out-edges
			-- There is no certain node order gauranteed.
		deferred
		ensure
			result_attached: Result /= Void
		end

	successors: LIST [like Current] is
			-- List of nodes that are reachable from `out_edges'
			-- There is no certain node order gauranteed.
		deferred
		ensure
			result_attached: Result /= Void
		end

	predecessors: LIST [like Current] is
			-- List of nodes that are reachable from `in_edges'
			-- There is no certain node order gauranteed.
		deferred
		ensure
			result_attached: Result /= Void
		end

feature -- Status report

	is_in_graph: BOOLEAN is
			-- Is Current node in some graph?
		do
			Result := graph /= Void
		ensure
			good_result: Result = (graph /= Void)
		end

feature{EGX_GRAPH} -- Setting

	set_graph (a_graph: like graph) is
			-- Set `graph' with `a_graph'.
		do
			graph := a_graph
		ensure
			graph_set: graph = a_graph
		end

	set_data (a_data: like data) is
			-- Set `data' with `a_data'.
		do
			data := a_data
		ensure
			data_set: data = a_data
		end

feature{NONE} -- Implementation

	edge_type: EGX_GRAPH_EDGE [N, L] is
			-- Edge type
		do
		end

invariant
	data_attached: data /= Void

end
