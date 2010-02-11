indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision: 4 $"

class
	EGX_GENERAL_GRAPH_NODE [N -> HASHABLE, L]

inherit
	EGX_GRAPH_NODE [N, L]
		redefine
			edge_type
		end

create
	make

feature{NONE} -- Initialization

	make (a_data: N) is
			-- Initialize `data' with `a_data'.
		require
			a_data_attached: a_data /= Void
			a_data_hashable: a_data.is_hashable
		do
			create {ARRAYED_LIST [like edge_type]}internal_in_edges.make (10)
			create {ARRAYED_LIST [like edge_type]}internal_out_edges.make (10)
			set_data (a_data)
		end

feature -- Access

	in_edges: LIST [like edge_type] is
			-- List of edges ending at Current graph, i.e., in-edges
			-- There is no certain node order gauranteed.
		do
			Result := internal_in_edges
		ensure then
			good_result: Result = internal_in_edges
		end

	out_edges: LIST [like edge_type] is
			-- List of edges starting from Current graph, i.e., out-edges
			-- There is no certain node order gauranteed.
		do
			Result := internal_out_edges
		ensure then
			good_result: Result = internal_out_edges
		end

	successors: LIST [like Current] is
			-- List of nodes that are reachable from `edges'
			-- There is no certain edge order gauranteed.
		do
			Result := nodes_from_edges (out_edges, agent (a_edge: like edge_type): like Current do Result := a_edge.end_node end)
		end

	predecessors: LIST [like Current] is
			-- List of nodes that are reachable from `in_edges'
			-- There is no certain node order gauranteed.
		do
			Result := nodes_from_edges (in_edges, agent (a_edge: like edge_type): like Current do Result := a_edge.start_node end)
		end

	out_edges_with_label (a_label: L): LIST [like edge_type] is
			-- Out-edges labeled with `a_label' from `out_edges'
			-- If no such edge is found, return an empty list.
		do
			Result := edges_with_label (out_edges, a_label)
		ensure
			result_attached: Result /= Void
		end

	in_edges_with_label (a_label: L): LIST [like edge_type] is
			-- Out-edge labeled with `a_label' from `out_edges'
			-- If no such edge is found, return an empty list.
		do
			Result := edges_with_label (in_edges, a_label)
		ensure
			result_attached: Result /= Void
		end

	scc_index: INTEGER
			-- Index of strongly connected component
			-- Used to deal with recursive calls, all mutually recursive features have the same `scc_index'

feature -- Hash code

	hash_code: INTEGER is
			-- Hash code value
		do
			Result := data.hash_code
		ensure then
			good_result: Result = data.hash_code
		end

feature -- Setting

	set_scc_index (a_index: INTEGER) is
			-- Set `scc_index' with `a_index'.
		do
			scc_index := a_index
		ensure
			scc_index_set: scc_index = a_index
		end

feature{EGX_GRAPH} -- Status setting

	extend_out_edge (a_edge: like edge_type) is
			-- Extend out-edge `a_edge' starting from Current node.
		require
			current_in_graph: is_in_graph
			a_edge_attached: a_edge /= Void
			a_edge_valid: a_edge.start_node = Current
		do
			out_edges.extend (a_edge)
		ensure
			a_edge_extended: out_edges.has (a_edge)
		end

	extend_in_edge (a_edge: like edge_type) is
			-- Extend in-edge `a_edge' starting from Current node.
		require
			current_in_graph: is_in_graph
			a_edge_attached: a_edge /= Void
			a_edge_valid: a_edge.end_node = Current
		do
			in_edges.extend (a_edge)
		ensure
			a_edge_extend: in_edges.has (a_edge)
		end

	remove_out_edge (a_edge: like edge_type) is
			-- Remove `a_edge' from `out_edges'.
		require
			a_edge_attached: a_edge /= Void
			has_a_edge: out_edges.has (a_edge)
		do
			remove_edge (a_edge, out_edges)
		end

	remove_in_edge (a_edge: like edge_type) is
			-- Remove `a_edge' from `in_edges'.
		require
			a_edge_attached: a_edge /= Void
			has_a_edge: in_edges.has (a_edge)
		do
			remove_edge (a_edge, in_edges)
		end

feature{NONE} -- Implementation

	internal_out_edges: like out_edges
			-- Implementation of `out_edges'

	internal_in_edges: like in_edges
			-- Implementation of `in_edges'			

	internal_successors: like successors
			-- Implementation of `successors'

	remove_edge (a_edge: like edge_type; a_source: LIST [like edge_type]) is
			-- Remove `a_edge' from `a_source'.
		require
			a_edge_attached: a_edge /= Void
			a_source_attached: a_source /= Void
			a_source_has_a_edge: a_source.has (a_edge)
		do
			a_source.start
			a_source.search (a_edge)
			if not a_source.exhausted then
				a_source.remove
			end
		end

	nodes_from_edges (a_edge_source: LIST [like edge_type]; a_node_retriever: FUNCTION [ANY, TUPLE [like edge_type], like Current]): LIST [like Current] is
			-- Nodes from `a_edge_source'. `a_node_retriever' is used to get node from every edge from `a_edge_source'
		require
			a_edge_source_attached: a_edge_source /= Void
			a_node_retriever_attached: a_node_retriever /= Void
		local
			l_cursor: CURSOR
		do
			l_cursor := a_edge_source.cursor
			from
				a_edge_source.start
			until
				a_edge_source.after
			loop
				Result.extend (a_node_retriever.item ([a_edge_source.item]))
				a_edge_source.forth
			end
			a_edge_source.go_to (l_cursor)
		end

	edges_with_label (a_edge_source: LIST [like edge_type]; a_label: L): LIST [like edge_type] is
			-- Edges labeled with `a_label' from `a_edge_source'.
			-- If no certain edge is found, return an empty list.
		require
			a_edge_source_attached: a_edge_source /= Void
			a_label_attached: a_label /= Void
		local
			l_cursor: CURSOR
			l_edge_tester: FUNCTION [ANY, TUPLE [L, L], BOOLEAN]
			l_edge: like edge_type
		do
			create {LINKED_LIST [like edge_type]} Result.make
			l_cursor := a_edge_source.cursor
			l_edge_tester := graph.actual_edge_equality_tester
			from
				a_edge_source.start
			until
				a_edge_source.after
			loop
				l_edge := a_edge_source.item
				if l_edge_tester.item ([a_label, l_edge.label]) then
					Result.extend (l_edge)
				end
				a_edge_source.forth
			end
		ensure
			result_attached: Result /= Void
		end

feature{NONE} -- Type anchor

	edge_type: EGX_GENERAL_GRAPH_EDGE [N, L] is
			-- Edge type
		do
		end

invariant
	internal_out_edges_attached: internal_out_edges /= Void
	internal_in_edges_attached: internal_in_edges /= Void

end

