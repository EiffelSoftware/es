note
	description: "Represents a Control Flow Graph implemented as a doubly linked graph."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_CFG

create {CA_CFG_BUILDER}
	make

feature {NONE} -- Initialization

	make (a_start_label, a_end_label: INTEGER)
			-- Initialization for `Current' with label `a_start_label' for
			-- entry node and label `a_end_label' for exit node.
		require
			different_labels: a_start_label /= a_end_label
			valid_labels: is_valid_label (a_start_label) and is_valid_label (a_end_label)
		do
			create start_node.make (a_start_label)
			create end_node.make (a_end_label)
		end

feature -- Properties

	start_node, end_node: CA_CFG_SKIP
			-- First and last node of CFG.

	max_label: INTEGER
			-- Largest number used for labels.

	is_valid_label (a_label: INTEGER): BOOLEAN
			-- Is `a_label' within the valid range for a node label?
		do
			Result := a_label >= 1
				-- At least `1' for use in data structures.
		end

feature {CA_CFG_BUILDER} -- Utilities

	set_max_label (a_max: INTEGER)
			-- Set largest number used for labels.
		do
			max_label := a_max
		end

end
