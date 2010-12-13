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

	accuracy_performance: detachable HASH_TABLE [INTEGER, STRING]
			-- Table to hold accuracy performance collected during decision tree building.
			-- Keys are classifications for the label, values are the number of instances that follow
			-- the corresponding classifications. For a decision tree to be accurate with respect to
			-- the training data, `accuracy_performance' should only have one key-value pair.

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


feature -- Status report

	is_leaf: BOOLEAN
			-- Is the node leaf or not.

	is_accurate_with_respect_to_training_samples: BOOLEAN
			-- Taking this node as a root of a tree, is this tree accurate according to the samples in the leaves?
			-- Accuracy means that Current path correctly classified all samples in training data.
		do
			if is_leaf then
				Result := are_samples_accurate
			else
				Result := True
				from edges.start until edges.after loop
					Result := Result and edges.item_for_iteration.node.is_accurate_with_respect_to_training_samples
					edges.forth
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
			if accuracy_performance = Void then
				Result := True
			else
				Result := True
				from accuracy_performance.start until accuracy_performance.after or else not Result loop
					if accuracy_performance.item_for_iteration > 0 then
						if found_one then
							Result := False
						end
						found_one := True
					end
					accuracy_performance.forth
				end
			end
		ensure
			samples_void_means_true: accuracy_performance = Void implies Result = True
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

	parse_accuracy_performance (a_name: STRING; a_line: STRING)
			-- Parses the samples if any and fills the `accuracy_performance' hash table
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
			l_total_instances: INTEGER
			l_error_instances: INTEGER
		do
			create accuracy_performance.make (5)
			accuracy_performance.compare_objects

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
					accuracy_performance.force (l_equation[2].to_integer, l_equation[1])
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
					l_total_instances := l_perf.substring (1, l_index - 1).to_integer
					l_error_instances := l_perf.substring (l_index + 1, l_perf.count).to_integer
					accuracy_performance.force (l_total_instances - l_error_instances, a_name)
					accuracy_performance.force (l_error_instances, decision_tree_other_values_name)
				else
						-- This is a precise node.
					accuracy_performance.force (l_perf.to_integer, a_name)
				end
			end
		end

invariant
	leaf_has_no_children: is_leaf implies edges.is_empty
	no_leaf_has_children: not is_leaf implies not edges.is_empty
	
end
