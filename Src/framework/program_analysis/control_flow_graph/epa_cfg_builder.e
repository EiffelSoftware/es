note
	description: "Control flow graph builder"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_CFG_BUILDER

inherit
	AST_ITERATOR

feature -- Access

	last_control_flow_graph: EPA_CONTROL_FLOW_GRAPH
			-- Last control flow graph built by `build_control_flow_graph'

feature -- Basic operations

	build (a_context_class: CLASS_C; a_feature: FEATURE_I)
			-- Build control flow graph for `a_feature' in context of `a_context_class',
			-- make result available in `last_control_flow_graph'.
		do
			create last_control_flow_graph

				-- Process only if `a_feature' has body.
			if attached {BODY_AS} a_feature.body.body as l_body then
				if attached {ROUTINE_AS} l_body.content as l_routine then
					if attached {DO_AS} l_routine.routine_body as l_do then
							-- Use Current visitor to iterate through the feature body,
							-- and insert nodes and edges into `last_control_flow_graph'.
						safe_process (l_do)
					end
				end
			end
		end

end
