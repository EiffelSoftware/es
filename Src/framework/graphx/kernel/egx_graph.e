indexing
	description:
		"[
			Graph
			Nodes must have identity while label don't need to have identity.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision: 8 $"

deferred class
	EGX_GRAPH [N -> HASHABLE, L]

inherit
	EGX_EQUALITY_TESTER [N]
		rename
			equality_tester as node_equality_tester,
			actual_equality_tester as actual_node_equality_tester,
			reference_equality_tester as node_reference_equality_tester,
			set_equality_tester as set_node_equality_tester,
			is_equality_tester_settable as is_node_equality_tester_settable
		end

feature -- Access

	node (a_node: N): like node_type is
			-- Graph node representation of `a_node'
		require
			a_node_attached: a_node /= Void
			a_node_exists: has_node (a_node)
		deferred
		ensure
			result_attached: Result /= Void
		end

	end_nodes (a_start_node: N; a_label: L): LIST [N] is
			-- Graph node at the end of an out-edge starting from `a_start_node' and labeled with `a_label'.
		require
			a_start_node_attached: a_start_node /= Void
			a_start_node_exists: has_node (a_start_node)
			a_out_edge_exists: has_out_edge (a_start_node, a_label)
		deferred
		ensure
			result_attached: Result /= Void
		end

	reversed_graph: like Current is
			-- Reversed graph of Current
			-- A reversed graph of Current graph has the same nodes as Current,
			-- but with every in-edge turned into out-edge and every out-edge turned into in-edge.
		deferred
		ensure
			result_attached: Result /= Void
		end

	node_count: INTEGER is
			-- Number of nodes in Current graph
		do
			Result := nodes.count
		ensure
			good_result: Result >= 0
		end

	nodes: DS_HASH_TABLE [like node_type, N] is
			-- Set of nodes in Current graph
		deferred
		ensure
			result_attached: Result /= Void
		end

	out_edge_count (a_start_node: N): INTEGER is
			-- Number of out-edges starting from `a_start_node'
		require
			a_start_node_attached: a_start_node /= Void
			has_node: has_node (a_start_node)
		deferred
		ensure
			good_result: Result >= 0
		end

	in_edge_count (a_start_node: N): INTEGER is
			-- Number of in-edges starting from `a_start_node'
		require
			a_start_node_attached: a_start_node /= Void
			has_node: has_node (a_start_node)
		deferred
		ensure
			good_result: Result >= 0
		end

feature -- Access

	edge_equality_tester: FUNCTION [ANY, TUPLE [L, L], BOOLEAN]
			-- Node equality tester;
			-- A void equality tester means that `='
			-- will be used as comparison criterion.

	actual_edge_equality_tester: like edge_equality_tester is
			-- Actual equality tester
			-- If `edge_equality_tester' is attached, return value is `edge_equality_tester',
			-- otherwise return value is agent to `reference_edge_equality_tester'.
		do
			Result := edge_equality_tester
			if Result = Void then
				Result := agent reference_edge_equality_tester
			end
		ensure
			result_attached: Result /= Void
		end

feature -- Status report

	has_node (a_node: N): BOOLEAN is
			-- Is `a_node' in Current graph?
			-- Use `actual_node_equality_tester' to decide existence of `a_node'.
		require
			a_node_attached: a_node /= Void
		deferred
		end

	has_out_edge (a_start_node: N; a_label: L): BOOLEAN is
			-- Is there an out-edge labeled with `a_label' starting from `a_start_node'?
		require
			a_start_node_attached: a_start_node /= Void
			a_start_node_in_graph: has_node (a_start_node)
			a_label_attached: a_label /= Void
		deferred
		end

	has_in_edge (a_end_node: N; a_label: L): BOOLEAN is
			-- Is there an in-edge labeled with `a_label' ends at `a_end_node'?
		require
			a_end_node_attached: a_end_node /= Void
			a_end_node_in_graph: has_node (a_end_node)
			a_label_attached: a_label /= Void
		deferred
		end

	has_out_edge_between_nodes (a_start_node, a_end_node: N; a_label: L): BOOLEAN is
			-- Is there an out-edge labeled with `a_label' starting from `a_start_node' and ending with `a_end_node'?
		require
			a_start_node_attached: a_start_node /= Void
			a_start_node_in_graph: has_node (a_start_node)
			a_end_node_attached: a_end_node /= Void
			a_end_node_in_graph: has_node (a_end_node)
			a_label_attached: a_label /= Void
		deferred
		end

	has_in_edge_between_nodes (a_start_node, a_end_node: N; a_label: L): BOOLEAN is
			-- Is there an in-edge labeled with `a_label' starting from `a_start_node' and ending with `a_end_node'?
		require
			a_start_node_attached: a_start_node /= Void
			a_start_node_in_graph: has_node (a_start_node)
			a_end_node_attached: a_end_node /= Void
			a_end_node_in_graph: has_node (a_end_node)
			a_label_attached: a_label /= Void
		deferred
		end

	is_out_edge_addable (a_start_node, a_end_node: N; a_label: L): BOOLEAN is
			-- Can out-edge labeled wih `L' be added as an out-edge connecting `a_start_node' and `a_end_node'?
		require
			a_start_node_attached: a_start_node /= Void
			a_end_node_attached: a_end_node /= Void
		deferred
		end

feature -- Setting

	extend_node (a_node: N) is
			-- Extend `a_node' into Current graph.			
			-- Use `actual_node_equality_tester' to decide existence of `a_node'.
		require
			a_node_attached: a_node /= Void
			not_a_node_exists: not has_node (a_node)
		deferred
		ensure
			node_extended: has_node (a_node)
			a_node_in_current: node (a_node).is_in_graph and then node (a_node).graph = Current
		end

	remove_node (a_node: N) is
			-- Remove `a_node' from Current graph.
			-- Use `actual_node_equality_tester' to decide existence of `a_node'.
		require
			a_node_attached: a_node /= Void
			a_node_exists: has_node (a_node)
			a_node_in_graph: node (a_node).is_in_graph and then node (a_node).graph = Current
		deferred
		ensure
			a_node_removed: not has_node (a_node)
		end

	extend_out_edge (a_node, b_node: N; a_label: L) is
			-- Extend an edge starting from `a_node' pointing to `b_node' and labeled with `a_label'.
			-- Use `actual_edge_equality_tester' to decide existence of edge.
		require
			a_node_attached: a_node /= Void
			a_node_in_graph: has_node (a_node)
			b_node_attached: b_node /= Void
			b_node_in_graph: has_node (b_node)
			not_edge_exists: not has_out_edge_between_nodes (a_node, b_node, a_label)
			is_out_edge_addable: is_out_edge_addable (a_node, b_node, a_label)
		deferred
		ensure
			edge_extended: has_out_edge_between_nodes (a_node, b_node, a_label)
		end

	remove_out_edges (a_start_node: N; a_label: L) is
			-- Remove edge starting from `a_start_node'and labeled with `a_label'.
			-- Use `actual_edge_equality_tester' to decide existence of edge.
		require
			a_start_node_attached: a_start_node /= Void
			a_start_node_in_graph: has_node (a_start_node)
			edge_exists: has_out_edge (a_start_node, a_label)
		deferred
		ensure
			edge_removed: not has_out_edge (a_start_node, a_label)
		end

	remove_in_edges (a_end_node: N; a_label: L) is
			-- Remove edge ends at `a_end_node'and labeled with `a_label'.
			-- Use `actual_edge_equality_tester' to decide existence of edge.
		require
			a_end_node_attached: a_end_node /= Void
			a_end_node_in_graph: has_node (a_end_node)
			edge_exists: has_in_edge (a_end_node, a_label)
		deferred
		ensure
			edge_removed: not has_in_edge (a_end_node, a_label)
		end

	merge_nodes (a_node, b_node: N) is
			-- Merge `a_node' into `b_node'.
			-- After merge, `a_node' will be removed from Current graph.
			-- The order of two given node is important.
		require
			a_node_attached: a_node /= Void
			a_node_in_graph: has_node (a_node)
			b_node_attached: b_node /= Void
			b_node_in_graph: has_node (b_node)
		local
			l_out_edges: LIST [like edge_type]
			l_in_edges: LIST [like edge_type]
			l_a_graph_node: like node_type
			l_b_graph_node: like node_type
			l_other_node: N
			l_edge: like edge_type
			l_label: L
		do
			l_a_graph_node := node (a_node)
			l_b_graph_node := node (b_node)

				-- Retarget out-edges of `a_node'
			l_out_edges := node (a_node).out_edges.twin
			from
				l_out_edges.start
			until
				l_out_edges.after
			loop
				l_edge := l_out_edges.item
				l_label := l_edge.label
				l_other_node := l_edge.end_node.data
				remove_out_edges (a_node, l_label)
				if not has_out_edge (b_node, l_label) then
					extend_out_edge (b_node, l_other_node, l_label)
				end
				l_out_edges.forth
			end

				-- Retarget in-edges of `a_node'
			l_in_edges := node (a_node).in_edges.twin
			from
				l_in_edges.start
			until
				l_in_edges.after
			loop
				l_edge := l_in_edges.item
				l_label := l_edge.label
				l_other_node := l_edge.start_node.data
				remove_out_edges (l_other_node, l_label)
				if not has_out_edge (l_other_node, l_label) then
					extend_out_edge (l_other_node, b_node, l_label)
				end
				if not l_in_edges.after then
					l_in_edges.forth
				end
			end
			remove_node (a_node)
		ensure
			a_node_removed: not has_node (a_node)
		end

feature -- Equality tester setting

	set_edge_equality_tester (a_tester: like edge_equality_tester) is
			-- Set `edge_equality_tester' with `a_tester'.
		do
			edge_equality_tester := a_tester
		ensure
			edge_equality_tester_set: edge_equality_tester = a_tester
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

	reference_edge_equality_tester (u, v: L): BOOLEAN is
			-- Equality tester using `='
		do
			Result := u = v
		ensure
			good_result: Result = (u = v)
		end

end
