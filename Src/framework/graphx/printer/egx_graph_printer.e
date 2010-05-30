indexing
	description: "Printer to output an alias graph in presentable format"
	author: ""
	date: "$Date$"
	revision: "$Revision: 4 $"

deferred class
	EGX_GRAPH_PRINTER [N -> HASHABLE, L]

feature -- Status report

	is_ready: BOOLEAN is
			-- Is Current ready to print?
		deferred
		end

feature -- Print

	print_graph (a_graph: EGX_GENERAL_GRAPH [N, L]) is
			-- Print `a_graph' (to some output).
		require
			a_graph_attached: a_graph /= Void
			is_ready: is_ready
		deferred
		end

end
