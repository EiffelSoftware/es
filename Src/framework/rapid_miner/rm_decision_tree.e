note
	description: "Decision tree"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_DECISION_TREE

create
	make

feature{NONE} -- Initialization

	make (a_root: RM_DT_NODE)
		do
			root := a_root
		end

feature -- Clasification

	clasify (a_sample: HASH_TABLE [STRING, STRING])
			-- Use current tree to classify the instance given by `a_sample', store result in `last_classification'.			
			-- Key of `a_sample' is attribute name, value is the value of that attribute in `a_sample'.
		do
			last_classification := root.calculate_result (a_sample)
		end

feature -- Setting

	set_is_accurate (a_is_accurate: BOOLEAN)
			-- Set `is_accurate' with `a_is_accurate'.
		do
			is_accurate := a_is_accurate
		ensure
			is_accurate_set: is_accurate = a_is_accurate
		end

feature -- Access

	last_classification: STRING
			--

	root: RM_DT_NODE
			--

	path: LIST [LIST [RM_DECISION_TREE_PATH_NODE]]
			-- List of paths from current tree
			-- Eath inner list represents a path, the first element is the root node,
			-- the last element is the leaf node.
		do
		end

feature -- Status report

	is_accurate: BOOLEAN

end
