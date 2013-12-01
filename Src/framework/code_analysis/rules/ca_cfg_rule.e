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

	CA_CFG_BACKWARD_ITERATOR

feature -- Rule Checking

	check_class (a_class: CLASS_C)
		do
			across a_class.written_in_features as l_features loop
				check_feature (a_class, l_features.item)
			end
		end

feature {NONE} -- Implementation

	check_feature (a_class: CLASS_C; a_feature: E_FEATURE)
		local
			l_cfg_builder: CA_CFG_BUILDER
		do
			if a_feature.ast.body.is_routine then
				create l_cfg_builder.make_with_feature (a_feature.ast)
				l_cfg_builder.build_cfg
				process_cfg (l_cfg_builder.cfg)
			end
		end

end
