indexing
	description: "Mathematical objects forming graphs over node and edge sets"
	version: "$Id$"
	author: "Tobias Widmer and Bernd Schoeller"
	copyright: "see License.txt"

deferred class
	MML_GRAPH[G]

inherit
	MML_PAIR[MML_SET[G], MML_ENDORELATION[G]]
		rename
			first as nodes,
			second as edges
		end

feature -- Properties

	is_complete : BOOLEAN is
			-- Is `current' a complete graph?
		deferred
		end

	is_subgraph (other: MML_GRAPH[G]) : BOOLEAN is
			-- Is `other' a subgraph of `current'?
		deferred
		end

	is_supergraph (other: MML_GRAPH[G]) : BOOLEAN is
			-- Is `other' a supergraph of `current'?
		deferred
		end

	is_proper_supergraph (other: MML_GRAPH[G]) : BOOLEAN is
			-- Is `other' a proper supergraph of `current'?
		deferred
		end

	is_proper_subgraph (other: MML_GRAPH[G]) : BOOLEAN is
			-- Is `other' a proper subgraph of `current'?
		require
			other_not_void : other /= Void
		do
			Result := is_subgraph (other) and not is_equal (other)
		ensure
			definition_of_proper_subgraph : Result.is_equal (is_subgraph (other) and not is_equal (other))
		end

feature -- Basic Operations

	edge_extended (other : MML_PAIR[G, G]) : like Current is
			-- The graph `current' extended with `other'.
		require
			other_not_void : other /= Void
			nodes_in_graph : nodes.contains (other.first) and nodes.contains (other.second)
		deferred
		ensure
			definition_of_edge_extended : Result.nodes.is_equal (nodes) and Result.edges.is_equal (edges.extended (other))
		end

	node_extended (other : G) : like Current is
			-- The graph `current' extended with `other'.
		require
			other_not_void : other /= Void
		deferred
		end

	edge_pruned (other : MML_PAIR[G, G]) : like Current is
			-- The graph `current' with `other' removed.
		require
			other_not_void : other /= Void
			nodes_in_graph : nodes.contains (other.first) and nodes.contains (other.second)
		deferred
		end

	node_pruned (other : G) : like Current is
			-- The graph `current' with `other' removed.
		require
			other_not_void : other /= Void
		deferred
		end

invariant
	definition_of_graph : nodes.is_superset_of (edges.domain) and nodes.is_superset_of (edges.range)

end -- class MML_GRAPH
