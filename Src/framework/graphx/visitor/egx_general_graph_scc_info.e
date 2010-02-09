indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision: 1 $"

class
	EGX_GENERAL_GRAPH_SCC_INFO [N -> HASHABLE, L]

inherit
	EGX_GRAPH_SCC_INFO [N, L]

create
	make,
	make_with_graph

feature{NONE} -- Initialization

	make is
			-- Initialize.
		do
			reset
		end

	make_with_graph (a_graph: like graph) is
			-- Initialize `graph' with `a_graph'.
		do
			set_graph (a_graph)
			make
		ensure
			graph_set: graph = a_graph
		end

feature -- Access

	scc_index (a_node: N): INTEGER is
			-- SCC index for `a_node'
			-- All nodes in the same SCC have the same SCC index.
		do
			Result := node_scc_table.item (a_node)
		end

	nodes_in_scc (a_scc_index: INTEGER): LIST [N] is
			-- All nodes in the same SCC whose index is given by `a_scc_index'
		do
			Result := scc_table.item (a_scc_index)
		end

	node_set_in_scc (a_scc_index: INTEGER): DS_HASH_SET [N] is
			-- Node set in the same SCC whose index is given by `a_scc_index'
			-- Use `graph'.`actual_node_equality_tester' to distinguish nodes.
		local
			l_list: like nodes_in_scc
		do
			l_list := nodes_in_scc (a_scc_index)
			create Result.make (l_list.count)
			l_list.do_all (agent Result.force_last)
		end

	scc_index_list: DS_LIST [INTEGER] is
			-- List of SCC index
		local
			l_scc_set: like scc_set
			l_cursor: DS_HASH_SET_CURSOR [INTEGER]
		do
			l_scc_set := scc_set
			create {DS_ARRAYED_LIST [INTEGER]} Result.make (l_scc_set.count)
			l_scc_set.do_all (agent Result.force_last)
		end

	scc_index_set: DS_HASH_SET [INTEGER] is
			-- List of index of all SCCs
		do
			Result := scc_set
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

				-- Analyze strongly connected components in Current.
			l_scc_visitor.prepare_visit
			l_scc_visitor.visit_all
		end

feature{EGX_GRAPH_SCC_ANALYZER} -- Implementation

	extend_scc_index (a_index: INTEGER) is
			-- Extend a new SCC index into `scc_index_set'.
		do
			scc_table.put (create {LINKED_LIST [N]}.make, a_index)
			scc_set.force (a_index)
		end

	extend_node_in_scc (a_node: N; a_scc_index: INTEGER) is
			-- Extend `a_node' into SCC whose index is given by `a_scc_index'.
		do
			scc_table.item (a_scc_index).extend (a_node)
			node_scc_table.put (a_scc_index, a_node)
		end

feature{NONE} -- Implementation

	scc_table: HASH_TABLE [LIST [N], INTEGER]
			-- Table of SCCs
			-- [nodes_in_the_same_scc, scc_index]

	node_scc_table: DS_HASH_TABLE [INTEGER, N]
			-- Table of SCCs
			-- [scc_index, node that belongs to that scc]

	scc_set: DS_HASH_SET [INTEGER]
			-- Set of valid SCC indexes

feature{NONE} -- Implementation

	reset is
			-- Clean data calculated by last `analyze'.
		do
			scc_count := 0
			create scc_table.make (graph.node_count // 2)
			create node_scc_table.make (graph.node_count)
			node_scc_table.set_key_equality_tester (create {AGENT_BASED_EQUALITY_TESTER [N]}.make (graph.node_equality_tester))
			create scc_set.make (graph.node_count // 2)
			set_is_calculated (False)
		ensure then
			scc_count_reset: scc_count = 0
			not_is_calculated: not is_calculated
		end

	scc_count: INTEGER
			-- Number of SCC found so far

	current_scc_index: INTEGER is
			-- Current SCC index
		do
			Result := scc_count
		ensure
			good_result: Result = scc_count
		end

	next_scc_index: INTEGER is
			-- Next SCC index
		do
			Result := scc_count + 1
			scc_count := Result
		ensure
			scc_count_increased: scc_count = old scc_count + 1
			good_result: Result = scc_count
		end

	on_new_node_found (a_from_node: N; a_node: N; a_edge: L; a_start_node: BOOLEAN) is
			-- Action to be performed when `a_node' is found during graph visit
		require
			a_node_attached: a_node /= Void
		local
			l_scc_index: INTEGER
		do
			if a_start_node then
					-- A new SCC is found, we increase scc index.
				l_scc_index := next_scc_index
				extend_scc_index (l_scc_index)
			else
					-- We are just continue navigating in the last found SCC,
					-- so we use the same scc index.
				l_scc_index := current_scc_index
			end
			extend_node_in_scc (a_node, l_scc_index)
		end

invariant
	scc_table_attached: scc_table /= Void
	node_scc_table_attached: node_scc_table /= Void
	scc_set_attached: scc_set /= Void

end
