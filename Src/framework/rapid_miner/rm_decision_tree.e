note
	description: "Represents a decision tree."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_DECISION_TREE

create
	make

feature{NONE} -- Initialization

	make (a_root: RM_DECISION_TREE_NODE; a_label_name: STRING)
			-- `a_root' the root of the tree
			-- `a_label_name' the target attribute's name for this tree
		do
			internal_is_accurate := True
			calculate_is_accurate := True
			root := a_root
			label_name := a_label_name
			create stack.make
		end

feature -- Access

	last_classification: STRING
			-- last result from the classify command.

	root: RM_DECISION_TREE_NODE
			-- the root node of the tree.

	label_name: STRING
			-- the name of the target attribute of that  tree

	paths: LINKED_LIST [LINKED_LIST [RM_DECISION_TREE_PATH_NODE]]
			-- List of paths from current tree
			-- Eath inner list represents a path, the first element is the root node,
			-- the last element is the leaf node.
		do
			if paths_internal = Void then
				stack.wipe_out
				create paths_internal.make
				paths_internal.wipe_out
				calculate_paths (root)
			end
			Result := paths_internal
		end

feature -- Status report

	is_accurate: BOOLEAN
			-- Is Current tree accurate?
			-- A tree is accurate if it does correct classification on all training samples.
		do
			if calculate_is_accurate then
				Result := root.is_sample_accurate
			else
				Result := internal_is_accurate
			end
		end

feature -- Clasification

	classify (a_sample: HASH_TABLE [STRING, STRING])
			-- Use current tree to classify the instance given by `a_sample', store result in `last_classification'.			
			-- Key of `a_sample' is attribute name, value is the value of that attribute in `a_sample'.
		do
			last_classification := root.classification (a_sample)
		end

feature{RM_DECISION_TREE_BUILDER} -- Setting

	set_is_accurate (a_is_accurate: BOOLEAN)
			-- Set `is_accurate' with `a_is_accurate'.
		do
			internal_is_accurate := a_is_accurate
			calculate_is_accurate := False
		ensure
			is_accurate_set: is_accurate = a_is_accurate
		end


feature{NONE} -- Internal data holders

	calculate_is_accurate: BOOLEAN
			-- This variable tells if we have to calculate the `is_accurate' feature
			-- by going to all the leaves and checking out the samples or we can use
			-- the `internal_is_accurate' variable. If we use the `set_is_accurate'
			-- feature then the `calculate_is_accurate' will be false else true.

	internal_is_accurate: BOOLEAN
			-- If we manually set the accuracy of the tree this is where we store it.

	paths_internal: detachable like paths
			-- Internal variable used to hold the intermediate paths calculated in `calculate_paths'

	stack: LINKED_STACK [RM_DECISION_TREE_PATH_NODE]
			-- While we dfs traverse the tree we need to keep the previous nodes so that we can
			-- print the whole path when we reach a leaf node.

feature{NONE} -- Implementation

	calculate_paths (current_node: RM_DECISION_TREE_NODE)
			-- Traverses the tree in a DFS manner. When a leaf node is encountered the stack is saved into the paths variable.
		local
			l_node: RM_DECISION_TREE_PATH_NODE
		do
			if current_node.is_leaf then
				create l_node.make (label_name, "=", current_node.name)
				stack.put (l_node)
				save_stack
				stack.remove
			else
				from current_node.edges.start until current_node.edges.after loop
					create l_node.make (current_node.name, current_node.edges.item_for_iteration.operator, current_node.edges.item_for_iteration.value)
					stack.put (l_node)
					calculate_paths (current_node.edges.item_for_iteration.node)
					stack.remove
					current_node.edges.forth
				end
			end
		end

	save_stack
			-- Saves the stack into the paths variable.
		local
			l_list: LINKED_LIST [RM_DECISION_TREE_PATH_NODE]
			l_array: ARRAYED_LIST [RM_DECISION_TREE_PATH_NODE]
		do
			create l_list.make
			l_array := stack.linear_representation
			from l_array.finish until l_array.before loop
				l_list.force (l_array.item_for_iteration)
				l_array.back
			end
			paths_internal.force (l_list)
		end

end
