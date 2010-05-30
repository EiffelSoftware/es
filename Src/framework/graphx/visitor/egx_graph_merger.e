indexing
	description: "Merger to merge a graph into another graph"
	author: ""
	date: "$Date$"
	revision: "$Revision: 1 $"

class
	EGX_GRAPH_MERGER [N -> HASHABLE, L]

feature -- Access

	source_graph: like graph_type
			-- Source graph which will be merged into `destination_graph' by `merge'

	source_graph_visitor: EGX_GRAPH_VISITOR [N, L]
			-- Visitor used to visit `source_graph' during `merge'

	destination_graph: like graph_type
			-- Destination graph into which `source_graph' will be merged by `merge'

	new_node_agent: FUNCTION [ANY, TUPLE [a_existing_node: N], N]
			-- Agent to create a graph node from another node.
			-- This agent is used to create a graph node from another graph node.
			-- For example, if a node from source graph needs to be added into destination graph,
			-- this feature is invoked to create that to-be-added node.
			-- Argument of this function is an existing node in source graph,
			-- return value of this function should be a node which doesn't not present in destination graph.
			-- If Void, twin semantic is taken to create a new node.

	new_edge_agent: FUNCTION [ANY, TUPLE [a_existing_edge: L], L]
			-- Agent to crete a graph edge from another edge.
			-- This agent is used to create graph edge from another graph edge.
			-- For example, if an edge from source graph needs to be added into destination graph,
			-- this feature is invoked to create that to-be-added edge.
			-- Argument of this function is an existing edge in source graph,
			-- return value of this function should be an edge.
			-- If Void, twin semantic is taken to create a new edge.

	homo_nodes: LIST [TUPLE [a_node_from_dest_graph: N; a_node_from_source_graph:N]] is
			-- List of nodes from destination graph and source graph which are considered to be homo.
			-- When merging source graph into destination graph, `a_node_from_source_graph' should be merged into
			-- correspondant `a_node_from_Dest_graph'.
		do
			if homo_nodes_internal = Void then
				create {LINKED_LIST [TUPLE [N, N]]} homo_nodes_internal.make
			end
			Result := homo_nodes_internal
		ensure
			result_attached: Result /= Void
		end

feature -- Status report

	is_destination_graph_updated: BOOLEAN
			-- Is `destination_graph' updated during that last `merge'?
			-- False means that `source_graph' was already contained in `destination_graph'
			-- before last `merge'.

feature -- Setting

	set_source_graph (a_graph: like source_graph) is
			-- Set `source_graph' with `a_graph'.
		require
			a_graph_attached: a_graph /= Void
		do
			source_graph := a_graph
		ensure
			source_graph_set: source_graph = a_graph
		end

	set_destination_graph (a_graph: like destination_graph) is
			-- Set `destination_graph' with `a_graph'.
		require
			a_graph_attached: a_graph /= Void
		do
			destination_graph := a_graph
		ensure
			destination_graph_set: destination_graph = a_graph
		end

	set_source_graph_visitor (a_visitor: like source_graph_visitor) is
			-- Set `source_graph_visitor' with `a_visitor'.
		require
			a_visitor_attached: a_visitor /= Void
		do
			source_graph_visitor := a_visitor
		ensure
			source_graph_visitor_set: source_graph_visitor = a_visitor
		end

	set_new_node_agent (a_agent: like new_node_agent) is
			-- Set `new_node_agent' with `a_agent'.
		do
			new_node_agent := a_agent
		ensure
			new_node_agent_set: new_node_agent = a_agent
		end

	set_new_edge_agent (a_agent: like new_edge_agent) is
			-- Set `new_edge_agent' with `a_agent'.
		do
			new_edge_agent := a_agent
		ensure
			new_edge_agent_set: new_edge_agent = a_agent
		end

feature -- Merge

	merge is
			-- Merge `source_graph' into `destination_graph'.
			-- Perform a destructive update on `destination_graph' and leave `source_graph' unchanged.
			-- `node_equality_tester' and `edge_equality_tester' from `destination_graph' are used to decide
			-- if two nodes/edges are equal.
			-- `source_graph_visitor' is used to navigate `source_graph'.		
		require
			source_graph_attached: source_graph /= Void
			source_graph_visitor_attached: source_graph_visitor /= Void
			destination_graph_attached: destination_graph /= Void
		local
			l_source_graph: like source_graph
			l_destination_graph: like destination_graph
			l_visitor: like source_graph_visitor
			l_first_visit_node_agent: PROCEDURE [ANY, TUPLE [N, N, L, BOOLEAN]]
			l_ignore_node_agent: PROCEDURE [ANY, TUPLE [N, N, L]]
		do
			l_source_graph := source_graph
			l_destination_graph := destination_graph
			l_visitor := source_graph_visitor

				-- Prepare homomorphic nodes.
			create homo_table.make (l_source_graph.node_count)
			add_nodes_in_table (homo_nodes, homo_table)

				-- Initialize `source_graph_visitor'.
			l_first_visit_node_agent := agent on_first_visit_node
			l_ignore_node_agent := agent on_ignore_visited_node
			l_visitor.first_visit_node_actions.extend (l_first_visit_node_agent)
			l_visitor.ignore_visited_node_actions.extend (l_ignore_node_agent)

				-- Navigate through `a_source_graph', perform merging.
			set_is_destination_graph_updated (False)
			l_visitor.visit_all

				-- Dispose after visiting.
			l_visitor.first_visit_node_actions.prune_all (l_first_visit_node_agent)
			l_visitor.ignore_visited_node_actions.prune_all (l_ignore_node_agent)
			homo_table := Void
		end

feature{NONE} -- Implementation

	graph_type: EGX_GRAPH [N, L] is
			-- Anchored graph type
		do
		end

	new_node (a_dest_graph, a_source_graph: like graph_type; a_existing_node: N): N is
			-- New node to be added into `a_dest_graph' which is generated based on `a_existing_node' from `a_source_graph'
		require
			a_dest_graph_attached: a_dest_graph /= Void
			a_source_graph_attached: a_source_graph /= Void
			different_graphs: a_dest_graph /= a_source_graph
			a_existing_node_attached: a_existing_node /= Void
			a_existing_node_in_a_source_graph: a_source_graph.has_node (a_existing_node)
		local
			l_new_node_agent: like new_node_agent
		do
			l_new_node_agent := new_node_agent
			if l_new_node_agent = Void then
				Result := a_existing_node.twin
			else
				Result := l_new_node_agent.item ([a_existing_node])
			end
		ensure
			result_attached: Result /= Void
			result_not_in_a_dest_graph: not a_dest_graph.has_node (Result)
		end

	new_edge (a_dest_graph, a_source_graph: like graph_type; a_existing_edge: L): L is
			-- New edge to be added into `a_dest_graph' which is generated based on `a_existing_edge' from `a_source_graph'
		require
			a_dest_graph_attached: a_dest_graph /= Void
			a_source_graph_attached: a_source_graph /= Void
			different_graphs: a_dest_graph /= a_source_graph
			a_existing_edge_attached: a_existing_edge /= Void
		local
			l_new_edge_agent: like new_edge_agent
		do
			l_new_edge_agent := new_edge_agent
			if l_new_edge_agent = Void then
				Result := a_existing_edge.twin
			else
				Result := l_new_edge_agent.item ([a_existing_edge])
			end
		ensure
			result_attached: Result /= Void
		end

	add_nodes_in_table (a_node_pair_list: like homo_nodes; a_table: HASH_TABLE [N, N]) is
			-- Add nodes from `a_node_pair_list' into `a_table' indexed by the second item in node pair.
		require
			a_node_pair_list_attached: a_node_pair_list /= Void
			a_table_attached: a_table /= Void
		local
			l_node_pair: TUPLE [a_dest_node: N; a_source_node: N]
		do
			from
				a_node_pair_list.start
			until
				a_node_pair_list.after
			loop
				l_node_pair := a_node_pair_list.item
				a_table.force (l_node_pair.a_dest_node, l_node_pair.a_source_node)
				a_node_pair_list.forth
			end
		end

	homo_table: HASH_TABLE [N, N]
			-- Table for homomorphic nodes from `destination_graph' to `source_graph'

	on_first_visit_node (a_from_node: N; a_node: N; a_label: L; a_start_node: BOOLEAN) is
			-- Action to be performed when `a_node' is visited for the first time
		local
			l_homos: like homo_table
			l_new_node: N
			l_dest_graph: like destination_graph
			l_last_node: N
			l_dest_last_node: N
			l_homo_node: N
		do
			l_homos := homo_table
			l_last_node := a_from_node
			l_dest_graph := destination_graph

			if a_start_node then
					-- A start node is found in `source_graph'.										
				if not l_homos.has (a_node) then
						-- If that start node is already in `homo_table', meaning that an equivalent node is aleady in `destination_graph',
						-- then we don't need to do anything.
						-- If that start node is not in `homo_table', we need added a new node in `destination_graph',
						-- that new node is created based on the found start node.					
					l_new_node := new_node (l_dest_graph, source_graph, a_node)
					l_dest_graph.extend_node (l_new_node)
					l_homos.force (l_new_node, a_node)
					set_is_destination_graph_updated (True)
				end
			else
					-- A non-start node is found in `source_graph'. In this case, edge labeled with `a_label' starts from `l_last_node' and pointing to `a_node'.
					-- `l_last_node' must be already in `homo_table'.
				l_last_node := a_from_node
				l_dest_last_node := l_homos.item (l_last_node)
				if l_dest_graph.has_out_edge (l_dest_last_node, a_label) then
						-- If there is already an out-edge from `l_last_node' and labeled with `a_label',
						-- meaning we don't need to merge that edge from `source_graph',
						-- we only need to update `homo_table' to take `a_node' into account.
					l_homos.force (l_dest_graph.end_node (l_dest_last_node, a_label).data, a_node)
				else
					l_homo_node := l_homos.item (a_node)
					if l_homos.has (a_node) then
							-- If the end node from `source_graph' is homomorphic to some node in `destination_graph',
							-- we need add and edge from `l_dest_last_node' to `l_homo_node' if that edge is not there.
						l_homo_node := l_homos.item (a_node)
						if not l_dest_graph.has_out_edge_between_nodes (l_dest_last_node, l_homo_node, a_label) then
							l_dest_graph.extend_out_edge (l_dest_last_node, l_homo_node, new_edge (l_dest_graph, source_graph, a_label))
							set_is_destination_graph_updated (True)
						end
					else
							-- If that edge doesn't exist in `destination_graph', we need to add a new node in `destination_graph', and then
							-- add an out-edge from `l_dest_last_node' connecting to that newly added node.
						l_new_node := new_node (l_dest_graph, source_graph, a_node)
						l_dest_graph.extend_node (l_new_node)
						l_dest_graph.extend_out_edge (l_dest_last_node, l_new_node, a_label)
						l_homos.force (l_new_node, a_node)
						set_is_destination_graph_updated (True)
					end
				end
			end
		end

	on_ignore_visited_node (a_from_node: N; a_node: N; a_label: L) is
			-- Action to be performed when ignoring `a_node' during visiting
		local
			l_last_node: N
			l_dest_last_node: N
			l_dest_end_node: N
			l_dest_original_end_node: N
			l_dest_graph: like destination_graph
			l_homo: like homo_table
		do
			l_dest_graph := destination_graph
			l_homo := homo_table
			l_last_node := a_from_node
			l_dest_last_node := l_homo.item (l_last_node)
			if l_dest_graph.has_out_edge (l_dest_last_node, a_label) then
					-- If edge starting from `destination_graph''s homomorphic node of `last_node' and labeled with `a_label' already exists,
					-- there are two cases:
					-- 1) The edge in `destination_graph' leading to a node which is homomorphic to `a_node' in `source_graph', then we need to do nothing,
					-- 2) The edge in `destination_graph' leading to a node with is not homomorphic to `a_node' in `source_graph',
					-- 	  then we need to merge those two nodes in `destination_graph'.				
				l_dest_end_node := l_dest_graph.end_node (l_dest_last_node, a_label).data
				l_dest_original_end_node := l_homo.item (a_node)
				if l_dest_original_end_node /= l_dest_end_node then
						-- Case 2, we need to merge two nodes in `destination_graph'.
					l_dest_graph.merge_nodes (l_dest_end_node, l_dest_original_end_node)
					set_is_destination_graph_updated (True)
				end
			else
					-- If edge starting from `destination_graph''s homomorphic node of `last_node' and labeled with `a_label' doesn't exist,
					-- we need to add this edge into `destination_graph'.
				l_dest_end_node := l_homo.item (a_node)
				l_dest_graph.extend_out_edge (l_dest_last_node, l_dest_end_node, a_label)
				set_is_destination_graph_updated (True)
			end
		end

	set_is_destination_graph_updated (b: BOOLEAN) is
			-- Set `is_destination_graph_updated' with `b'.
		do
			is_destination_graph_updated := b
		ensure
			is_destination_graph_updated_set: is_destination_graph_updated = b
		end

	homo_nodes_internal: like homo_nodes
			-- Implementation of `homo_nodes'

end
