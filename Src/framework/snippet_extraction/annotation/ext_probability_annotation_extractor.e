note
	description: "Class to extract annotations based on static analysis of program control flow"
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_PROBABILITY_ANNOTATION_EXTRACTOR

inherit
	EXT_ANNOTATION_EXTRACTOR [ANN_STATE_ANNOTATION]

	AST_ITERATOR

feature -- Basic operations

	extract_from_snippet (a_snippet: EXT_SNIPPET)
			-- Extract annotations from `a_snippet' and
			-- make results available in `last_annotations'.
		local
			l_cfg_builder: EPA_CFG_BUILDER
			l_cfg: EPA_CONTROL_FLOW_GRAPH
		do
			create l_cfg_builder
			l_cfg_builder.build_from_compound (a_snippet.ast, Void, Void)
			l_cfg := l_cfg_builder.last_control_flow_graph

			a_snippet.ast.process (Current)
		end

end
