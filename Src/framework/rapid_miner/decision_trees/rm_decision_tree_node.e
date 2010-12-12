note
	description: "Class representing a node of a RM_DECISION_TREE."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_DECISION_TREE_NODE

inherit
	RM_CONSTANTS

create
	make

feature {NONE} -- Creation

	make (a_name: STRING; a_is_leaf: BOOLEAN)
		do
			name := a_name
			is_leaf := a_is_leaf
			create edges.make
		end

feature -- Access

	name: STRING
			-- The name of the node.

	edges: LINKED_LIST [RM_DECISION_TREE_EDGE]
			-- All the edges leading out of that node.

	samples: detachable HASH_TABLE [INTEGER, STRING]
			-- Holds the samples for that node. Samples are for example {True:5, False:0, STAY_FALSE:0}
			-- Key is the name of the result and value is the number of occurances

feature -- Status report

	is_leaf: BOOLEAN
			-- Is the node leaf or not.

feature -- Interface

	is_sample_accurate: BOOLEAN
			-- Taking this node as a root of a tree, is this tree accurate according to the samples in the leaves?
		do
			if is_leaf then
				Result := are_samples_accurate
			else
				Result := True
				from edges.start until edges.after loop
					Result := Result and edges.item_for_iteration.node.is_sample_accurate
					edges.forth
				end
			end
		end

	classification (a_instance: HASH_TABLE [STRING, STRING]; a_label: STRING; a_visited_nodes: LINKED_LIST [RM_DECISION_TREE_PATH_NODE]): STRING
			-- Classication of the goal attribute given the instance `a_instance'.
			-- Given a hash table with all the attributes as keys and their respective values,
			-- it will return the value calculated by the decision tree algorithm
			-- Key of `a_instance' is attribute name, value is attribute value.
			-- `a_label' is the name of the classification attribute.
			-- `a_visited_nodes' is a list of nodes that are visied along the decision path.
		local
			l_is_found: BOOLEAN
			l_next_node: detachable RM_DECISION_TREE_NODE
			l_path_node: RM_DECISION_TREE_PATH_NODE
		do
			if is_leaf then
				create l_path_node.make (a_label, "=", name, Current)
				a_visited_nodes.extend (l_path_node)
				Result := name
			else
				across edges as l_edges until l_is_found loop
					if l_edges.item.is_condition_satisfied (a_instance [name]) then
						l_next_node := l_edges.item.node
						create l_path_node.make (name, l_edges.item.operator, l_edges.item.value, Current)
						a_visited_nodes.extend (l_path_node)
						l_is_found := True
					end
				end
				if l_next_node /= Void then
					Result := l_next_node.classification (a_instance, a_label, a_visited_nodes)
				end
			end
		end

feature{NONE} -- Implementation

	are_samples_accurate: BOOLEAN
			-- Checks out the samples only on the current node and determines if they show accuracy or not.
			-- This is determined by looking for values > 0, if more than 1 is found then the tree is inaccurate.
		local
			found_one: BOOLEAN
		do
			if samples = Void then
				Result := True
			else
				Result := True
				from samples.start until samples.after or else not Result loop
					if samples.item_for_iteration > 0 then
						if found_one then
							Result := False
						end
						found_one := True
					end
					samples.forth
				end
			end
		ensure
			samples_void_means_true: samples = Void implies Result = True
		end

feature{RM_DECISION_TREE_PARSER} -- Implementation

	add_child (a_node: RM_DECISION_TREE_NODE; a_condition: STRING)
			-- Adds another node to the current's children.
		local
			l_edge : RM_DECISION_TREE_EDGE
		do
			create l_edge.make (a_condition, a_node)
			edges.force (l_edge)
		end

	parse_samples (a_name: STRING; a_line: STRING)
			-- Parses the samples if any and fills the `samples' hash table
			-- `a_name' is the value of the leaf.
		require
			correct_ending: a_line.ends_with ("}") or a_line.ends_with (")")
		local
			l_index: INTEGER
			l_all: STRING
			l_list: LIST [STRING]
			l_equation: LIST [STRING]
			l_start_index: INTEGER
			l_end_index: INTEGER
			l_perf: STRING
		do
			create samples.make (5)
			samples.compare_objects

			if a_line.ends_with (once "}") then
					-- Native RapidMiner ending.
				l_index := a_line.last_index_of ('{', a_line.count)
				l_all := a_line.substring (l_index+1, a_line.count-1)
				l_list := l_all.split (',')

				from l_list.start until l_list.after loop
					l_equation := l_list.item_for_iteration.split ('=')
					l_equation[1].right_adjust
					l_equation[2].right_adjust
					l_equation[1].left_adjust
					l_equation[2].left_adjust
					samples.force (l_equation[2].to_integer, l_equation[1])
					l_list.forth
				end
			else
					-- Weka ending with ")".
				l_start_index := a_line.last_index_of ('(', a_line.count)
				l_end_index := a_line.last_index_of (')', a_line.count)
				l_perf := a_line.substring (l_start_index + 1, l_end_index - 1)
				l_index := l_perf.index_of ('/', 1)
				if l_index > 0 then
						-- This is not a precise node.
					samples.force (l_perf.substring (1, l_index - 1).to_integer, a_name)
					samples.force (l_perf.substring (l_index + 1, l_perf.count).to_integer, decision_tree_other_values_name)
				else
						-- This is a precise node.
					samples.force (l_perf.to_integer, a_name)
				end
			end
		end

invariant
	leaf_has_no_children: is_leaf implies edges.is_empty
	no_leaf_has_children: not is_leaf implies not edges.is_empty
end
