note
	description: "Summary description for {CA_CFG_FORWARD_RULE}."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CA_CFG_RULE

inherit
	CA_RULE

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
			backward := False
		end

	make_backward
		do
			backward := True
		end

feature -- Rule Checking

	check_class (a_class: CLASS_C)
		do
			across a_class.feature_table.features as l_features loop
				check_feature (a_class, l_features.item)
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
			if backward then
				set_graph (l_cfg.reversed_graph)
			else
				set_graph (l_cfg)
			end

			-- check the graph
			checking_feature := a_feature
			visit_all
		end

	backward: BOOLEAN

	checking_feature: detachable FEATURE_I

end
