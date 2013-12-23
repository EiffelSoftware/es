note
	description: "Alias graph."

class
	ALIAS_ANALYZER_GRAPH

inherit
	ANY
		redefine
			copy,
			is_equal
		end

create
	make

feature {NONE} -- Creation

	make
			-- Create a new object graph without any edges and with a single root.
		do
			create root.make (0)
			create merged.make (0)
			create edges.make (0)
			edges.compare_objects
			create back_edges.make (0)
			back_edges.compare_objects
		end

feature -- Access

	root: ARRAYED_SET [NATURAL_32]
			-- Root objects.

	merged: ARRAYED_SET [like root.item]
			-- Merged objects.

feature -- Operations

	remove_tag (tag: like edge_tag)
			-- Remove edges starting from a non-merged root and marked with `tag'.
		local
			target: like root.item
		do
			across
				root as r
			loop
					-- Skip merged roots and those without outgoing edges.
				if not merged.has (r.item) and then attached edges [r.item] as e then
					from
						e.start
					until
						e.after
					loop
						if edge_tag (e.item) = tag then
								-- Remove the corresponding backward edges first.
							target := edge_target (e.item)
							if attached back_edges [target] as t then
								from
									t.start
								until
									t.after
								loop
									if edge_tag (t.item) = tag then
										t.remove
									else
										t.forth
									end
								end
								if t.is_empty then
										-- There are no edges going to `target'.
									back_edges.remove (target)
									merged.prune (target)
								end
							end
								-- Remove forward edge.
							e.remove
						else
							e.forth
						end
					end
				end
			end
		end

	merge (other: ALIAS_ANALYZER_GRAPH)
			-- Merge current graph with `other' assuming that `other' is not going to be modified anymore.
		do
			root.merge (other.root)
			merged.merge (other.merged)
			across
				other.edges as e
			loop
				if attached edges [e.key] as s then
					s.merge (e.item)
				else
					edges [e.key] := e.item
				end
			end
		end

feature -- Comparison

	is_equal (other: ALIAS_ANALYZER_GRAPH): BOOLEAN
			-- <Precursor>
		do
			Result :=
				root.is_equal (other.root) and then
				merged.is_equal (other.merged) and then
				edges.is_equal (other.edges) and then
				back_edges.is_equal (other.back_edges)
		end

feature -- Removal

	clean
			-- Remove unnecessary edges and vertices.
		do
				-- TODO: implement canonical cleaning function by removing
				-- unreachable nodes (no path to these nodes from roots)
				-- redundant nodes (all paths terminate at different nodes)
				-- merge status of nodes (at most one path terminating at these nodes)
		end

feature {NONE} -- Cloning

	copy (other: ALIAS_ANALYZER_GRAPH)
			-- Copy data of `other' to current object.
		do
			root := other.root.twin
			merged := other.merged.twin
			edges := other.edges.twin
				-- Clone objects stores in the hash table.
			across
				edges as e
			loop
				edges [e.key] := e.item.twin
			end
			back_edges := other.back_edges.twin
				-- Clone objects stores in the hash table.
			across
				back_edges as e
			loop
				back_edges [e.key] := e.item.twin
			end
		end

feature {NONE} -- Data

	edge (tag: like edge_tag; target: like root.item): NATURAL_64
			-- Edge with tag `tag' and target `target'.
		do
			Result := target .as_natural_32.as_natural_64 |<< 32 + tag.as_natural_32.as_natural_64
		end

	edge_tag (e: like edge): like {ALIAS_ANALYZER_DICTIONARY_NATURAL_64}.last_added
			-- Tag of edge `e'.
		do
			Result := e.as_natural_32.as_integer_32
		end

	edge_target (e: like edge): like root.item
			-- Tag of edge `e'.
		do
			Result := (e |>> 32).as_natural_32
		end

feature {ALIAS_ANALYZER_GRAPH} -- Data

	edges: HASH_TABLE [ARRAYED_SET [like edge], like root.item]
			-- Edges of the graph indexes by their source nodes.

	back_edges: HASH_TABLE [ARRAYED_SET [like edge], like root.item]
			-- Edges of the graph indexes by their target nodes.

;note
	date: "$Date$"
	revision: "$Revision$"
	copyright: "Copyright (c) 2012-2013, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
