indexing
	description: "Strongly Connected Component (SCC) information of a graph"
	author: ""
	date: "$Date$"
	revision: "$Revision: 1 $"

deferred class
	EGX_GRAPH_SCC_INFO [N -> HASHABLE, L]

feature -- Access

	scc_index (a_node: N): INTEGER is
			-- SCC index for `a_node'
			-- All nodes in the same SCC have the same SCC index.
		require
			graph_attached: graph /= Void
			is_calculated: is_calculated
			a_node_attached: a_node /= Void
			a_node_exists_in_graph: graph.has_node (a_node)
		deferred
		ensure
			good_result: is_scc_index_valid (Result)
		end

	nodes_in_scc (a_scc_index: INTEGER): LIST [N] is
			-- All nodes in the same SCC whose index is given by `a_scc_index'
		require
			graph_attached: graph /= Void
			is_calculated: is_calculated
			a_scc_index_valid: is_scc_index_valid (a_scc_index)
		deferred
		ensure
			result_attached: Result /= Void
		end

	node_set_in_scc (a_scc_index: INTEGER): DS_HASH_SET [N] is
			-- Node set in the same SCC whose index is given by `a_scc_index'
			-- Use `graph'.`actual_node_equality_tester' to distinguish nodes.
		require
			graph_attached: graph /= Void
			is_calculated: is_calculated
			a_scc_index_valid: is_scc_index_valid (a_scc_index)
		deferred
		ensure
			result_attached: Result /= Void
		end

	scc_index_list: DS_LIST [INTEGER] is
			-- List of SCC index
		require
			graph_attached: graph /= Void
			is_calculated: is_calculated
		deferred
		ensure
			result_attached: Result /= Void
		end

	scc_index_set: DS_HASH_SET [INTEGER] is
			-- List of index of all SCCs
		require
			graph_attached: graph /= Void
			is_calculated: is_calculated
		deferred
		ensure
			result_attached: Result /= Void
		end

	graph: EGX_GRAPH [N, L]
			-- Graph from which Current SCC information is calculated.
			-- If graph is changed after Current SCC information is calculated,
			-- then that information will be out of synchronization.
			-- You have to calculate new SCC information for the graph again.

feature -- Status report

	is_calculated: BOOLEAN
			-- Is Current SCC information calculated?

	is_scc_index_valid (a_index: INTEGER): BOOLEAN is
			-- Is `a_index' a valid SCC index?
		require
			graph_attached: graph /= Void
			is_calculated: is_calculated
		do
			Result := scc_index_set.has (a_index)
		ensure
			good_result: Result = scc_index_set.has (a_index)
		end

	is_node_in_same_scc (a_node, b_node: N): BOOLEAN is
			-- Is `a_node' and `b_node' in the same SCC?
		require
			graph_attached: graph /= Void
			is_calculated: is_calculated
			a_node_attached: a_node /= Void
			a_node_in_graph: graph.has_node (a_node)
			b_node_attached: b_node /= Void
			b_node_in_graph: graph.has_node (b_node)
		do
			Result := scc_index (a_node) = scc_index (b_node)
		ensure
			good_result: Result = (scc_index (a_node) = scc_index (b_node))
		end

	are_out_edges_within_same_scc (a_start_node: N; a_label: L): BOOLEAN is
			-- Are edges labeled with `a_label' and starting from `a_start_node' within the same SCC?
			-- i.e., does start node and end node of that edge belong to the same SCCs?
			-- Note: there may be many out edges starting from `a_start_node' and labeled with `a_label',
			-- True is returned iff all those edges are in the same SCC as `a_start_node'.
		require
			graph_attached: graph /= Void
			is_calculated: is_calculated
			a_start_node_attached: a_start_node /= Void
			a_start_node_in_graph: graph.has_node (a_start_node)
		local
			l_end_nodes: LIST [like node_type]
		do
			l_end_nodes := graph.end_nodes (a_start_node, a_label)
--			Result := l_edges.
--			Result := is_node_in_same_scc (a_start_node, graph.end_node (a_start_node, a_label).data)
			from
				Result := True
				l_end_nodes.start
			until
				l_end_nodes.after or not Result
			loop
				Result := is_node_in_same_scc (a_start_node, l_end_nodes.item.data)
				l_end_nodes.forth
			end
		ensure
--			good_result: Result = is_node_in_same_scc (a_start_node, graph.end_node (a_start_node, a_label).data)
		end

feature -- Setting

	set_graph (a_graph: like graph) is
			-- Set `graph' with `a_graph'.
		require
			a_graph_attached: a_graph = Void
		do
			graph := a_graph
		ensure
			graph_set: graph = a_graph
		end

feature -- Analyze SCC

	analyze is
			-- Analyze SCCs in `graph' and store result in Current.
		require
			graph_attached: graph /= Void
		deferred
		ensure
			is_calculated: is_calculated
		end

feature{NONE} -- Implementation

	set_is_calculated (b: BOOLEAN) is
			-- Set `is_calculated' with `b'.
		do
			is_calculated := b
		ensure
			is_calculated_set: is_calculated = b
		end

	extend_scc_index (a_index: INTEGER) is
			-- Extend a new SCC index into `scc_index_set'.
		require
			graph_attached: graph /= Void
			a_index_not_valid: not is_scc_index_valid (a_index)
		deferred
		ensure
			a_index_extended: is_scc_index_valid (a_index)
		end

	extend_node_in_scc (a_node: N; a_scc_index: INTEGER) is
			-- Extend `a_node' into SCC whose index is given by `a_scc_index'.
		require
			graph_attached: graph /= Void
			a_node_attached: a_node /= Void
			a_node_in_graph: graph.has_node (a_node)
			a_scc_index_valid: is_scc_index_valid (a_scc_index)
			a_node_not_in_scc: not node_set_in_scc (a_scc_index).has (a_node)
		deferred
		ensure
			a_node_in_scc: node_set_in_scc (a_scc_index).has (a_node)
		end

feature{NONE} -- Anchored types

	node_type: EGX_GRAPH_NODE [N, L] is
			-- Node type
		do
		end

	edge_type: EGX_GRAPH_EDGE [N, L] is
			-- Edge type
		do
		end

invariant
	graph_attached: graph /= Void

end
