indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision: 1 $"

class
	EGX_GRAPH_SCC_VISITOR [N -> HASHABLE, L]

inherit
	EGX_GRAPH_VISITOR [N, L]
		export{NONE}
			set_visited_node_status
		redefine
			is_visit_prepared,
			set_graph
		end

create
	make,
	make_with_graph

feature{NONE} -- Initialization

	make is
			-- Initialize.
		do
			create first_visit_node_actions
			create last_visit_node_actions
			create ignore_visited_node_actions
			create reversed_graph_visitor.make
		end

	make_with_graph (a_graph: like graph) is
			-- Initialize `graph' with `a_graph'.
		do
			set_graph (a_graph)
		ensure
			graph_set: graph = a_graph
		end

feature -- Status report

	is_visit_prepared: BOOLEAN
			-- Is visit prepared? i.e., can visit be started?

	before: BOOLEAN is
			-- Is there no valid cursor position to the left of cursor?
		do
			Result := reversed_graph_visitor.before
		end

	after: BOOLEAN is
			-- Is there no valid cursor position to the right of cursor?
		do
			Result := reversed_graph_visitor.after
		end

feature -- Access

	node: N is
			-- Node at cursor position
		do
			Result:= reversed_graph_visitor.node
		ensure then
			good_result: Result= reversed_graph_visitor.node
		end

feature -- Setting

	prepare_visit is
			-- Prepare visit
			-- Must be invoked before the first time `start' is invoked.
		require
			graph_set: is_graph_set
		local
			l_dfs_visitor: EGX_GRAPH_DFS_VISITOR [N, L]
			l_ordered_node_status: EGX_GRAPH_ORDERED_VISITOR_NODE_STATUS [N, L]
		do
			create l_dfs_visitor.make
			create node_visited_order.make (graph.node_count)

				-- First depth-first search to find out the order of nodes.
			l_dfs_visitor.set_graph (graph)
			l_dfs_visitor.first_visit_node_actions.extend (agent node_start_action)
			l_dfs_visitor.last_visit_node_actions.extend (agent node_finish_action)
			l_dfs_visitor.set_visited_node_status (create {EGX_GRAPH_UNORDERED_VISITOR_NODE_STATUS [N, L]})
			next_node_order := 0
			l_dfs_visitor.visit_all

				-- Setup for the second deep-first search.
			create l_ordered_node_status
			l_ordered_node_status.set_node_order_tester (agent node_visit_order_tester (?, ?, node_visited_order))

			reversed_graph := graph.reversed_graph
			reversed_graph_visitor.set_graph (reversed_graph)
			reversed_graph_visitor.set_visited_node_status (l_ordered_node_status)
			set_visited_node_status (l_ordered_node_status)
			is_visit_prepared := True
		ensure
			visit_is_prepared: is_visit_prepared
			node_visited_order_attached: node_visited_order /= Void
		end

	node_start_action (a_from_node: N; a_node: N; a_edge: L; a_start_node: BOOLEAN) is
			-- Set visit order.
		require
			a_node_attached: a_node /= Void
		do
			next_node_order := next_node_order + 1
		end

	node_finish_action (a_node: N; a_edge: L) is
			-- Set visit order.
		require
			a_node_attached: a_node /= Void
		do
			next_node_order := next_node_order + 1
			node_visited_order.put (next_node_order, a_node)
		end

	set_graph (a_graph: like graph) is
			-- Set `graph' with `a_graph'.
		do
			Precursor (a_graph)
			is_visit_prepared := False
		ensure then
			not_prepared: not is_visit_prepared
		end

feature -- Cursor movement

	start is
			-- Move cursor to start position.
		do
			reversed_graph_visitor.set_edge_order_tester (agent visited_order_tester)
			register_actions
			reversed_graph_visitor.start
		end

	forth is
			-- Move cursor to next position.
		local
			l_reversed_visitor: like reversed_graph_visitor
		do
			l_reversed_visitor := reversed_graph_visitor
			l_reversed_visitor.forth
			if l_reversed_visitor.after then
				deregister_actions
			end
		end

feature{NONE} -- Implementation

	node_visit_order_tester (a_node, b_node: N; a_order_table: HASH_TABLE [INTEGER, N]): BOOLEAN is
			-- Tester to decide which node should be visited first, `a_node' or `b_node'
			-- `a_order_table' is where the order information comes
		require
			a_node_attached: a_node /= Void
			b_node_attached: b_node /= Void
			a_order_table_attached: a_order_table /= Void
		do
			Result := a_order_table.item (a_node) > a_order_table.item (b_node)
		end

	reversed_graph: like graph
			-- Reversed graph of `graph'

	node_visited_order: HASH_TABLE [INTEGER, N]
			-- Order of node that are visited
			-- [Order index, Node data]

	register_actions is
			-- Register actions.
		do
			deregister_actions
			reversed_graph_visitor.first_visit_node_actions.append (first_visit_node_actions)
			reversed_graph_visitor.last_visit_node_actions.append (last_visit_node_actions)
			reversed_graph_visitor.ignore_visited_node_actions.append (ignore_visited_node_actions)
		end

	deregister_actions is
			-- Deregister actions.
		do
			reversed_graph_visitor.first_visit_node_actions.wipe_out
			reversed_graph_visitor.last_visit_node_actions.wipe_out
			reversed_graph_visitor.ignore_visited_node_actions.wipe_out
		end

	next_node_order: INTEGER
			-- Next node order

	reversed_graph_visitor: EGX_GRAPH_DFS_VISITOR [N, L]
			-- Depth-first visitor for reversed graph of `graph'

	visited_order_tester (a_edge, b_edge: like edge_type): BOOLEAN is
			-- Tester to decide which edge to visit first, `a_edge' or `b_edge'.
		require
			a_edge_attached: a_edge /= Void
			b_edge_attached: b_edge /= Void
		local
			l_node_order: like node_visited_order
		do
			check
				node_visited_order.has (a_edge.end_node.data)
				node_visited_order.has (b_edge.end_node.data)
			end
			l_node_order := node_visited_order
			Result := l_node_order.item (a_edge.end_node.data) > l_node_order.item (b_edge.end_node.data)
		end

end
