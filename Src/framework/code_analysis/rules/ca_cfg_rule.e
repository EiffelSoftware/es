note
	description: "Summary description for {CA_CFG_FORWARD_RULE}."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CA_CFG_RULE

inherit
	CA_RULE
		rename node_type as ast_node_type
		end

	EGX_GRAPH_DFS_VISITOR [EPA_BASIC_BLOCK, EPA_CFG_EDGE]
		rename
			make as make_dfs_visitor
		export {NONE}
			set_graph
			-- etc.
		end

feature {NONE} -- Initialization

	make_forward
		do
			make_dfs_visitor
			backward := False
			first_visit_node_actions.extend (agent visit_node)
			create {EGX_GRAPH_UNORDERED_VISITOR_NODE_STATUS [EPA_BASIC_BLOCK, EPA_CFG_EDGE]} visited_node_status
			visited_node_status.set_visitor (Current)
		end

	make_backward
		do
			make_dfs_visitor
			backward := True
			first_visit_node_actions.extend (agent visit_node)
			create {EGX_GRAPH_UNORDERED_VISITOR_NODE_STATUS [EPA_BASIC_BLOCK, EPA_CFG_EDGE]} visited_node_status
			visited_node_status.set_visitor (Current)
		end

feature -- Rule Checking

	visit_node (a_start_node, a_end_node: EPA_BASIC_BLOCK; a_edge: EPA_CFG_EDGE; a_new_start: BOOLEAN)
		deferred
		end

	check_class (a_class: CLASS_C)
		local
			l_feature_i: FEATURE_I
		do
--			across a_class.ast.all_features as l_features loop
--				check_feature (a_class, l_features.item)
--			end
--			from
--				l_features.start
--			until
--				l_features.after
--			loop
--				check_feature (a_class, l_features.item.)
--				l_features.forth
--			end

			across a_class.written_in_features as l_features loop
				l_feature_i := l_features.item.associated_feature_i
				check_feature (a_class, l_feature_i)
			end
		end

feature {NONE} -- Implementation

	check_feature (a_class: CLASS_C; a_feature: FEATURE_I)
		local
			l_cfg_builder: EPA_CFG_BUILDER
			l_cfg: EPA_CONTROL_FLOW_GRAPH
		do
			create l_cfg_builder
			l_cfg_builder.build_from_feature (a_class, a_feature)
			l_cfg := l_cfg_builder.last_control_flow_graph
			-- Skip if we were not able to build a control flow graph (e. g. if the
			-- feature is not a 'do' routine).
			if l_cfg /= Void then
				if backward then
				set_graph (l_cfg.reversed_graph)
				else
					set_graph (l_cfg)
				end

				-- check the graph
				checking_feature := a_feature
				visit_all
			end
		end

	backward: BOOLEAN

	checking_feature: detachable FEATURE_I

end
