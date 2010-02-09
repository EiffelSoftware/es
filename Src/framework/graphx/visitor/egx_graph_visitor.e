indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision: 8 $"

deferred class
	EGX_GRAPH_VISITOR [N -> HASHABLE, L]

feature -- Access

	node: N is
			-- Node at cursor position
		deferred
		end

	edge_order_tester: FUNCTION [ANY, TUPLE [like edge_type, like edge_type], BOOLEAN]
			-- Edge order tester
			-- This function determines if there are several out-edges from a node, which edge is visited first.
			-- If Void, no edge visiting order is guaranteed.

	graph: EGX_GRAPH [N, L]
			-- graph to visit

	first_visit_node_actions: ACTION_SEQUENCE [TUPLE [a_start_node: N; a_end_node: N; a_edge: L; a_new_start: BOOLEAN]]
			-- Actions to be performed when `a_end_node' is visited through edge labeled with `a_edge'
			-- starting from `a_start_node' for the first time.
			-- If `a_new_start' is False, `a_edge' is the edge through which `a_end_node' is visited,
			-- If `a_new_start' is True, a new graph subtree is found and `a_edge' has no meaning.

	last_visit_node_actions: ACTION_SEQUENCE [TUPLE [a_node: N]]
			-- Actions to be performed when `a_node' is visited for the last time.

	ignore_visited_node_actions: ACTION_SEQUENCE [TUPLE [a_start_node: N; a_end_node: N; a_edge: L]]
			-- Actions to be performed when Current visitor tries to visit `a_end_node' through `a_edge' starting from `a_start_node'
			-- but finds that `a_end_node' has been visited before.	

	visited_node_status: EGX_GRAPH_VISITOR_NODE_STATUS [N, L]
			-- Node visited status used to find next unvisited node
			-- Also, this determines the order that unvisited node can be find.

	veto_edge_agent: FUNCTION [ANY, TUPLE [a_start_node: N; a_end_node: N; a_label: L], BOOLEAN]
			-- Agent to decide if an edge labeled with `L' is visited.
			-- If agent returns True, that edge is visited, otherwise, that edge is ignored.
			-- If Void, every edge is visited.

	edge_sorter: DS_QUICK_SORTER [like edge_type]
			-- Sorter to sort edges			

feature -- Status report

	before: BOOLEAN is
			-- Is there no valid cursor position to the left of cursor?
		deferred
		end

	after: BOOLEAN is
			-- Is there no valid cursor position to the right of cursor?
		deferred
		end

	is_graph_set: BOOLEAN is
			-- Is `graph' set?
		do
			Result := graph /= Void
		ensure
			good_result: Result = graph /= Void
		end

	is_visit_prepared: BOOLEAN is
			-- Is visit prepared? i.e., can visit be started?
		deferred
		end

feature -- Cursor movement

	start is
			-- Move cursor to start position.
		require
			graph_set: is_graph_set
			visited_node_status_set: visited_node_status /= Void
			is_visit_prepared: is_visit_prepared
		deferred
		end

	forth is
			-- Move cursor to next position.
		require
			graph_set: is_graph_set
			not_before: not before
			not_after: not after
			visited_node_status_set: visited_node_status /= Void
			is_visit_prepared: is_visit_prepared
		deferred
		end

	visit_all is
			-- Visit every nodes in `graph'.
		do
			from
				start
			until
				after
			loop
				forth
			end
		ensure
			after: after
		end

feature -- Setting

	set_edge_order_tester (a_tester: like edge_order_tester) is
			-- Set `edge_order_tester' with `a_tester'.
		do
			edge_order_tester := a_tester
		ensure
			edge_order_tester_set: edge_order_tester = a_tester
		end

	set_graph (a_graph: like graph) is
			-- Set `graph' with `a_graph'.
		do
			graph := a_graph
		ensure
			graph_set: graph = a_graph
		end

	set_visited_node_status (a_status: like visited_node_status) is
			-- Set `visited_node_status' with `a_status'.
		do
			a_status.set_visitor (Current)
			visited_node_status := a_status
		ensure
			visited_node_status_set: visited_node_status = a_status
		end

	set_veto_edge_agent (a_agent: like veto_edge_agent) is
			-- Set `veto_edge_agent' with `a_agent'.
		do
			veto_edge_agent := a_agent
		ensure
			veto_edge_agent_set: veto_edge_agent = a_agent
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

	sorted_out_edges (a_node: like node_type): DS_ARRAYED_LIST [like edge_type] is
			-- Out-edges starting from `a_node' sorted by `edge_order_tester'
		require
			is_graph_set: is_graph_set
			a_node_attached: a_node /= Void
		local
			l_out_edges: LIST [like edge_type]
			l_sorter: like edge_sorter
		do
			l_out_edges := a_node.out_edges
			create Result.make (l_out_edges.count)
			l_out_edges.do_all (agent Result.force_last)
			l_sorter := edge_sorter
			if l_sorter /= Void then
				l_sorter.sort (Result)
			end
		ensure
			result_attached: Result /= Void
		end

invariant
	node_start_actions_attached: first_visit_node_actions /= Void
	node_finish_actions_attached: last_visit_node_actions /= Void
	ignore_visited_node_actions_attached: ignore_visited_node_actions /= Void

end
