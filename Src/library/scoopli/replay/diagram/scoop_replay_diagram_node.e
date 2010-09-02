note
	description: "Node of SCOOP program structure. A SCOOP processor is a 'kernel' of node."
	author: "Andrey Nikonov, Andrey Rusakov"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_REPLAY_DIAGRAM_NODE
create
	make

feature

	make (a_tree : SCOOP_REPLAY_DIAGRAM; a_proc : SCOOP_PROCESSOR)
			-- Creating a new node - the entity of program structure
			-- to keep up the original processors relationships (parent<-child)
			-- We make a linear search in all nodes of tree.
		local
			l_parent_node, l_node : SCOOP_REPLAY_DIAGRAM_NODE
		do
			tree := a_tree
			processor := a_proc
			create features.make
			from
				tree.start
			until
				tree.after
			loop
				l_node := tree.item
				if l_node.processor = a_proc.parent_processor then
					l_parent_node := l_node
				end
				tree.forth
			end
			parent := l_parent_node
		end

	set_parent (a_parent: SCOOP_REPLAY_DIAGRAM_NODE)
			-- Set parent node for current node.
		do
			parent := a_parent
		end

	add (a_feature: SCOOP_REPLAY_DIAGRAM_FEATURE)
			-- Extend the feature list
		do
			features.extend ( a_feature )
		end

feature -- Implementation

	processor : SCOOP_PROCESSOR
		-- Kernel of node.

	features : LINKED_LIST [SCOOP_REPLAY_DIAGRAM_FEATURE]
		-- List of feature that have been executed by processor.

	parent : SCOOP_REPLAY_DIAGRAM_NODE
		-- Parent node.

	tree : SCOOP_REPLAY_DIAGRAM
		-- Link to the parent data structure.

end
