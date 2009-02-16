deferred class
	METRIC_GRAPH_NODE_VISITOR

feature -- Visitor

	process_node (a_node : METRIC_GRAPH_NODE[ANY]) is
		require
			a_node_set : a_node /= Void
		deferred
		end

end
