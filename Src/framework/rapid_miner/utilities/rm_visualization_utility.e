note
	description: "Utilities to visualize RapidMiner models"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_VISUALIZATION_UTILITY

inherit
	KL_SHARED_STRING_EQUALITY_TESTER

feature -- Access

	graph_of_decision_tree (a_tree: RM_DECISION_TREE): EGX_GENERAL_GRAPH [STRING, STRING]
			-- Graph for `a_tree'
		local
			l_previous_node: detachable STRING
			l_node: STRING
			l_edge: STRING
			l_leaf_count: INTEGER
			l_tree_node: RM_DECISION_TREE_NODE
			i: INTEGER
		do
			create Result.make (20)
			Result.set_node_equality_tester (agent rm_string_equality_tester)
			Result.set_edge_equality_tester (agent rm_string_equality_tester)

				-- Iterate through all paths in `a_tree'.
			across a_tree.paths as l_paths loop
					-- Iterate through all nodes in a path and add nodes into
					-- the result graph.
				l_previous_node := Void
				across l_paths.item.nodes as l_nodes loop
					if l_nodes.item.tree_node.is_leaf then
						create l_node.make (128)
						l_node.append (a_tree.label_name)
						l_node.append (once " = ")
						l_node.append (l_nodes.item.value_name)
						l_tree_node := l_nodes.item.tree_node
						if attached {HASH_TABLE [INTEGER, STRING]} l_tree_node.accuracy_performance as l_performance then
							l_node.append_character (' ')
							l_node.append_character ('(')
							i := 0
							across l_performance as l_perfs loop
								if i > 0 then
									l_node.append_character (',')
									l_node.append_character (' ')
								end
								l_node.append (l_perfs.key)
								l_node.append_character ('=')
								l_node.append (l_perfs.item.out)
								i := i + 1
							end
							l_node.append_character (')')
							l_node.append_character (' ')
						end
						l_leaf_count := l_leaf_count + 1
						l_node.append_character (' ')
						l_node.append_character ('(')
						l_node.append_integer (l_leaf_count)
						l_node.append_character (')')

					else
						l_node := l_nodes.item.attribute_name
					end
					if not Result.has_node (l_node) then
						Result.extend_node (l_node)
					end
						-- Add an edge into the result graph.

					if l_previous_node /= Void then
						if not Result.has_out_edge (l_previous_node, l_edge) then
							Result.extend_out_edge (l_previous_node, l_node, l_edge)
						end
					end
					l_previous_node := l_node
					l_edge := l_nodes.item.operator_name + " " + l_nodes.item.value_name
				end
			end
		end

feature{NONE} -- Implementation

	rm_string_equality_tester (a_string: STRING; b_string: STRING): BOOLEAN
			-- Tester to check if `a_string' is equal to `b_string'
		do
			Result := a_string ~ b_string
		end
		
end
