indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision: 1 $"

deferred class
	EGX_GRAPH_EDGE [N -> HASHABLE, L]

feature -- Access

	label: L
			-- Label of Current edge

	start_node: like node_type
			-- Start node of Current edge

	end_node: like node_type
			-- End node of Current edge

feature -- Status report

	is_valid_label (a_label: like label): BOOLEAN is
			-- Is `a_labe' valid?
		deferred
		end

feature{EGX_GRAPH} -- Setting

	set_label (a_label: like label) is
			-- Set `label' with `a_label'.
		require
			a_label_valid: is_valid_label (a_label)
		do
			label := a_label
		ensure
			label_set: label = a_label
		end

	set_nodes (a_start_node, a_end_node: like node_type) is
			-- Set `start_node' with `a_start_node' and `end_node' with `a_end_node'.
		require
			status_correct: (a_start_node /= Void implies a_end_node /= Void) and then
							(a_start_node = Void implies a_end_node = Void)
		do
			start_node := a_start_node
			end_node := a_end_node
		ensure
			start_node_set: start_node = a_start_node
			end_node_set: end_node = a_end_node
		end

feature{NONE} -- Implementation

	node_type: EGX_GRAPH_NODE [N, L] is
			-- Node type
		do
		end

invariant
	status_correct: (start_node /= Void implies (end_node /= Void)) and then ((start_node = Void) implies (end_node = Void))

end
