class
	METRIC_GRAPH [G]

create
	make

feature -- Creation

	make is
		do
			create {LINKED_LIST[METRIC_GRAPH_NODE[G]]}root_set.make
			create {LINKED_LIST[METRIC_GRAPH_NODE[G]]}accesible_nodes.make
			root_set.compare_objects
			accesible_nodes.compare_objects
		end

feature -- Traversion

	traverse (a_visitor : METRIC_GRAPH_NODE_VISITOR) is
		require
			a_visitor_set : a_visitor /= Void
		do
			from
				root_set.start
			until
				root_set.after
			loop
				traverse_impl (root_set.item, a_visitor)
				root_set.forth
			end
		end

	sweep is
		do
			from
				root_set.start
			until
				root_set.after
			loop
				sweep_impl (root_set.item)
				root_set.forth
			end
		end

feature -- Manipulation

	outgoing_edges (a_node : METRIC_GRAPH_NODE[G]) : LIST[METRIC_GRAPH_NODE[G]] is
		require
			node_set : a_node /= Void
		do
			create {LINKED_LIST[METRIC_GRAPH_NODE[G]]}Result.make
			Result.append (a_node.children)
		end

	add_node (a_node : METRIC_GRAPH_NODE[G]) is
		require
			node_set : a_node /= Void
		do
			if not root_set.has (a_node) and not accesible_nodes.has (a_node) then
				root_set.extend (a_node)
			end
		end

	add_edge (from_node, to_node : METRIC_GRAPH_NODE[G]) is
		require
			nodes_set : from_node /= Void and to_node /= Void
			nodes_added : find_node (from_node) and find_node (to_node)
		do
			-- add the edge (but only if it wasn't there
			-- before)
			if not from_node.children.has (to_node) then
				-- attach to_node to from_node's children
				from_node.children.extend (to_node)

				-- we delete the to_node only from the root set if the
				-- from node is not in the set of accesible nodes (this
				-- would lead probably to a circle and so it wouldn't
				-- be accesible anymore).
				if root_set.has (to_node) and not accesible_nodes.has (from_node) then
					accesible_nodes.extend (to_node)
					root_set.go_i_th (root_set.index_of (to_node, 1))
					root_set.remove
				end
			end
		ensure
			edge_only_once : from_node.children.occurrences (to_node) = 1
			from_node_only_once : root_set.has (from_node) implies not accesible_nodes.has (from_node)
			to_node_only_once : root_set.has (to_node) implies not accesible_nodes.has (to_node)
		end

	find_node_by_id (an_id : G): METRIC_GRAPH_NODE[G] is
		require
			an_id_set : an_id /= Void
		local
			dummy_node : METRIC_GRAPH_NODE[G]
		do
			-- create a dummy node
			create dummy_node.make (an_id)

			-- first check the root set
			from
				Result := Void
				root_set.start
			until
				root_set.after or Result /= Void
			loop
				if root_set.item.is_equal (dummy_node) then
					Result := root_set.item
				end
				root_set.forth
			end

			-- then check the accesible node
			from
				accesible_nodes.start
			until
				accesible_nodes.after or Result /= Void
			loop
				if accesible_nodes.item.is_equal (dummy_node) then
					Result := accesible_nodes.item
				end
				accesible_nodes.forth
			end
		end

	find_node (a_node : METRIC_GRAPH_NODE[G]): BOOLEAN is
		require
			a_node_set: a_node /= Void
		do
			Result := root_set.has (a_node) or accesible_nodes.has (a_node)
		end

	is_root (a_node : METRIC_GRAPH_NODE[G]) : BOOLEAN is
		require
			a_node_set : a_node /= Void
		do
			Result := root_set.has (a_node)
		end


feature {NONE} -- Implementation (Traversion)

	traverse_impl (a_root : METRIC_GRAPH_NODE[G]; a_visitor : METRIC_GRAPH_NODE_VISITOR) is
			-- recursively traverse through the hole graph. for this we
			-- iterate through the list of children and mark every node
			-- we already have traversed (so that we stop eventually).
		require
			root_set : a_root /= Void
			visitor_set : a_visitor /= Void
		local
			node : METRIC_GRAPH_NODE[G]
		do
			if not a_root.is_marked then
				a_root.mark (True)
				a_visitor.process_node (a_root)
			end

			from
				a_root.children.start
			until
				a_root.children.after
			loop
				node := a_root.children.item
				if not node.is_marked then
					a_visitor.process_node (node)
					node.mark (True)
					traverse_impl (node, a_visitor)
				end
				a_root.children.forth
			end
		end

	sweep_impl (a_root : METRIC_GRAPH_NODE[G]) is
			-- delete all markings done in the graph.
		require
			root_set : a_root /= Void
		local
			node : METRIC_GRAPH_NODE[G]
		do
			if a_root.is_marked then
				a_root.mark (False)
			end

			from
				a_root.children.start
			until
				a_root.children.after
			loop
				node := a_root.children.item
				if node.is_marked then
					node.mark (False)
					sweep_impl (node)
				end
				a_root.children.forth
			end
		end

feature {NONE} -- Properties

	root_set : LIST[METRIC_GRAPH_NODE[G]]
		-- the root set of the graph. this is a set of nodes
		-- from which all other nodes can be acessed

	accesible_nodes : LIST[METRIC_GRAPH_NODE[G]]
		-- the nodes which are accesible by the root set.

invariant
	root_set_set : root_set /= Void
	accesible_nodes_set : accesible_nodes /= Void

end
