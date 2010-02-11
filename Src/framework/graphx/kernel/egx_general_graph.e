indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision: 8 $"

class
	EGX_GENERAL_GRAPH [N -> HASHABLE, L]

inherit
	EGX_GRAPH [N, L]
		redefine
			node_type,
			edge_type,
			nodes
		end

create
	make

feature{NONE} -- Initialization

	make (a_capacity: INTEGER) is
			-- Initialize Current graph to contain at least `a_capacity' nodes.
		require
			a_capacity_positive: a_capacity > 0
		do
			create nodes.make (a_capacity)
		end

feature -- Access

	node (a_node: N): like node_type is
			-- Graph node representation of `a_node'
		do
			Result := nodes.item (a_node.hash_code)
		ensure then
			good_result: Result = nodes.item (a_node.hash_code)
		end

	end_nodes (a_start_node: N; a_label: L): LIST [N] is
			-- Graph nodes at the end of an out-edge starting from `a_start_node' and labeled with `a_label'.
			-- If not such node is found, return an empty list.
		local
			l_edges: LIST [like edge_type]
		do
			l_edges := nodes.item (a_start_node.hash_code).out_edges_with_label (a_label)
			create {ARRAYED_LIST [N]}Result.make (l_edges.count)
			from
				l_edges.start
			until
				l_edges.after
			loop
				Result.extend (l_edges.item.end_node.data)
				l_edges.forth
			end
		end

	out_edges_with_end_node (a_start_node, a_end_node: N): LIST [L] is
			-- Out-edges starting from `a_start_node' and ending at `a_end_node'
		require
			a_start_node_attached: a_start_node /= Void
			a_start_node_exists: has_node (a_start_node)
			a_end_node_attached: a_end_node /= Void
			a_end_node_exists: has_node (a_end_node)
		local
			l_node_tester: like actual_node_equality_tester
			l_edge: like edge_type
			l_edges: LIST [like edge_type]
		do
			l_node_tester := actual_node_equality_tester
			l_edges := node (a_start_node).out_edges
			create {LINKED_LIST [L]} Result.make
			from
				l_edges.start
			until
				l_edges.after
			loop
				l_edge := l_edges.item
				if l_node_tester.item ([a_end_node, l_edge.end_node.data]) then
					Result.extend (l_edge.label)
				end
				l_edges.forth
			end
		end

	in_edges_with_end_node (a_end_node: N): LIST [L] is
			-- In-edges going into `a_end_node'
		require
			a_end_node_attached: a_end_node /= Void
			has_node: has_node (a_end_node)
		do
			Result := edges_of_node (a_end_node, agent (a_node: like node_type): LIST [like edge_type] do Result := a_node.in_edges end)
		ensure
			result_attached: Result /= Void
		end

	out_edges_with_start_node (a_start_node: N): LIST [L] is
			-- Out-edges going out of `a_start_node'
		require
			a_start_node_attached: a_start_node /= Void
			has_node: has_node (a_start_node)
		do
			Result := edges_of_node (a_start_node, agent (a_node: like node_type): LIST [like edge_type] do Result := a_node.out_edges end)
		ensure
			result_attached: Result /= Void
		end

	reversed_graph: like Current is
			-- Reversed graph of Current
			-- A reversed graph of Current graph has the same nodes as Current,
			-- but with every in-edge turned into out-edge and every out-edge turned into in-edge.
		local
			l_nodes: like nodes
			l_node: like node_type
			l_node_data: N
			l_out_edges: LIST [like edge_type]
			l_cursor: CURSOR
			l_out_edge: like edge_type
			l_end_node_data: N
		do
			create Result.make (nodes.count)
			Result.set_edge_equality_tester (edge_equality_tester)
			Result.set_node_equality_tester (node_equality_tester)

			l_nodes := nodes
			from
				l_nodes.start
			until
				l_nodes.after
			loop
				l_node := l_nodes.item_for_iteration
				l_node_data := l_node.data

					-- Extend node from Current graph into reversed graph.
				safe_extend_node (Result, l_node_data)

					-- Insert edges into reversed graph.
				l_out_edges := l_node.out_edges
				l_cursor := l_out_edges.cursor
				from
					l_out_edges.start
				until
					l_out_edges.after
				loop
					l_out_edge := l_out_edges.item
					l_end_node_data := l_out_edge.end_node.data
					safe_extend_node (Result, l_end_node_data)
					Result.extend_out_edge (l_end_node_data, l_node_data, l_out_edge.label)
					l_out_edges.forth
				end
				l_out_edges.go_to (l_cursor)
				l_nodes.forth
			end
		end

	twin_graph: like Current is
			-- Copy of Current into a new graph
		local
			l_nodes: like nodes
			l_cursor: CURSOR
			l_node: like node_type
			l_out_edges: LIST [like edge_type]
			l_edge_cursor: CURSOR
			l_start_node: N
			l_edge: like edge_type
			l_end_node: N
		do
			create Result.make (node_count)
			Result.set_node_equality_tester (node_equality_tester)
			Result.set_edge_equality_tester (edge_equality_tester)

			l_nodes := nodes
			l_cursor := l_nodes.cursor
			from
				l_nodes.start
			until
				l_nodes.after
			loop
					-- Insert node into new graph.
				l_node :=l_nodes.item_for_iteration
				l_start_node := l_node.data
				if not Result.has_node (l_start_node) then
					Result.extend_node (l_start_node)
				end

					-- Insert out-edges of the node into new graph.
				l_out_edges := l_node.out_edges
				l_edge_cursor := l_out_edges.cursor
				from
					l_out_edges.start
				until
					l_out_edges.after
				loop
					l_edge := l_out_edges.item
					l_end_node := l_edge.end_node.data
					if not Result.has_node (l_end_node) then
						Result.extend_node (l_end_node)
					end
					Result.extend_out_edge (l_start_node, l_end_node, l_edge.label)
					l_out_edges.forth
				end
				l_out_edges.go_to (l_edge_cursor)
				l_nodes.forth
			end
			l_nodes.go_to (l_cursor)
		ensure
			result_attached: Result /= Void
		end

	out_edge_count (a_start_node: N): INTEGER is
			-- Number of out-edges starting from `a_start_node'
		do
			Result := node (a_start_node).out_edges.count
		ensure then
			good_result: Result = node (a_start_node).out_edges.count
		end

	in_edge_count (a_end_node: N): INTEGER is
			-- Number of in-edges ending at `a_end_node'
		do
			Result := node (a_end_node).in_edges.count
		ensure then
			good_result: Result = node (a_end_node).in_edges.count
		end

	node_set: DS_HASH_SET [N] is
			-- Set of `nodes'
		local
			l_nodes: HASH_TABLE [like node_type, INTEGER]
			l_cursor: CURSOR
		do
				-- Merge feature calls.
			l_nodes := nodes
			create Result.make (l_nodes.count)
			l_cursor := l_nodes.cursor
			from
				l_nodes.start
			until
				l_nodes.after
			loop
				Result.force_last (l_nodes.item_for_iteration.data)
				l_nodes.forth
			end
			l_nodes.go_to (l_cursor)
		end

feature -- Status report

	has_node (a_node: N): BOOLEAN is
			-- Is `a_node' in Current graph?
			-- Use `actual_node_equality_tester' to decide existence of `a_node'.
		local
			l_node: like node_type
		do
			l_node := nodes.item (a_node.hash_code)
			Result := l_node /= Void and then actual_node_equality_tester.item ([l_node.data, a_node])
		end

	has_out_edge (a_start_node: N; a_label: L): BOOLEAN is
			-- Is there an out-edge labeled with `a_label' starting from `a_start_node'?
		do
			Result := not node (a_start_node).out_edges_with_label (a_label).is_empty
		end

	has_out_edge_between_nodes (a_start_node, a_end_node: N; a_label: L): BOOLEAN is
			-- Is there an out-edge from `a_start_node' to `a_end_node' and labeled with `a_label'?
		local
			l_edge: like edge_type
			l_edges: LIST [like edge_type]
			l_tester: like actual_node_equality_tester
		do
			l_edges := node (a_start_node).out_edges_with_label (a_label)
			l_tester := actual_node_equality_tester
			from
				l_edges.start
			until
				l_edges.after or Result
			loop
				l_edge := l_edges.item
				Result := l_tester.item ([l_edge.end_node.data, a_end_node])
				l_edges.forth
			end
		end

	has_in_edge (a_start_node: N; a_label: L): BOOLEAN is
			-- Is there an in-edge labeled with `a_label' starting from `a_start_node'?
		do
			Result := not node (a_start_node).in_edges_with_label (a_label).is_empty
		end

	has_in_edge_between_nodes (a_start_node, a_end_node: N; a_label: L): BOOLEAN is
			-- Is there an in-edge labeled with `a_label' starting from `a_start_node' and ending with `a_end_node'?
		do
			Result := has_out_edge_between_nodes (a_end_node, a_start_node, a_label)
		end

	is_out_edge_addable (a_start_node, a_end_node: N; a_label: L): BOOLEAN is
			-- Can out-edge labeled wih `L' be added as an out-edge connecting `a_start_node' and `a_end_node'?
		do
			Result := True
		end

feature -- Setting

	extend_node (a_node: N) is
			-- Extend `a_node' into Current graph.			
			-- Use `actual_node_equality_tester' to decide existence of `a_node'.
		local
			l_node: like node_type
		do
			create l_node.make (a_node)
			l_node.set_graph (Current)
			nodes.force (l_node, l_node.hash_code)
		end

	extend_out_edge (a_node, b_node: N; a_label: L) is
			-- Extend an edge starting from `a_node' pointing to `b_node' and labeled with `a_label'.
			-- Use `actual_edge_equality_tester' to decide existence of edge.
		local
			l_edge: like edge_type
			l_a_node, l_b_node: like node_type
			l_nodes: like nodes
		do
			create l_edge.make (a_label)
			l_nodes := nodes
			l_a_node := l_nodes.item (a_node.hash_code)
			l_b_node := l_nodes.item (b_node.hash_code)
			l_edge.set_nodes (l_a_node, l_b_node)
			l_a_node.extend_out_edge (l_edge)
			l_b_node.extend_in_edge (l_edge)
		end

	remove_node (a_node: N) is
			-- Remove `a_node' from Current graph.
			-- Use `actual_node_equality_tester' to decide existence of `a_node'.
		local
			l_out_edges: LIST [like edge_type]
			l_in_edges: LIST [like edge_type]
			l_node: like node_type
			l_edge: like edge_type
			l_cursor: CURSOR
		do
			l_node := node (a_node)

				-- Remove attached out-edges.
			l_out_edges := l_node.out_edges
			l_cursor := l_out_edges.cursor
			from
				l_out_edges.start
			until
				l_out_edges.after
			loop
				l_edge := l_out_edges.item
				l_edge.end_node.remove_in_edge (l_edge)
				l_out_edges.forth
			end
			l_out_edges.go_to (l_cursor)

				-- Remove attached in-edges.
			l_in_edges := l_node.in_edges
			l_cursor := l_in_edges.cursor
			from
				l_in_edges.start
			until
				l_in_edges.after
			loop
				l_edge := l_in_edges.item
				l_edge.start_node.remove_out_edge (l_edge)
				l_in_edges.forth
			end
			l_in_edges.go_to (l_cursor)

			l_node.in_edges.wipe_out
			l_node.out_edges.wipe_out
			l_node.set_graph (Void)
			nodes.remove (a_node.hash_code)
		end

	remove_out_edges (a_start_node: N; a_label: L) is
			-- Remove edge starting from `a_start_node' and labeled with `a_label'.
			-- Use `actual_edge_equality_tester' to decide existence of edge.
		local
			l_node: like node_type
			l_edge: like edge_type
			l_edges: LIST [like edge_type]
		do
			from
				l_node := nodes.item (a_start_node.hash_code)
				l_edges := l_node.out_edges_with_label (a_label)
				l_edges.start
			until
				l_edges.after
			loop
				l_edge := l_edges.item
				l_edge.end_node.remove_in_edge (l_edge)
				l_node.remove_out_edge (l_edge)
				l_edge.set_nodes (Void, Void)
				l_edges.forth
			end
		end

	remove_in_edges (a_end_node: N; a_label: L) is
			-- Remove edge ends at `a_end_node'and labeled with `a_label'.
			-- Use `actual_edge_equality_tester' to decide existence of edge.
		local
			l_edge: like edge_type
			l_edges: LIST [like edge_type]
		do
			l_edges := nodes.item (a_end_node.hash_code).in_edges_with_label (a_label)
			from
				l_edges.start
			until
				l_edges.after
			loop
				l_edge := l_edges.item
				l_edge.start_node.remove_out_edge (l_edge)
				l_edges.forth
			end
		end

feature{EGX_GRAPH_VISITOR} -- Implementation

	nodes: HASH_TABLE [like node_type, INTEGER]
			-- Table of nodes in Current graph
			-- [node, node hash code]

feature{NONE} -- Implementation

	node_type: EGX_GENERAL_GRAPH_NODE [N, L] is
			-- Node type
		do
		end

	edge_type: EGX_GENERAL_GRAPH_EDGE [N, L] is
			-- Edge type
		do
		end

	internal_label_index: INTEGER
			-- Internal count for label index

	is_edge_targeting_node (a_edge: like edge_type; a_label: L; a_end_node: like node_type): BOOLEAN is
			-- Is `a_edge' labeled with `a_label' and ends at node `a_end_node'?
		require
			a_edge_attached: a_edge /= Void
			a_label_attached: a_label /= Void
			a_end_node_attached: a_end_node /= Void
		do
			if actual_edge_equality_tester.item ([a_edge.label, a_label]) then
				Result := a_edge.end_node = a_end_node
			end
		end

	safe_extend_node (a_graph: like Current; a_node: N) is
			-- Extend `a_node' into `a_graph' if `a_node' is not already in `a_graph'.
			-- Only the node is inserted, the edges from `a_node' is not taken care of.
		require
			a_graph_attached: a_graph /= Void
			a_node_attached: a_node /= Void
		do
			if not a_graph.has_node (a_node) then
				a_graph.extend_node (a_node)
			end
		ensure
			a_node_extended_in_a_graph: a_graph.has_node (a_node)
		end

	edges_of_node (a_node: N; a_edge_selector: FUNCTION [ANY, TUPLE [like node_type], LIST [like edge_type]]): LIST [L] is
			-- Edges of `a_node' selected by `a_edge_selector'.
		require
			a_node_attached: a_node /= Void
			has_node: has_node (a_node)
			a_edge_selector_attached: a_edge_selector /= Void
		local
			l_edges: LIST [like edge_type]
			l_cursor: CURSOR
		do
			l_edges := a_edge_selector.item ([node (a_node)])
			create {ARRAYED_LIST [L]} Result.make (l_edges.count)
			l_cursor := l_edges.cursor
			from
				l_edges.start
			until
				l_edges.after
			loop
				Result.extend (l_edges.item.label)
				l_edges.forth
			end
			l_edges.go_to (l_cursor)
		ensure
			result_attached: Result /= Void
		end

invariant
	nodes_attached: nodes /= Void

end

