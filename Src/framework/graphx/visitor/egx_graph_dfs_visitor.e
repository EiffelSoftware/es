indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision: 8 $"

class
	EGX_GRAPH_DFS_VISITOR [N -> HASHABLE, L]

inherit
	EGX_GRAPH_VISITOR [N, L]
		redefine
			graph,
			before,
			after,
			node,
			is_visit_prepared
		end

create
	make

feature{NONE} -- Initialization

	make is
			-- Initialize.
		do
			create edge_stack.make
			create node_stack.make
			create first_visit_node_actions
			create last_visit_node_actions
			create ignore_visited_node_actions
			before := True
			after := True
		end

feature -- Access

	node: N
			-- Node at cursor position

	graph: EGX_GRAPH [N, L]
			-- graph to visit

feature -- Status report

	before: BOOLEAN
			-- Is there no valid cursor position to the left of cursor?

	after: BOOLEAN
			-- Is there no valid cursor position to the right of cursor?

	is_visit_prepared: BOOLEAN is True
			-- Is visit prepared? i.e., can visit be started?

feature -- Cursor movement

	start is
			-- Move cursor to start position.
		local
			l_start_node: like node_type
			l_status: like visited_node_status
		do
			prepare_visit
			before := False
			l_status := visited_node_status
			if l_status.has_unvisited_node then
				l_start_node := l_status.next_unvisited_node
				discover_node (Void, l_start_node, Void)
				node := l_start_node.data
				after := False
			else
				after := True
			end
		end

	forth is
			-- Move cursor to next position.
		local
			l_edges: like sorted_out_edges
			l_edge_stack: like edge_stack
			l_edge: like edge_type
			l_done: BOOLEAN
			l_node_stack: like node_stack
			l_node: like node_type
			l_should_forth: BOOLEAN
			l_ignore_actions: like ignore_visited_node_actions
			l_status: like visited_node_status
			l_veto_agent: like veto_edge_agent
		do
			l_status := visited_node_status
			l_edge_stack := edge_stack
			l_node_stack := node_stack
			l_ignore_actions := ignore_visited_node_actions
			l_veto_agent := veto_edge_agent

			from
				l_edges := l_edge_stack.item
			until
				l_done or else after
			loop
				l_should_forth := True
				if not l_edges.after then
					l_edge := l_edges.item_for_iteration
					l_node := l_edge.end_node
					if l_veto_agent = Void or else l_veto_agent.item ([l_edge.start_node.data, l_node.data, l_edge.label]) then
						if not l_status.is_node_visited (l_node.data)  then
							discover_node (l_edge.start_node, l_node, l_edge)
							node := l_node.data
							l_done := True
						else
							l_ignore_actions.call ([l_edge.start_node.data, l_node.data, l_edge.label])
						end
					else
						l_done := False
						l_should_forth := True
					end
				else
						-- Backtrack.
					last_visit_node_actions.call ([l_node_stack.item.data])
					l_node_stack.remove
					l_edge_stack.remove
					if l_edge_stack.is_empty then
							-- We need to find another start node.
						if l_status.has_unvisited_node then
							l_node := l_status.next_unvisited_node
							discover_node (Void, l_node, Void)
							node := l_node.data
							l_should_forth := false
							l_done := True
						else
								-- All nodes have been visited, we finish.
							after := True
							l_done := True
						end
					else
						l_edges := l_edge_stack.item
					end
				end
				if not l_done and then l_should_forth then
					l_edges.forth
				end
			end
		end

	prepare_visit is
			-- Prepare for a new visit.
		do
			edge_stack.wipe_out
			node_stack.wipe_out
			if edge_order_tester /= Void then
				create edge_sorter.make (create {AGENT_BASED_EQUALITY_TESTER [like edge_type]}.make (edge_order_tester))
			else
				edge_sorter := Void
			end
			visited_node_status.reset
		end

feature{NONE} -- Implementation

	edge_stack: LINKED_STACK [DS_ARRAYED_LIST [like edge_type]]
			-- Stack used in depth-first visit
			-- `sorted_edges' stores out-edges of a node sorted by `edge_order_tester'.

	node_stack: LINKED_STACK [like node_type]
			-- Stack of nodes

	discover_node (a_start_node: like node_type; a_node: like node_type; a_edge: like edge_type) is
			-- Discover `a_node', meaning that `a_node' is newly found in Current visiting.
			-- If `a_edge' is Void, `a_node' is a starting node of a depth-first tree, otherwise,
			-- `a_node' is within some other tree, and `a_node' is reached through `a_edge' starting from `a_start_node'.
		require
			a_node_attached: a_node /= Void
			a_edge_valid: a_edge /= Void implies a_start_node /= Void
		local
			l_edges: like sorted_out_edges
			l_label: L
			l_start_node: N
			l_start_tree: BOOLEAN
		do
			visited_node_status.mark_node_as_visited (a_node.data)
			node_stack.extend (a_node)
			l_edges := sorted_out_edges (a_node)
			l_edges.start
			edge_stack.extend (l_edges)
			l_start_tree := a_edge = Void
			if not l_start_tree then
				l_label := a_edge.label
				l_start_node := a_start_node.data
			end
			first_visit_node_actions.call ([l_start_node, a_node.data, l_label, l_start_tree])
		end

invariant
	edge_stack_attached: edge_stack /= Void
	node_stack_attached: node_stack /= Void

end
