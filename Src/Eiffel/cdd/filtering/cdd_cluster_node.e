indexing
	description: "Objects that represent a tree node for clusters"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_CLUSTER_NODE

inherit

	CDD_FILTER_NODE

feature {NONE} -- Initialization

	make_with_cluster (a_cluster: like cluster) is
			-- Create a cluster node for `a_cluster'.
		require
			a_cluster_not_void: a_cluster /= Void
		do
			initialize
			cluster := a_cluster
		end

feature -- Access

	is_leaf: BOOLEAN is False
			-- Is `Current' a leave within the filter result tree?

	cluster: CLUSTER_I

	tag: STRING is
			-- Tag for describing `Current'
		do
			Result := cluster.cluster_name
		end

feature -- Processing

	process (a_visitor: CDD_FILTER_NODE_VISITOR) is
			-- Call appropriate processor for `Current'.
		do
			a_visitor.process_cluster_node (Current)
		end

invariant

	cluster_not_void: cluster /= Void

end
