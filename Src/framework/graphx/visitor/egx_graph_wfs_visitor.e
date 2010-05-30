indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision: 8 $"

class
	EGX_GRAPH_WFS_VISITOR [N -> HASHABLE, L]

inherit
	EGX_GRAPH_VISITOR [N, L]
		redefine
			before,
			after,
			is_visit_prepared,
			graph,
			node
		end

create
	make

feature{NONE} -- Initialization

	make is
			-- Initialize.
		do
			create edge_queue.make
			create parent_node_queue.make
			create node_queue.make
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

feature -- Visiting

	start is
			-- Move cursor to start position.
		do
			prepare_visit
			before := False
			if visited_node_status.has_unvisited_node then
				visit_new_tree
				after := False
			else
				after := True
			end
		end

	forth is
			-- Move cursor to next position.
		local
			l_edges: like sorted_out_edges
			l_edge: like edge_type
			l_done: BOOLEAN
			l_node: like node_type
			l_should_forth: BOOLEAN
			l_ignore_actions: like ignore_visited_node_actions
			l_status: like visited_node_status
			l_veto_agent: like veto_edge_agent

			l_node_queue: like node_queue
			l_parent_queue: like parent_node_queue
			l_edge_queue: like edge_queue
			l_parent_node: like node_type
			l_node_data: N
			l_parent_node_data: N
			l_edge_label: L
		do
			l_veto_agent := veto_edge_agent
			l_status := visited_node_status
			l_ignore_actions := ignore_visited_node_actions

			l_node_queue := node_queue
			l_parent_queue := parent_node_queue
			l_edge_queue := edge_queue

			l_node_queue.remove
			l_parent_queue.remove
			l_edge_queue.remove

			check
				l_node_queue.count = l_parent_queue.count
				l_parent_queue.count = l_edge_queue.count
			end

			if not l_node_queue.is_empty then
					-- If there exists nodes to be visited
				from

				until
					l_done or else l_node_queue.is_empty
				loop
					l_node := l_node_queue.item
					l_parent_node := l_parent_queue.item
					l_edge := l_edge_queue.item
					l_node_data := l_node.data
					l_parent_node_data := l_parent_node.data
					l_edge_label := l_edge.label

					if l_veto_agent = Void or else l_veto_agent.item ([l_parent_node_data, l_node_data, l_edge_label])  then
						l_done := True
						if l_status.is_node_visited (l_node_data) then
							l_ignore_actions.call ([l_parent_node_data, l_node_data, l_edge_label])
						else
							discover_node (l_parent_node, l_node, l_edge)
						end
						after := False
					else
						l_node_queue.remove
						l_parent_queue.remove
						l_edge_queue.remove
					end
				end
			end

			if not l_done then
					-- If `node_queue' is empty, we check if there is another new tree which is unvisited.
				after := not l_status.has_unvisited_node
				if not after then
					visit_new_tree
				end
			end
		end

	prepare_visit is
			-- Prepare for a new visit.
		do
			edge_queue.wipe_out
			node_queue.wipe_out
			parent_node_queue.wipe_out
			if edge_order_tester /= Void then
				create edge_sorter.make (create {AGENT_BASED_EQUALITY_TESTER [like edge_type]}.make (edge_order_tester))
			else
				edge_sorter := Void
			end
			visited_node_status.reset
		end

feature{NONE} -- Implementation

	edge_queue: LINKED_QUEUE [like edge_type]
			-- Stack for edges

	parent_node_queue: LINKED_QUEUE [like node_type]
			-- Stack for parent nodes

	node_queue: LINKED_QUEUE [like node_type]
			-- Stack for nodes to be visited

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
			l_cursor: DS_LIST_CURSOR [like edge_type]
			l_node_queue: like node_queue
			l_parent_queue: like parent_node_queue
			l_edge_queue: like edge_queue
			l_edge: like edge_type
		do
			visited_node_status.mark_node_as_visited (a_node.data)
			l_edges := sorted_out_edges (a_node)
			l_node_queue := node_queue
			l_parent_queue := parent_node_queue
			l_edge_queue := edge_queue

			l_cursor := l_edges.new_cursor
			from
				l_cursor.start
			until
				l_cursor.after
			loop
				l_edge := l_cursor.item
				l_node_queue.extend (l_edge.end_node)
				l_parent_queue.extend (a_node)
				l_edge_queue.extend (l_edge)
				l_cursor.forth
			end
			l_start_tree := a_edge = Void
			if not l_start_tree then
				l_label := a_edge.label
				l_start_node := a_start_node.data
			end
			first_visit_node_actions.call ([l_start_node, a_node.data, l_label, l_start_tree])
		end

	visit_new_tree is
			-- Find the first node in an unvisited tree and visit it.
		require
			visited_node_status.has_unvisited_node
		local
			l_start_node: like node_type
		do
			l_start_node := visited_node_status.next_unvisited_node
			parent_node_queue.extend (Void)
			node_queue.extend (l_start_node)
			edge_queue.extend (Void)
			discover_node (Void, l_start_node, Void)
			node := l_start_node.data
		end

end
