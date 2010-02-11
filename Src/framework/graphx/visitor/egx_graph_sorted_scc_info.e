indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision: 1 $"

class
	EGX_GRAPH_SORTED_SCC_INFO [N -> HASHABLE, L]

inherit
	EGX_GENERAL_GRAPH_SCC_INFO [N, L]
		redefine
			scc_index_list,
			reset,
			analyze,
			on_new_node_found
		end

create
	make,
	make_with_graph

feature -- Access

	scc_index_list: DS_LIST [INTEGER] is
			-- List of SCC index
			-- Sorted, if there is an out edge from SCC1 to SCC2, then SCC2 appears before SCC1.
		do
			Result := scc_sorter.sorted_items
		end

feature -- Analyze SCC

	analyze is
			-- Analyze SCCs in `graph' and store result in Current.
		local
			l_scc_visitor: EGX_GRAPH_SCC_VISITOR [N, L]
		do
			reset
			set_is_calculated (True)

				-- Visit Current graph using SCC visitor to retrieve strongly connected component information.
			create l_scc_visitor.make_with_graph (graph)
			l_scc_visitor.first_visit_node_actions.extend (agent on_new_node_found)
			l_scc_visitor.ignore_visited_node_actions.extend (agent on_ignore_old_node)

				-- Analyze strongly connected components in Current.
			l_scc_visitor.prepare_visit
			l_scc_visitor.visit_all
			scc_sorter.sort
		end

feature{NONE} -- Implementation

	reset is
			-- Clean data calculated by last `analyze'.
		do
			Precursor
			create scc_sorter.make (graph.node_count)
		ensure then
			scc_sorter_attached: scc_sorter /= Void
		end

	on_new_node_found (a_from_node: N; a_node: N; a_edge: L; a_start_node: BOOLEAN) is
			-- Action to be performed when `a_node' is found during graph visit
		local
			l_scc_index: INTEGER
		do
			if a_start_node then
					-- A new SCC is found, we increase scc index.
				l_scc_index := next_scc_index
				extend_scc_index (l_scc_index)
				scc_sorter.put (l_scc_index)
			else
					-- We are just continue navigating in the last found SCC,
					-- so we use the same scc index.
				l_scc_index := current_scc_index
			end
			extend_node_in_scc (a_node, l_scc_index)
		end

	on_ignore_old_node (a_from_node: N; a_node: N; a_edge: L) is
			-- Action to be performed when ignoring `a_node' pointed to by `a_edge'
		require
			a_node_attached: a_node /= Void
			a_edge_attached: a_edge /= Void
		local
			l_node_scc_table: like node_scc_table
			l_start_scc: INTEGER
			l_end_scc: INTEGER
		do
			l_node_scc_table := node_scc_table
			l_start_scc := l_node_scc_table.item (a_from_node)
			l_end_scc := l_node_scc_table.item (a_node)

			if l_start_scc /= l_end_scc then
					-- These two nodes belong to different strongly connected component,
					-- we build topoligical relationship between these two strongly connected components.
				scc_sorter.put_relation (l_end_scc, l_start_scc)
			end
		end

	scc_sorter: DS_TOPOLOGICAL_SORTER [INTEGER]
			-- Topological sorter to sort strongly connected components.
			-- After sorting, we can read SCC from it one by one and analysis
			-- every feature in that SCC.		

invariant
	scc_sorter_attached: scc_sorter /= Void

end
