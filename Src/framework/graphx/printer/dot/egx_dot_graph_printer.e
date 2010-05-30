note
	description: "[
		Graph printer to output a graph in DOT format
		Check http://www.graphviz.org/ for more information about DOT format.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EGX_DOT_GRAPH_PRINTER [N -> HASHABLE, L]

inherit
	EGX_GRAPH_PRINTER [N, L]

end
