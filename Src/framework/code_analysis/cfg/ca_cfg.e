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
			-- Initialization for `Current'.
		do
			create start_node.make (a_start_label)
			create end_node.make (a_end_label)
		end

feature -- Properties

	start_node, end_node: CA_CFG_SKIP

	max_label: INTEGER

	set_max_label (a_max: INTEGER)
		do
			max_label := a_max
		end

end
