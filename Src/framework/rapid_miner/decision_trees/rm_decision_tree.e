note
	description: "Represents a decision tree."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_DECISION_TREE

inherit
	DEBUG_OUTPUT

	RM_SHARED_EQUALITY_TESTERS

create
	make

feature{NONE} -- Initialization

	make (a_root: RM_DECISION_TREE_NODE; a_label_name: STRING)
			-- `a_root' the root of the tree
			-- `a_label_name' the target attribute's name for this tree
		do
			internal_is_accurate := True
			should_calculate_is_accurate := True
			root := a_root
			label_name := a_label_name.twin
			create node_stack.make
		end

feature -- Access

	root: RM_DECISION_TREE_NODE
			-- The root node of the tree.

	label_name: STRING
			-- The name of the target attribute of that  tree

	paths: LINKED_LIST [RM_DECISION_TREE_PATH]
			-- List of all the paths from the root of the current tree to all the nodes.
		do
			if paths_internal = Void then
				node_stack.wipe_out
				create paths_internal.make
				calculate_paths (root)
			end
			Result := paths_internal
		end

feature -- Classicification results

	last_classification: detachable STRING
			-- Classification from last `classify'

	last_path: detachable RM_DECISION_TREE_PATH
			-- The path that was followed to decide `last_classification' when
			-- `classify' was invoked the last time

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			create Result.make (1024)

			Result.append ("Label: ")
			Result.append (label_name)
			Result.append_character ('%N')
			append_debug_output_for_node (root, 1, Result)
		end

feature -- Status report

	is_accurate: BOOLEAN
			-- Is Current tree accurate?
			-- A tree is accurate if it does correct classification on all training samples.
		do
			if should_calculate_is_accurate then
				Result := root.is_sample_accurate
			else
				Result := internal_is_accurate
			end
		end

feature -- Clasification

	classify (a_sample: HASH_TABLE [STRING, STRING])
			-- Use current tree to classify the instance given by `a_sample'.			
			-- Key of `a_sample' is attribute name, value is the value of that attribute in `a_sample'.
			-- Store final class in `last_classification' and store the path that was used to deduce the result
			-- in `last_path'.
		local
			l_result: like classification
		do
			l_result := classification (a_sample)
			last_classification := l_result.classification
			last_path := l_result.path
		end

	partitioned_relations (a_relation: WEKA_ARFF_RELATION): DS_HASH_TABLE [WEKA_ARFF_RELATION, RM_DECISION_TREE_PATH]
			-- ARFF relations that are partitioned by Current tree
			-- Result is a hash-table, keys are paths from Current tree, values are relations having
			-- the same attributes as `a_relation', and having the instances that follow the corresponding paths.
		require
			a_relation_valid: a_relation.has_attribute_by_name (label_name)
		local
			l_path: RM_DECISION_TREE_PATH
			l_relation: WEKA_ARFF_RELATION
			l_class: like classification
			l_sample: HASH_TABLE [STRING, STRING]
			l_result: like classification
		do
			create Result.make (5)
			Result.set_key_equality_tester (rm_decision_tree_path_equality_tester)

			across a_relation as l_instances loop
				l_sample := a_relation.instance_as_hash_table (l_instances.item)
				l_result := classification (l_sample)
				l_path := l_result.path

				Result.search (l_path)
				if Result.found then
					l_relation := Result.found_item
				else
					l_relation := a_relation.cloned_skeleton
					Result.force (l_relation, l_path)
				end
				l_relation.extend (l_instances.item)
			end
		end

feature{RM_DECISION_TREE_BUILDER} -- Setting

	set_is_accurate (a_is_accurate: BOOLEAN)
			-- Set `is_accurate' with `a_is_accurate'.
		do
			internal_is_accurate := a_is_accurate
			should_calculate_is_accurate := False
		ensure
			is_accurate_set: is_accurate = a_is_accurate
		end

feature{NONE} -- Internal data holders

	should_calculate_is_accurate: BOOLEAN
			-- This variable tells if we have to calculate the `is_accurate' feature
			-- by going to all the leaves and checking out the samples or we can use
			-- the `internal_is_accurate' variable. If we use the `set_is_accurate'
			-- feature then the `calculate_is_accurate' will be false else true.

	internal_is_accurate: BOOLEAN
			-- If we manually set the accuracy of the tree this is where we store it.

	paths_internal: detachable like paths
			-- Internal variable used to hold the intermediate paths calculated in `calculate_paths'

	node_stack: LINKED_STACK [RM_DECISION_TREE_PATH_NODE]
			-- While we dfs traverse the tree we need to keep the previous nodes so that we can
			-- print the whole path when we reach a leaf node.

feature{NONE} -- Implementation

	calculate_paths (a_node: RM_DECISION_TREE_NODE)
			-- Traverses the tree in a DFS manner. When a leaf node is encountered the stack is saved into the paths variable.
		local
			l_node: RM_DECISION_TREE_PATH_NODE
		do
			if a_node.is_leaf then
				create l_node.make (label_name, "=", a_node.name, a_node)
				node_stack.put (l_node)
				save_stack
				node_stack.remove
			else
				across a_node.edges as l_edges loop
					create l_node.make (a_node.name, a_node.edges.item_for_iteration.operator, l_edges.item.value, a_node)
					node_stack.put (l_node)
					calculate_paths (l_edges.item.node)
					node_stack.remove
				end
			end
		end

	save_stack
			-- Saves the stack into the paths variable.
		local
			l_list: LINKED_LIST [RM_DECISION_TREE_PATH_NODE]
			l_array: ARRAYED_LIST [RM_DECISION_TREE_PATH_NODE]
			l_path: RM_DECISION_TREE_PATH
		do
			create l_list.make
			l_array := node_stack.linear_representation
			from l_array.finish until l_array.before loop
				l_list.extend (l_array.item_for_iteration)
				l_array.back
			end
			create l_path.make (l_list)
			paths_internal.extend (l_path)
		end

	classification (a_sample: HASH_TABLE [STRING, STRING]): TUPLE [classification: STRING; path: RM_DECISION_TREE_PATH]
			-- Use current tree to classify the instance given by `a_sample'.			
			-- Key of `a_sample' is attribute name, value is the value of that attribute in `a_sample'.
			-- Store final class in `classification' and store the path that was used to deduce the result
			-- in `path'.
		local
			l_visited_nodes: LINKED_LIST [RM_DECISION_TREE_PATH_NODE]
			l_classification: STRING
			l_path: RM_DECISION_TREE_PATH
		do
			create l_visited_nodes.make
			l_classification := root.classification (a_sample, label_name, l_visited_nodes)
			create l_path.make (l_visited_nodes)
			Result := [l_classification, l_path]
		end

feature{NONE} -- Implementation/Output

	append_debug_output_for_node (a_node: RM_DECISION_TREE_NODE; a_level: INTEGER; a_result: STRING)
			-- Append output information for `a_node' (at level `a_level') into `a_result'.
			-- `a_level' indicates the level of `a_node' in the whole tree, starting from 1 (root).
		local
			i: INTEGER
		do
			across a_node.edges as l_edges loop
				a_result.append (level_heading (a_level - 1))
				a_result.append (a_node.name)
				a_result.append_character (' ')
				a_result.append (l_edges.item.operator)
				a_result.append_character (' ')
				a_result.append (l_edges.item.value)
				if l_edges.item.node.is_leaf then
					a_result.append_character (' ')
					a_result.append_character (':')
					a_result.append_character (' ')
					a_result.append (l_edges.item.node.name)
					if attached {HASH_TABLE [INTEGER, STRING]} l_edges.item.node.samples as l_samples then
						a_result.append_character (' ')
						a_result.append_character ('(')
						i := 0
						across l_samples as l_samps loop
							if i > 0 then
								a_result.append_character (',')
								a_result.append_character (' ')
							end
							a_result.append (l_samps.key)
							a_result.append_character ('=')
							a_result.append_integer (l_samps.item)
							i := i + 1
						end
						a_result.append_character (')')
					end
					a_result.append_character ('%N')
				else
					a_result.append_character ('%N')
					append_debug_output_for_node (l_edges.item.node, a_level + 1, a_result)
				end
			end
		end

	level_heading (a_count: INTEGER): STRING
			-- `a_count' number of tree level headings
		do
			create Result.make (10)
			across 1 |..| a_count as l_indexes loop
				Result.append (once "|   ")
			end
		end
end
