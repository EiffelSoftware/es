indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision: 1 $"

class
	EGX_GENERAL_GRAPH_EDGE [N -> HASHABLE, L]

inherit
	EGX_GRAPH_EDGE [N, L]
		redefine
			node_type
		end

create
	make

feature{NONE} -- Initialization

	make (a_label: like label) is
			-- Initialize `label' with `a_labe'.
		require
			a_label_valid: is_valid_label (a_label)
		do
			set_label (a_label)
		ensure
			label_set: label = a_label
		end

feature -- Status report

	is_valid_label (a_label: like label): BOOLEAN is
			-- Is `a_labe' valid?
		do
			Result := True
		ensure then
--			good_result: Result = a_label /= Void
		end

feature{NONE} -- Implementation

	node_type: EGX_GENERAL_GRAPH_NODE [N, L] is
			-- Node type
		do
		end

end
