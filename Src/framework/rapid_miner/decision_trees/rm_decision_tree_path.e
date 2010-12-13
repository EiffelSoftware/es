note
	description: "Class that represents a path in a decision tree"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_DECISION_TREE_PATH

inherit
	HASHABLE

	DEBUG_OUTPUT

create
	make

feature{NONE} -- Initialization

	make (a_nodes: LINKED_LIST [RM_DECISION_TREE_PATH_NODE])
			-- Initialize Current.
		local
			l_rep: STRING
			i: INTEGER
		do
			nodes := a_nodes

				-- Calculate `hash_code'.
			create l_rep.make (128)
			if a_nodes.count = 1 then
				l_rep.append (a_nodes.first.debug_output)
			else
				across a_nodes as l_nodes loop
					if i > 0 then
						l_rep.append (once " and ")
					end
					l_rep.append_character ('(')
					l_rep.append (l_nodes.item.debug_output)
					l_rep.append_character (')')
					i := i + 1
				end
			end
			debug_output := l_rep
			hash_code := l_rep.hash_code
		end

feature -- Access

	nodes: LINKED_LIST [RM_DECISION_TREE_PATH_NODE]
			-- Nodes in Current path

	classification: STRING
			-- Final classification from Current path
		do
			Result := nodes.last.tree_node.name
		end

	hash_code: INTEGER
			-- Hash code value

	debug_output: STRING
			-- Debug output

feature -- Status report

	is_accurate_with_respect_to_training_data: BOOLEAN
			-- Is Current path accurate with respect to the training
			-- data used to build the decision tree for this path?
			-- Accuracy means that Current path correctly classifies
			-- all the training samples without any error.
		do
			Result := nodes.last.tree_node.is_accurate_with_respect_to_training_samples
		end

end
