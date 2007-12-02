indexing
	description: "Objects that process nodes of some filter result tree"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CDD_FILTER_NODE_VISITOR

feature -- Processing

	process_test_class_node (a_node: CDD_TEST_CLASS_NODE) is
			-- Process `a_node'.
		require
			a_node_not_void: a_node /= Void
		deferred
		end

	process_test_routine_node (a_node: CDD_TEST_ROUTINE_NODE) is
			-- Process `a_node'.
		require
			a_node_not_void: a_node /= Void
		deferred
		end

	process_cluster_node (a_node: CDD_CLUSTER_NODE) is
			-- Process `a_node'.
		require
			a_node_not_void: a_node /= Void
		deferred
		end

	process_class_node (a_node: CDD_CLASS_NODE) is
			-- Process `a_node'.
		require
			a_node_not_void: a_node /= Void
		deferred
		end

	process_feature_node (a_node: CDD_FEATURE_NODE) is
			-- Process `a_node'.
		require
			a_node_not_void: a_node /= Void
		deferred
		end

end
